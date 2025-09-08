import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/app_state.dart';
import 'package:stormtune/providers/weather_provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/screens/home_screen.dart';
import 'package:stormtune/utils/theme.dart';

void main() {
  runApp(const StormTuneApp());
}

class StormTuneApp extends StatelessWidget {
  const StormTuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => CarProfileProvider()),
      ],
      child: MaterialApp(
        title: 'StormTune',
        debugShowCheckedModeBanner: false,
        theme: StormTuneTheme.lightTheme,
        darkTheme: StormTuneTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
} 