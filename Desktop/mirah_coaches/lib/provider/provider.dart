import 'package:mirah_coaches/pages/my_app.dart';
import 'package:mirah_coaches/view_models/balancing_view_model.dart';
import 'package:mirah_coaches/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

MultiProvider multiProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (_) => BalancingViewModel()),
    ],
    child: MyApp(),
  );
}
