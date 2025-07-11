# Maternal Care

A comprehensive Flutter application designed to support expectant mothers throughout their pregnancy journey. Maternal Care provides personalized pregnancy tracking, health tips, appointment management, and a supportive community platform.

## Features

### User Authentication
- Secure signup and login using Supabase authentication
- Profile creation and management
- Password recovery options

### Personalized Pregnancy Tracking
- Due date calculator and pregnancy week tracking
- Trimester information and progress visualization
- Personalized health metrics monitoring (weight, blood pressure, etc.)

### Health Management
- Appointment scheduling and reminders
- Medication tracking
- Health tips and articles tailored to pregnancy stage

### Community Support
- Discussion forums for expectant mothers
- Expert advice sections
- Experience sharing platform

### Additional Tools
- Contraction timer
- Kick counter
- Hospital bag checklist
- Birth plan creator

## Technical Details

### Architecture
- Flutter for cross-platform mobile development
- Provider pattern for state management
- Supabase for backend services (authentication, database, storage)

### Database Structure
- User profiles with pregnancy information
- Appointments and reminders
- Community posts and comments
- Health records and metrics

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode for mobile development
- Supabase account for backend services

### Installation
1. Clone the repository
   ```
   git clone https://github.com/MugilMs/Meternal_Care.git
   ```

2. Navigate to the project directory
   ```
   cd Meternal_Care
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Configure Supabase
   - Create a `lib/config/supabase_config.dart` file with your Supabase credentials
   - Run the SQL scripts in the `supabase` directory to set up the database schema

5. Run the application
   ```
   flutter run
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- All contributors and testers
