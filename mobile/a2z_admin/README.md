# A2Z Smart Lending Admin (Mobile)

A2Z Smart Lending Admin is a Flutter-based mobile application for administrators to manage and monitor lending activities, view statistics, and leverage AI-powered risk prediction for loans.

## Features
- **Authentication**: Secure login/logout for admin users.
- **Dashboard**: Overview of total loans, active, overdue, completed loans, total loan value, and revenue.
- **Recent Loans**: View a list of the most recent loans with quick access to details.
- **AI Risk Prediction**: Predict loan risk using AI models.
- **Create Loan**: (UI placeholder) for adding new loans.
- **Profile & Settings**: (UI placeholder) for user profile and app settings.

## Screenshots
> _Add screenshots here if available._

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.4.1 <4.0.0)
- Dart SDK (compatible with Flutter version)
- Android Studio/Xcode for mobile builds

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/buuhq-it/a2z-smart-lending-platform.git
   cd a2z-smart-lending-platform/mobile/a2z_admin
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```
   _You can specify a device or use an emulator/simulator._

## Project Structure
```
lib/
  main.dart                # App entry point, authentication wrapper
  models/                  # Data models (dashboard, login, prediction)
  pages/                   # UI pages (home, login, risk prediction)
  services/                # API and local storage services
  widgets/                 # Reusable UI components
```

## Key Dependencies
- [flutter](https://flutter.dev/) - UI toolkit
- [http](https://pub.dev/packages/http) - HTTP requests
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local storage
- [intl](https://pub.dev/packages/intl) - Internationalization/formatting

## Customization
- Update API endpoints and logic in `lib/services/` as needed for your backend.
- UI and business logic can be extended in `lib/pages/` and `lib/widgets/`.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
_This project is currently private. Add license information here if open-sourcing._
