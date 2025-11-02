# Atomic Design Components

This project follows the Atomic Design methodology for organizing UI components.

## Structure

```
lib/components/
├── atoms/           # Basic building blocks
│   ├── custom_button.dart
│   ├── custom_text.dart
│   └── custom_image.dart
├── molecules/       # Combinations of atoms
│   └── product_card.dart
├── organisms/       # Complex UI sections
│   └── custom_app_bar.dart
├── templates/       # Page-level layouts
│   └── main_template.dart
└── components.dart  # Barrel export file
```

## Levels

### Atoms
- **CustomButton**: Reusable button component with consistent styling
- **CustomText**: Text component with consistent typography
- **CustomImage**: Image component with loading states and error handling

### Molecules
- **ProductCard**: Product display component combining image, text, and button atoms

### Organisms
- **CustomAppBar**: Application header with navigation elements

### Templates
- **MainTemplate**: Page layout template with consistent structure

## Usage

Import all components using the barrel export:

```dart
// import 'package:feiragreen_flutter/components/components.dart';
// import 'package:feiragreen_flutter/components/atoms/custom_button.dart';
// import 'package:feiragreen_flutter/components/molecules/product_card.dart';
```

## Benefits

- **Modularity**: Components are reusable across the application
- **Consistency**: Standardized styling and behavior
- **Maintainability**: Changes to components affect the entire application
- **Scalability**: Easy to add new components following the same pattern
- **Testing**: Each component can be tested independently
