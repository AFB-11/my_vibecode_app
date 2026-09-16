import 'package:equatable/equatable.dart';

class HomeOverview extends Equatable {
  const HomeOverview({required this.metrics, required this.activities});

  final List<HomeMetric> metrics;
  final List<HomeActivity> activities;

  HomeOverview copyWith({
    List<HomeMetric>? metrics,
    List<HomeActivity>? activities,
  }) {
    return HomeOverview(
      metrics: metrics ?? this.metrics,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [metrics, activities];
}

class HomeMetric extends Equatable {
  const HomeMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.isPositive,
  });

  final String label;
  final String value;
  final String detail;
  final bool isPositive;

  @override
  List<Object?> get props => [label, value, detail, isPositive];
}

class HomeActivity extends Equatable {
  const HomeActivity({
    required this.title,
    required this.category,
    required this.time,
    required this.isComplete,
  });

  final String title;
  final String category;
  final String time;
  final bool isComplete;

  HomeActivity copyWith({
    String? title,
    String? category,
    String? time,
    bool? isComplete,
  }) {
    return HomeActivity(
      title: title ?? this.title,
      category: category ?? this.category,
      time: time ?? this.time,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [title, category, time, isComplete];
}
