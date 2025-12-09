import 'package:go_router/go_router.dart';
import 'package:mirah_coaches/pages/balancing_page.dart';
import 'package:mirah_coaches/pages/home_page.dart';
GoRouter appRoutes(){
return  GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(), 
    ),
    GoRoute(
      path: '/balancing',
      builder: (context, state) => const BalancingPage(), 
    ),
  ],
);}