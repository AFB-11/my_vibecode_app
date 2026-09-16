import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_vibecode_app/features/home/domain/usecases/load_home_overview_use_case.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_event.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.loadHomeOverview}) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final LoadHomeOverviewUseCase loadHomeOverview;

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
