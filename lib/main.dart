import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/session_bloc.dart';
import 'features/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const CyberSafe2DApp());
}

class CyberSafe2DApp extends StatelessWidget {
  const CyberSafe2DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Fresh SessionBloc on every app launch = 100% volatile state
      create: (_) => SessionBloc(),
      child: MaterialApp(
        title: 'CyberSafe 2D',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF050A14),
          fontFamily: 'monospace',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00D4FF),
            secondary: Color(0xFF6C63FF),
            surface: Color(0xFF0D1B2A),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
