import 'package:go_router/go_router.dart';
import 'package:pos_offline_desktop/ui/home/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const HomeScreen())],
);
