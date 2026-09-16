# Enterprise Flutter & Dart Standards (Vibecode Edition)

## Core Architecture & Engineering
1. **Clean Architecture Strictness**:
   - Presentation: BLoC / Cubit. State Management MUST use Single Immutable State pattern with `copyWith` and Enums for status tracking (never subclass state classes).
   - Domain: Pure Dart. Entities, UseCases (Single Responsibility), Repository Contracts. Zero Flutter/UI or Data/External dependencies.
   - Data: DTOs, DataSources, Repository Implementations.
   - Core: Singletons, Failures, Router, Network Clients, Themes, DI (GetIt).

2. **Code Quality & Modern Practices**:
   - Use latest Flutter/Dart features (Null Safety, Pattern Matching, Records, Extension Types where appropriate).
   - Absolute Immutability: Use `final` for class fields, `const` constructors, and immutable collections where feasible.
   - Strict Typing: `dynamic` or loose `Object?` are strictly prohibited without runtime type checking.
   - Error Handling: Functional handling using `Either` or `Result` types for clean failure propagation.

3. **Design System & UI/UX Guidelines (Fallback Visuals)**:
   - **Modern Aesthetic**: When no brand/visual identity is supplied, generate clean, premium, and calm UI/UX design tokens.
   - **Color Palette**: Eye-pleasing, low-saturation backgrounds (e.g., Off-White `#F8F9FA`, Charcoal Dark `#121212`), matched with elegant primary accents (Teal, Slate, Deep Emerald, or Indigo). Avoid high-contrast harsh primary colors.
   - **Typography & Layout**: Consistent spacing scales (4-8px base unit), subtle border-radii (12-16px), minimal drop-shadows, and smooth micro-animations.
   - **Responsiveness**: Ensure Adaptive Layouts supporting Mobile, Web, and Desktop windows out-of-the-box.

4. **Self-Consistency & Persistence**:
   - Always auto-check generated code using `flutter analyze` standards before suggesting completion.
   - Maintain self-documenting code with concise doc-comments for public interfaces.