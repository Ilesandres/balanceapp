import 'package:balance_app/auth/auth_gate.dart';
import 'package:balance_app/firebase_options.dart';
import 'package:balance_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inicializar formato de fechas para español
  await initializeDateFormatting('es', null);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const BalanceApp(),
    ),
  );
}

class BalanceApp extends StatelessWidget {
  const BalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Gastos',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
