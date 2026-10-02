import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/monitoring/screens/monitoring_screen.dart';
import '../../features/device_control/screens/device_control_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/sensor/screens/sensor_screen.dart';
import '../../features/setpoint/screens/setpoint_screen.dart';
import '../../features/settings/screens/appearance_screen.dart';
import '../../features/settings/screens/date_time_screen.dart';
import '../../features/settings/screens/language_screen.dart';
import '../../features/settings/screens/sensor_calibration_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/system_information_screen.dart';
import '../../shared/widgets/main_shell.dart';
import '../../shared/widgets/not_found_screen.dart';

/// Konfigurasi routing aplikasi menggunakan GoRouter dengan ShellRoute
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.deviceControl,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DeviceControlScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.setpoint,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SetpointScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.monitoring,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MonitoringScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settingsCalibration,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SensorCalibrationScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settingsDateTime,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DateTimeSettingsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settingsAppearance,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AppearanceSettingsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settingsLanguage,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LanguageSettingsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settingsSystemInfo,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SystemInformationScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.sensor,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SensorScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return NotFoundScreen(path: state.uri.toString());
    },
  );
}
