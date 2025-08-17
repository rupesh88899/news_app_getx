# RK News App 📱

A modern, feature-rich news application built with Flutter and GetX state management. Stay updated with the latest news from around the world with a beautiful, intuitive interface.

## 🌟 Features

### Core Features
- **Latest News**: Get the most recent news from various sources
- **Category News**: Browse news by categories (Business, Sports, Health, Technology, etc.)
- **Search Functionality**: Search for specific news topics
- **News Reading**: Full article view with WebView integration
- **Offline Support**: Cached images for better performance

### UI/UX Features
- **Material Design 3**: Modern, clean interface
- **Dark/Light Theme**: Automatic theme switching based on system preference
- **Pull-to-Refresh**: Easy content refreshing
- **Carousel Headlines**: Featured news carousel on home screen
- **Responsive Design**: Optimized for different screen sizes
- **Loading States**: Beautiful loading animations and progress indicators

### Technical Features
- **GetX State Management**: Reactive programming with efficient state management
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **API Rate Limiting**: Smart API key rotation and rate limit handling
- **Image Caching**: Efficient image loading and caching
- **Navigation**: Smooth page transitions with GetX routing
- **Dependency Injection**: Clean architecture with GetX bindings


## 🚀 Getting Started

### Prerequisites
- Flutter SDK (">=3.0.0<4.0.0")
- Dart SDK
- Android Studio / VS Code
- A device or emulator for testing

### API Setup
1. Get a free API key from [NewsAPI.org](https://newsapi.org/)
2. Replace the API keys in `lib/services/api_service.dart`:
```dart
static const String _apiKey1 = 'YOUR_API_KEY_1';
static const String _apiKey2 = 'YOUR_API_KEY_2';
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/rk-news-app.git
cd rk-news-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── bindings/
│   └── initial_bindings.dart      # GetX dependency injection
├── controllers/
│   └── news_controller.dart       # State management logic
├── models/
│   └── news_model.dart            # Data models
├── services/
│   └── api_service.dart           # API communication
├── views/
│   ├── screens/
│   │   ├── home_screen.dart       # Main screen
│   │   ├── category_screen.dart   # Category/Search results
│   │   └── news_view_screen.dart  # Article reader
│   └── widgets/
│       ├── news_card.dart         # News item widget
│       ├── category_chip.dart     # Category selector
│       ├── search_bar.dart        # Search input
│       ├── loading_widget.dart    # Loading states
│       ├── empty_state_widget.dart # Empty states
│       └── section_header.dart    # Section headers
├── core/
│   └── theme/
│       └── app_theme.dart         # App theming
└── utils/
    └── constants.dart             # App constants
```

## 🏗️ Architecture

This app follows the **MVC (Model-View-Controller)** pattern with GetX:

- **Models**: Data structures and business logic
- **Views**: UI components and screens
- **Controllers**: State management and business logic
- **Services**: External API communication
- **Bindings**: Dependency injection setup

### Key Architectural Decisions

1. **GetX for State Management**: Chosen for its simplicity, performance, and reactive programming capabilities
2. **Service Layer**: Separate API logic from UI logic for better testability
3. **Reusable Widgets**: Modular UI components for consistency and maintainability
4. **Error Handling**: Centralized error handling with user-friendly feedback
5. **Theme Management**: Centralized theming for easy customization

## 🔧 Dependencies

### Core Dependencies
- `flutter`: Flutter framework
- `get`: ^4.6.6 - State management, dependency injection, and routing
- `cached_network_image`: ^3.4.1 - Image caching and loading

### UI Dependencies
- `carousel_slider`: ^4.2.1 - Image carousel for featured news
- `webview_flutter`: ^4.10.0 - In-app web browser for articles

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: ^5.0.0 - Dart linting rules

## 🎨 Customization

### Changing Theme Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF2196F3); // Your primary color
static const Color accentColor = Color(0xFF03DAC6);  // Your accent color
also check for light mode(added)
```

### Adding New Categories
Edit `lib/controllers/news_controller.dart`:
```dart
final List<String> categories = [
  'Top News',
  'Business',
  'Your New Category', // Add here
  // ... other categories
];
```

### Modifying API Endpoints
Edit `lib/services/api_service.dart` to change news sources or add new endpoints.

## 🚨 Error Handling

The app includes comprehensive error handling for:
- **Network Errors**: Internet connectivity issues
- **API Errors**: Rate limiting, invalid keys, server errors
- **Data Errors**: Malformed responses, missing images
- **User Errors**: Empty searches, invalid inputs

All errors are displayed to users via contextual snackbars with appropriate actions.

## 🧪 Testing

Run tests with:
```bash
flutter test
```

### Test Coverage
- Unit tests for controllers and services
- Widget tests for reusable components
- Integration tests for user flows

## 📈 Performance Optimizations

1. **Image Caching**: Using `cached_network_image` for efficient image loading
2. **Lazy Loading**: ListView.builder for efficient scrolling
3. **State Management**: GetX's reactive programming reduces unnecessary rebuilds
4. **API Optimization**: Smart API key rotation and request batching
5. **Memory Management**: Proper disposal of controllers and resources

## 🔒 Security Features

- **HTTPS Enforcement**: All HTTP URLs are converted to HTTPS
- **API Key Protection**: API keys should be moved to environment variables for production
- **Input Validation**: All user inputs are validated and sanitized
- **Safe Navigation**: WebView restrictions for secure browsing

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style and architecture
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## 📋 Roadmap

### Version 2.0
- [ ] Bookmarks and favorites
- [ ] Push notifications
- [ ] Offline reading
- [ ] Social sharing
- [ ] User preferences and settings
- [ ] Multiple language support
- [ ] Voice search

### Version 3.0
- [ ] AI-powered news recommendations
- [ ] Comment system
- [ ] User accounts and profiles
- [ ] Real-time news updates
- [ ] Video news support

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ruepsh Kumar Tiwari**
- GitHub: [@yourusername](https://github.com/rupesh88899)
- LinkedIn: [Your LinkedIn](https://www.linkedin.com/in/rupesh-kumar-tiwari-21331a245/)
- Email: rupesh888999.work@gmail.com

## 🙏 Acknowledgments

- [NewsAPI.org](https://newsapi.org/) for providing the news data
- [Flutter team](https://flutter.dev/) for the amazing framework
- [GetX community](https://pub.dev/packages/get) for the excellent state management solution
- All contributors who help improve this project

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/rk-news-app/issues) page
2. Create a new issue with detailed information
3. Contact the maintainer directly

---

**⭐ If you find this project helpful, please give it a star!**
