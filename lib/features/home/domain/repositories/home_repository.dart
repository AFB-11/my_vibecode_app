import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeOverview>> loadOverview({
    required String userName,
  });
}
