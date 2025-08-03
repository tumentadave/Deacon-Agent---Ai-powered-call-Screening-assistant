# DEACON AI - Intelligent Call Screening App

An AI-powered call screening application built with Flutter that uses OpenAI's advanced AI capabilities to analyze incoming calls and provide intelligent screening decisions.

## Features

### 🤖 AI-Powered Call Analysis
- **Real-time Speech Recognition**: Convert incoming call audio to text using OpenAI Whisper
- **Purpose Detection**: Automatically identify the caller's intent and purpose
- **Risk Assessment**: Evaluate potential spam, telemarketing, or legitimate calls
- **Confidence Scoring**: Get reliability scores for AI predictions

### 📱 Smart Call Management
- **Intelligent Screening**: Accept, decline, or send calls to voicemail based on AI analysis
- **Emergency Bypass**: Allow important calls to bypass screening automatically
- **Custom Sensitivity**: Adjust AI screening sensitivity to your preferences
- **Call History**: Review past calls with AI analysis data

### 🎨 Enhanced UI/UX
- **Improved Color Scheme**: Better contrast and visibility for all screen elements
- **Responsive Design**: Optimized for various device sizes
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Accessibility**: Enhanced color contrast and text readability

### 🔧 OpenAI Integration
- **Multiple AI Models**: Support for GPT-4, Whisper, and other OpenAI services
- **Real-time Processing**: Live analysis of ongoing calls
- **Multilingual Support**: Handle calls in 99+ languages
- **Voice Analysis**: Advanced speech pattern recognition

## Setup Instructions

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.0 or higher
- OpenAI API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd deacon_ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure OpenAI API Key**
   
   You have two options:

   **Option A: Environment Variable (Recommended)**
   ```bash
   flutter run --dart-define=OPENAI_API_KEY=your-openai-api-key-here
   ```

   **Option B: Update env.json (Development)**
   ```json
   {
     "OPENAI_API_KEY": "your-openai-api-key-here"
   }
   ```

4. **Run the application**
   ```bash
   flutter run --dart-define=OPENAI_API_KEY=your-openai-api-key-here
   ```

### Getting OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign up or log in to your account
3. Navigate to API Keys section
4. Click "Create new secret key"
5. Copy the generated key and use it in your configuration

## Project Structure

```
lib/
├── core/
│   └── app_export.dart          # Core exports and utilities
├── presentation/               # UI screens and widgets
│   ├── settings/              # Settings and configuration
│   ├── incoming_call_screen/  # Main call screening interface
│   └── ai_service_configuration/ # AI service setup
├── services/                  # Business logic and API services
│   ├── openai_service.dart    # OpenAI service configuration
│   └── openai_client.dart     # OpenAI API client implementation
├── theme/
│   └── app_theme.dart         # Enhanced theme configuration
├── widgets/                   # Reusable UI components
└── routes/
    └── app_routes.dart        # App navigation routes
```

## OpenAI Features Implemented

### 1. Speech-to-Text (Whisper)
- Real-time audio transcription
- Multi-language support
- Noise reduction and accent handling

### 2. Call Analysis (GPT-4)
- Purpose detection and categorization
- Confidence scoring
- Risk assessment
- Intent classification

### 3. Intelligent Decision Making
- Automated screening recommendations
- Context-aware responses
- Learning from user preferences

## Configuration Options

### AI Service Settings
- **Provider Selection**: Choose between OpenAI and fallback services
- **Processing Timeout**: Configure maximum analysis time
- **Accuracy Preference**: Balance between speed and accuracy
- **Offline Fallback**: Enable backup processing when API is unavailable

### Call Screening Settings
- **Sensitivity Levels**: Adjust how strict the AI screening should be
- **Emergency Bypass**: Configure automatic acceptance for emergency calls
- **Custom Categories**: Define specific call types for special handling

## Usage

1. **Initial Setup**
   - Launch the app and complete the onboarding process
   - Configure your OpenAI API key in AI Service Configuration
   - Test the connection to ensure proper setup

2. **Call Screening**
   - When a call comes in, the app automatically begins analysis
   - View real-time transcription and AI processing status
   - Make informed decisions based on AI recommendations

3. **Settings Management**
   - Adjust screening sensitivity in Settings
   - Manage blocked numbers and preferences
   - Configure emergency bypass rules

## Troubleshooting

### Common Issues

**OpenAI API Connection Failed**
- Verify your API key is correct and active
- Check your internet connection
- Ensure you have sufficient API credits

**App Not Intercepting Calls**
- Grant necessary permissions during setup
- Check default phone app settings
- Verify accessibility services are enabled

**Poor Transcription Quality**
- Ensure good network connection
- Check microphone permissions
- Consider adjusting sensitivity settings

## Privacy & Security

- **Local Processing**: Sensitive data processed locally when possible
- **Encrypted Transmission**: All API communications use HTTPS
- **No Data Storage**: Call content is not permanently stored
- **User Control**: Complete control over data sharing preferences

## Support

For issues and questions:
- Check the in-app FAQ section
- Review troubleshooting guides
- Contact support through the app settings

## License

This project is proprietary software. All rights reserved.

---

**Note**: This app requires an active OpenAI API key to function properly. Usage charges apply based on OpenAI's pricing structure.