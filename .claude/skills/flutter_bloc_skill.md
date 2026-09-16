# Skill: Modern BLoC Feature Generation

When asked to generate or refactor a feature:
1. Define a single immutable state: `class FeatureState { final FeatureStatus status; final String? error; ... }`
2. Implement `copyWith` method on state.
3. Emit updated instances via `emit(state.copyWith(...))`.
4. Create explicit Events.
5. Provide pure Domain UseCase calls in BLoC handlers.