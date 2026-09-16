import 'package:equatable/equatable.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.overview,
    this.failure,
  });

  final HomeStatus status;
  final HomeOverview? overview;
  final Failure? failure;

  HomeState copyWith({
    HomeStatus? status,
    HomeOverview? overview,
    Failure? failure,
    bool clearOverview = false,
    bool clearFailure = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      overview: clearOverview ? null : overview ?? this.overview,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, overview, failure];
}
