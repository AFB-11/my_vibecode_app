import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_vibecode_app/features/home/domain/entities/home_overview.dart';
import 'package:my_vibecode_app/features/home/domain/usecases/load_home_overview_use_case.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_event.dart';
import 'package:my_vibecode_app/features/home/presentation/bloc/home_state.dart';
import 'package:my_vibecode_app/features/home/presentation/widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.loadHomeOverview,
  });

  final UserEntity user;
  final LoadHomeOverviewUseCase loadHomeOverview;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(loadHomeOverview: loadHomeOverview)
            ..add(HomeStarted(user.name)),
      child: _HomeView(user: user),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.user});

  static const _canvas = Color(0xFFF5F7F3);
  static const _surface = Color(0xFFFFFEFC);
  static const _ink = Color(0xFF17302C);
  static const _muted = Color(0xFF6C7D78);
  static const _emerald = Color(0xFF0F766E);
  static const _line = Color(0xFFE3EAE4);

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||
                state.status == HomeStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: _emerald),
              );
            }
            if (state.status == HomeStatus.failure || state.overview == null) {
              return _ErrorView(
                message: state.failure?.message ?? 'Unable to load your home.',
                onRetry: () =>
                    context.read<HomeBloc>().add(HomeStarted(user.name)),
              );
            }
            return _HomeContent(user: user, overview: state.overview!);
          },
        ),
      ),
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status != HomeStatus.success) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => _showAddTask(context),
            backgroundColor: _emerald,
            foregroundColor: Colors.white,
            elevation: 3,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New task'),
          );
        },
      ),
    );
  }

  Future<void> _showAddTask(BuildContext context) async {
    final task = await AddTaskBottomSheet.show(context);
    if (task == null || !context.mounted) {
      return;
    }
    context.read<HomeBloc>().add(
      AddTask(title: task.title, category: task.category),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.user, required this.overview});

  final UserEntity user;
  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        final horizontalPadding = isCompact ? 20.0 : 40.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            isCompact ? 24 : 36,
            horizontalPadding,
            40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopBar(user: user),
                  const SizedBox(height: 36),
                  _WelcomeHeader(userName: user.name),
                  const SizedBox(height: 28),
                  _MetricsGrid(metrics: overview.metrics),
                  const SizedBox(height: 36),
                  _SectionHeader(
                    title: 'Your rhythm',
                    actionLabel: 'View all',
                    onAction: () {},
                  ),
                  const SizedBox(height: 14),
                  _ActivityList(
                    activities: overview.activities,
                    onToggle: (index) => context.read<HomeBloc>().add(
                      ToggleTaskCompletion(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LogoMark(),
        const Spacer(),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
          color: _HomeView._muted,
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFDCEDE8),
          child: Text(
            user.name.characters.first.toUpperCase(),
            style: const TextStyle(
              color: _HomeView._emerald,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _HomeView._emerald,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Aurelia',
          style: TextStyle(
            color: _HomeView._ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, ${userName.split(' ').first}.',
          style: const TextStyle(
            color: _HomeView._ink,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'A calm space to keep your priorities moving forward.',
          style: TextStyle(color: _HomeView._muted, fontSize: 16, height: 1.4),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<HomeMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 560 ? 1 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 132,
          ),
          itemBuilder: (context, index) => _MetricTile(metric: metrics[index]),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final HomeMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _HomeView._surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _HomeView._line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric.label,
            style: const TextStyle(color: _HomeView._muted, fontSize: 13),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: const TextStyle(
                  color: _HomeView._ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Icon(
                metric.isPositive
                    ? Icons.trending_up_rounded
                    : Icons.auto_graph_rounded,
                color: metric.isPositive
                    ? _HomeView._emerald
                    : _HomeView._muted,
                size: 20,
              ),
            ],
          ),
          Text(
            metric.detail,
            style: TextStyle(
              color: metric.isPositive ? _HomeView._emerald : _HomeView._muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _HomeView._ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(foregroundColor: _HomeView._emerald),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.activities, required this.onToggle});

  final List<HomeActivity> activities;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _HomeView._surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _HomeView._line),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          indent: 68,
          endIndent: 20,
          color: _HomeView._line,
        ),
        itemBuilder: (context, index) => _ActivityTile(
          activity: activities[index],
          onTap: () => onToggle(index),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity, required this.onTap});

  final HomeActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: activity.isComplete
              ? const Color(0xFFDCEDE8)
              : const Color(0xFFF0F3EE),
          shape: BoxShape.circle,
        ),
        child: Icon(
          activity.isComplete
              ? Icons.check_rounded
              : Icons.radio_button_unchecked_rounded,
          color: activity.isComplete ? _HomeView._emerald : _HomeView._muted,
          size: 20,
        ),
      ),
      title: Text(
        activity.title,
        style: TextStyle(
          color: _HomeView._ink,
          fontWeight: FontWeight.w600,
          decoration: activity.isComplete ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          '${activity.category}  •  ${activity.time}',
          style: const TextStyle(color: _HomeView._muted, fontSize: 12),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: _HomeView._muted,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: _HomeView._muted,
              size: 42,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _HomeView._ink, fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
