# SpaceX Tracker

**A Flutter application to track all SpaceX launches, built as part of the Mobile Development course at IMT Atlantique.**

This project demonstrates a robust, feature-rich mobile application built with modern Flutter best practices, focusing on clean architecture, advanced state management, and a polished user experience.

---

## ✨ Features

- **Onboarding**: A welcoming, one-time onboarding flow for new users.
- **Launch List**: Fetches and displays all SpaceX launches with infinite scrolling.
- **Grid & List Views**: Toggle between a compact grid view and a detailed list view.
- **Server-Side Search**: A powerful search bar that queries the SpaceX API directly.
- **Pull-to-Refresh**: A native pull-to-refresh gesture to update the launch list.
- **Launch Details**: A dedicated screen with in-depth information about each launch, including rocket specs and an image gallery.
- **Favorites System**: Mark launches as favorites and view them in a dedicated list. Favorite status is persisted on the device.
- **Settings**: A dedicated settings page to customize the app theme.
- **Theme Customization**: Choose between Light, Dark, and System themes. Your preference is saved locally.
- **Immersive UI**: A full-screen experience with a custom dark theme and font.

---

## 🚀 Architecture & Technical Highlights

This project was built with a strong emphasis on clean, scalable, and maintainable code.

- **Feature-Driven Architecture**: The codebase is organized into features (`launches`, `favorites`, `onboarding`, etc.), making it modular and easy to navigate.
- **Advanced State Management**: State is managed using the `flutter_bloc` package, following best practices:
  - **Sealed Class States**: All complex states (`LaunchesState`, `FavoritesState`) are modeled using `sealed classes` for maximum type safety and compile-time checks.
  - **Dedicated Cubits**: Each piece of state is managed by its own dedicated Cubit (`LaunchesCubit`, `ThemeCubit`, `ViewModeCubit`), respecting the Single Responsibility Principle.
- **Centralized Services**: All interactions with external services (API, local storage) are handled by dedicated service classes (`LaunchService`, `StorageService`, `FavoriteService`), ensuring a clean separation of concerns.
- **Dependency Injection**: Dependencies (like services) are injected into the Cubits, making the code decoupled and highly testable.
- **Clean UI Code**: The UI is built with a clear separation between presentation logic and business logic. Helper methods (`_buildBody`) are used to keep the build methods readable, and reusable components (`LaunchListItem`, `ThemeRadioTile`) are extracted into their own files.

---

## 📦 Key Packages Used

- **State Management**: `flutter_bloc`, `equatable`
- **Networking**: `http`
- **Local Storage**: `shared_preferences`
- **UI & Theming**: `google_fonts`, `cached_network_image`, `url_launcher`
- **Code Generation (Dev)**: `flutter_launcher_icons`
- **Formatting**: `intl`

---

## ⚙️ Setup & Installation

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    cd space_x
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the application:**
    ```sh
    flutter run
    ```

---

## ❤️ Credits

- **Developed with ❤️ by Pacôme**
- **Data**: All launch data is provided by the excellent, unofficial [SpaceX-API on GitHub](https://github.com/r-spacex/SpaceX-API).
