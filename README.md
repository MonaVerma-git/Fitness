# Workout Tracker App

## Overview
This Flutter application is designed to track workouts. It follows a Clean Architecture approach, which promotes a clear separation of concerns and enhances maintainability and scalability.

## Architectural Choices

### Clean Architecture
The application is structured according to the Clean Architecture principles, which include:

1. **Separation of Concerns**: The application is divided into distinct layers:
   - **Presentation Layer**: This layer contains the UI components, including screens and widgets. It handles user interactions and displays data.
   - **Domain Layer**: The core logic resides here. It includes entities, use cases, and interfaces. This layer is independent of the presentation and data layers.
   - **Data Layer**: This layer handles data sources, including local storage. It implements repositories that provide data to the domain layer.

2. **Independence**: Each layer can evolve independently. For instance, changes in the UI won't affect the domain logic.

3. **Testability**: With clear boundaries between layers, unit testing becomes easier. Each component can be tested in isolation.

### Third-Party Packages
The following third-party packages have been utilized in this project:

- **Flutter Bloc**: This package manages state efficiently and provides a clear structure for implementing the BLoC (Business Logic Component) pattern. It allows the separation of UI from business logic, making the app more modular and testable.
  
- **Shared Preferences**: Used for local storage, this package helps to persist simple data like user settings and workout records. It provides a simple API for saving and retrieving key-value pairs.
  
- **Collection**: This package is used for grouping and manipulating collections more easily, which simplifies data handling in the app.

## Test Coverage

### Overview
The application includes comprehensive unit and integration tests to ensure functionality and reliability. Tests are written for the presentation, domain, and data layers to confirm that each component behaves as expected.

### Coverage Report
Test coverage is measured using the built-in Flutter testing tools. As of the latest run, the coverage report shows:

- **Overall Coverage**: 70%
- **Presentation Layer**: 75%
- **Domain Layer**: 60%
- **Data Layer**: 85%

### Running Tests
To run the tests and check the coverage, use the following command:
```bash
flutter test --coverage

## Conclusion
The architectural choices made in this project aim to create a robust, maintainable, and scalable application. Clean Architecture provides a solid foundation for future enhancements and integrations.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/MonaVerma-git/Fitness.git

2. Navigate to the project directory:
   ```bash
   cd workout_tracker

3. Install dependencies:
    ```bash
    flutter pub get

4. Run the application:
    ```bash
    flutter run

