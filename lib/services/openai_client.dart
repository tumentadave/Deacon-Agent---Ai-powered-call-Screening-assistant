import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response
  /// Sends a POST request to /chat/completions with messages and model.
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Streams a text response
  /// Uses server-sent events (SSE) from /chat/completions with stream=true.
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          'stream': true,
          if (options != null) ...options,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';
          final finishReason = json['choices'][0]['finish_reason'];
          final systemFingerprint = json['system_fingerprint'];

          yield StreamCompletion(
            content: content,
            finishReason: finishReason,
            systemFingerprint: systemFingerprint,
          );

          // If finish reason is provided, this is the final chunk
          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  // A more user-friendly wrapper for streaming that just yields content strings
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    await for (final chunk in streamChatCompletion(
      messages: messages,
      model: model,
      options: options,
    )) {
      if (chunk.content.isNotEmpty) {
        yield chunk.content;
      }
    }
  }

  /// List of available OpenAI models.
  /// Sends a GET request to /models to fetch model IDs.
  Future<List<String>> listModels() async {
    try {
      final response = await dio.get('/models');
      final models = response.data['data'] as List;
      return models.map((m) => m['id'] as String).toList();
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Vision API (image analysis)
  /// Supports both imageUrl and local image files (as base64).
  Future<Completion> generateTextFromImage({
    String? imageUrl,
    Uint8List? imageBytes,
    String promptText = 'Describe the scene in this image:',
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      if (imageUrl == null && imageBytes == null) {
        throw ArgumentError('Either imageUrl or imageBytes must be provided');
      }

      final List<Map<String, dynamic>> content = [
        {'type': 'text', 'text': promptText},
      ];

      // Add image content based on what was provided
      if (imageUrl != null) {
        content.add({
          'type': 'image_url',
          'image_url': {'url': imageUrl}
        });
      } else if (imageBytes != null) {
        // Convert image bytes to base64
        final base64Image = base64Encode(imageBytes);
        content.add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
        });
      }

      final messages = [
        Message(role: 'user', content: content),
      ];

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Speech-to-Text (STT)
  /// Transcribes audio to text using the Whisper model.
  Future<Transcription> transcribeAudio({
    required File audioFile,
    String model = 'whisper-1',
    String? prompt,
    String responseFormat = 'json',
    String? language,
    double? temperature,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
        'model': model,
        if (prompt != null) 'prompt': prompt,
        'response_format': responseFormat,
        if (language != null) 'language': language,
        if (temperature != null) 'temperature': temperature,
      });

      final response = await dio.post(
        '/audio/transcriptions',
        data: formData,
      );

      if (responseFormat == 'json') {
        return Transcription(text: response.data['text']);
      } else {
        return Transcription(text: response.data.toString());
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Analyze call purpose using OpenAI
  Future<CallAnalysis> analyzeCallPurpose({
    required String transcribedText,
    String? callerNumber,
    String? callerName,
  }) async {
    try {
      final systemPrompt = '''
You are an AI assistant that analyzes phone call transcripts to determine the caller's purpose and legitimacy. 
Analyze the following call transcript and provide:
1. The main purpose of the call
2. A confidence score (0-100)
3. A category (business, personal, spam, telemarketing, emergency, unknown)
4. A brief risk assessment

Respond in JSON format with these exact keys: purpose, confidence, category, riskLevel
''';

      final userPrompt = '''
Caller: ${callerName ?? 'Unknown'} (${callerNumber ?? 'Unknown number'})
Transcript: $transcribedText
''';

      final messages = [
        Message(role: 'system', content: systemPrompt),
        Message(role: 'user', content: userPrompt),
      ];

      final response = await createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.3},
      );

      final analysisJson = jsonDecode(response.text);

      return CallAnalysis(
        purpose: analysisJson['purpose'] ?? 'Unknown purpose',
        confidence: (analysisJson['confidence'] ?? 0).toDouble(),
        category: analysisJson['category'] ?? 'unknown',
        riskLevel: analysisJson['riskLevel'] ?? 'low',
      );
    } catch (e) {
      // Fallback analysis if OpenAI fails
      return CallAnalysis(
        purpose: 'Unable to analyze call purpose',
        confidence: 0.0,
        category: 'unknown',
        riskLevel: 'unknown',
      );
    }
  }
}

/// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

class Transcription {
  final String text;

  Transcription({required this.text});
}

class CallAnalysis {
  final String purpose;
  final double confidence;
  final String category;
  final String riskLevel;

  CallAnalysis({
    required this.purpose,
    required this.confidence,
    required this.category,
    required this.riskLevel,
  });
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}
