import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';
import 'package:my_vibecode_app/features/home/domain/usecases/load_home_overview_use_case.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_event.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.loadHomeOverview}) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<AddTask>(_onAddTask);
  }

  final LoadHomeOverviewUseCase loadHomeOverview;

  void _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<HomeState> emit,
  ) {
    final overview = state.overview;
    if (overview == null ||
        event.index < 0 ||
        event.index >= overview.activities.length) {
      return;
    }

    final activities = List<HomeActivity>.of(overview.activities);
    final activity = activities[event.index];
    activities[event.index] = activity.copyWith(
      isComplete: !activity.isComplete,
    );
    emit(
      state.copyWith(
        status: HomeStatus.success,
        overview: overview.copyWith(activities: activities),
      ),
    );
  }

  void _onAddTask(AddTask event, Emitter<HomeState> emit) {
    final overview = state.overview;
    if (overview == null) {
      return;
    }

    final activities = [
      HomeActivity(
        title: event.title,
        category: event.category,
        time: 'Just now',
        isComplete: false,
      ),
      ...overview.activities,
    ];
    emit(
      state.copyWith(
        status: HomeStatus.success,
        overview: overview.copyWith(activities: activities),
      ),
    );
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        clearOverview: true,
        clearFailure: true,
      ),
    );
    final result = await loadHomeOverview(userName: event.userName);
    result.match(
      (failure) =>
          emit(state.copyWith(status: HomeStatus.failure, failure: failure)),
      (overview) => emit(
        state.copyWith(
          status: HomeStatus.success,
          overview: overview,
          clearFailure: true,
        ),
      ),
    );
  }
}
