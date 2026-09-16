import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';
import 'package:my_vibecode_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<Either<Never, HomeOverview>> loadOverview({
    required String userName,
  }) async {
    return const Right(
      HomeOverview(
        metrics: [
          HomeMetric(
            label: 'Focus time',
            value: '4h 28m',
            detail: '+12% this week',
            isPositive: true,
          ),
          HomeMetric(
            label: 'Completed',
            value: '18',
            detail: '+4 this week',
            isPositive: true,
          ),
          HomeMetric(
            label: 'In progress',
            value: '07',
            detail: 'Across 3 areas',
            isPositive: false,
          ),
        ],
        activities: [
          HomeActivity(
            title: 'Review weekly priorities',
            category: 'Planning',
            time: 'Today, 09:30',
            isComplete: true,
          ),
          HomeActivity(
            title: 'Prepare product outline',
            category: 'Deep work',
            time: 'Today, 13:00',
            isComplete: false,
          ),
          HomeActivity(
            title: 'Share project update',
            category: 'Communication',
            time: 'Tomorrow, 10:00',
            isComplete: false,
          ),
          HomeActivity(
            title: 'Reflect on the week',
            category: 'Wellbeing',
            time: 'Friday, 16:30',
            isComplete: false,
          ),
        ],
      ),
    );
  }
}
