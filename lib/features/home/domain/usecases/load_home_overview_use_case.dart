import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';
import 'package:my_vibecode_app/features/home/domain/repositories/home_repository.dart';

class LoadHomeOverviewUseCase {
  const LoadHomeOverviewUseCase(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, HomeOverview>> call({required String userName}) {
    return repository.loadOverview(userName: userName);
  }
}
