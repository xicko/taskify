# Taskify 

Taskify is a Flutter-based to-do list application with features for managing personal and public lists. The app is built with Supabase for the backend and GetX for state management, providing a seamless user experience.

<div style="display:flex;justify-content:center;flex-direction: row;flex-wrap: nowrap;">
  <img src="https://dl.dashnyam.com/taskify_ss/1.webp" width="150" />
  <img src="https://dl.dashnyam.com/taskify_ss/2.webp" width="150" />
  <img src="https://dl.dashnyam.com/taskify_ss/3.webp" width="150" />
  <img src="https://dl.dashnyam.com/taskify_ss/4.webp" width="150" />
  <img src="https://dl.dashnyam.com/taskify_ss/5.webp" width="150" />
</div>

## Features

### Core Features
- **User Authentication**: Sign up, log in, and manage accounts with Supabase authentication.
- **Private and Public Lists**: Create private lists by default with the option to make them public.
- **List Management**:
  - Create, edit, and delete lists.
  - Search functionality for lists.
- **Discover Page**: View all public lists with their creator’s name.
- **Account Management**:
  - Update email and password.
  - Export all lists as a JSON file.
  - Delete all lists at once.

### Additional Features
- **Client-Side Filtering**: Ensures public lists do not contain forbidden words.
- **Date Sorting**: Lists are displayed in descending order by creation date.
- **Responsive UI**: Fully functional modal for list display and editing.

### Upcoming Features
- Offline list saving.
- Network detection for offline mode.

### Web Version
A web version of the app is under development at: [https://taskify.dashnyam.com](https://taskify.dashnyam.com), built using Next.js

## Project Setup

### Prerequisites
- Flutter installed on your system.
- Supabase account and project for backend services.
- Supabase URL and Anon Key.
- API keys for APK signing (optional for development).

### Setup Instructions
1. Clone the repository.
2. Set up Supabase authentication info:
   - Create a file `/lib/auth/auth_key.dart`.
   - Refer to the example provided in `/lib/auth/auth_key_example.dart`.
3. Customize forbidden words:
   - Create a file `/lib/constants/forbidden_words.dart`.
   - Refer to the example provided in `/lib/constants/forbidden_words_example.dart`.
4. (Optional) Set up APK signing keys for release builds:
   - Create the file `/android/key.properties` using `/android/key_example.properties` as a template.
   - Put your `.jks` or `.keystore` file in `/android/app/`.
5. Run the app:
   ```bash
   flutter pub get
   flutter run
   ```

## Folder Structure
The project is organized as follows:

```
lib/
|-- auth/                 # Authentication logic and examples
|-- constants/            # App-wide constants and configuration
|-- controllers/          # GetX controllers
|-- screens/              # UI screens
|-- theme/                # Styling and themes
|-- widgets/              # Reusable widgets
```

## Release Builds
You can download the latest release APK for Taskify from the [GitHub Releases](https://github.com/taskify/releases).

## Contributing
Contributions are welcome! Please create an issue or submit a pull request for any bug fixes or new features.

## License
This project is open-source and available under the MIT License.
