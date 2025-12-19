import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'services/plant_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {  
    if (e.code != 'duplicate-app') rethrow;
  }
  runApp(const GreenhouseApp());
}

class GreenhouseApp extends StatelessWidget {
  const GreenhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<PlantService>(create: (_) => PlantService()),
      ],
      child: MaterialApp( 
        title: 'Panc Smart',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
        // ADICIONE ESTE BUILDER PARA RESPONSIVIDADE
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(0.8, 1.5),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}