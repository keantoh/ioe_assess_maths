# ASSESS Maths

**ASSESS Maths** is an educational app designed to assess children's mathematical abilities through interactive questions. Built with **Flutter** for cross-platform support, **FastAPI** for the back-end, and **Azure SQL** for data storage, this app offers an engaging and user-friendly experience aimed at helping parents track their children's progress in math.

## Key Features
- **Interactive Assessments**: Fun and engaging math questions for children.
- **Cross-Platform**: Developed using Flutter to support both iOS and Android.
- **Customizable Themes**: Personalize the app’s theme color based on the child's preferences.
- **Gamification**: Features like progress tracking, stars, and feedback messages to motivate users.
- **Multi-language Support**: App supports multiple languages based on the device locale.
- **Secure Data Management**: Data stored securely using **Azure SQL** with encryption.

## Getting Started

To run the app locally:
1. Clone the repository
2. Navigate to lib/src/config.dart to configure the API_URL variable depending on the environment and platform type.
3. Download and install Flutter from https://docs.flutter.dev/get-started/install
4. Run "flutter doctor" to to resolve issues or install additional dependencies.
5. Install project dependencies by running "flutter pub get".
6. Navigate to the ios folder and run "pod install" to install iOS specific dependencies.
7. Ensure that an iOS simulator or an Android emulator is running, which can be launched from XCode or Android Studio, respectively.
8. Start the app by running "flutter run".
