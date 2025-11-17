import 'package:flutter/material.dart';
import 'package:mirah_coaches/pages/home_page.dart';


const Color brandBlue = Color(0xFF003366); // Deep Navy Blue
const Color brandRed = Color(0xFFCC0000);  // Vibrant Bus Stripe Red
const Color brandWhite = Color(0xFFFFFFFF);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: brandBlue,
          onPrimary: brandWhite,
          secondary: brandRed,
          onSecondary: brandWhite,
          error: Colors.red,
          onError: brandWhite,
          surface: brandBlue,
          onSurface: brandWhite,
          tertiary: Colors.grey.shade500,

        ),
      ),
      home: HomePage(),
    );
  }
}
