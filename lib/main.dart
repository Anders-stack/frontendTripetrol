import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripetrol_manage_app/src/pages/home_page.dart';
import 'package:tripetrol_manage_app/src/pages/login_page.dart';
import 'package:tripetrol_manage_app/src/pages/register_page.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/cheque_creation_page.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/entrada_salida/entrada_page.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/entrada_salida/salida_page.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/entrada_salida_page.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/traslado/traslado_in.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/traslado/traslado_out.dart';
import 'package:tripetrol_manage_app/src/pages/screens_pages/validar_cheque_page.dart';
import 'package:tripetrol_manage_app/src/services/auth_service.dart';
import 'package:tripetrol_manage_app/src/services/cheque_create.dart';
import 'package:tripetrol_manage_app/src/services/flujo_service.dart';
import 'package:tripetrol_manage_app/src/services/traslado_service.dart';
import 'package:tripetrol_manage_app/src/theme/theme.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ChequeCreateService()),        
        ChangeNotifierProvider(create: (_) => FlujoService()),        
        ChangeNotifierProvider(create: (_) => TrasladoCreateService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: 'login',
      routes: {
        'home': (_) => const HomePage(),
        'login': (_) => const LoginPage(),
        'register': (_) => const RegisterPage(),
        'creacionCheque': (_) => ChequeCreatePage(),        
        'validarCheque': (_) => ChequeValdidScreen(),
        'entradaSalida': (_) => EntradaSalida(),
        'entradas': (_) => EntradaScreen(),
        'salidas': (_) => SalidaScreen(),
        'trasladoSalida': (_) => TrasladoOutScreen(),
        'trasladoEntrada': (_) => TrasladoInScreen(),

      },
      theme: myDarkTheme,
    );
  }
}
