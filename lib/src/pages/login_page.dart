import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripetrol_manage_app/src/providers/loading_provider.dart';
import 'package:tripetrol_manage_app/src/providers/login_form_provider.dart';
import 'package:tripetrol_manage_app/src/services/auth_service.dart';
import 'package:tripetrol_manage_app/src/ui/input_decorations.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (_) => LoadingProvider(),
      child: Stack(
        children: [
          _crearFondo(context),
          ChangeNotifierProvider(
            create: (_) => LoginFormProvider(),
            child: _LoginForm(),
          ),
        ],
      ),
    ));
  }
}

Widget _crearFondo(BuildContext context) {
  return const IconHeader(
    icon: FontAwesomeIcons.users,
    subtitulo: 'Bienvenido',
    titulo: 'Tripetrol',
    color1: Color(0xff526bf6),
    color2: Color(0xff67acf2),
  );
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final loading = Provider.of<LoadingProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 240.0,
          )),
          Container(
            child: Form(
              key: loginForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const Text('Ingrese sus datos:',
                      style: TextStyle(fontSize: 20.0)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'john.doe@gmail.com',
                        labelText: 'Correo electrónico',
                        prefixIcon: Icons.alternate_email_rounded),
                    onChanged: (value) => loginForm.email = value,
                    validator: (value) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);

                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El valor ingresado no luce como un correo';
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '*****',
                        labelText: 'Contraseña',
                        prefixIcon: Icons.lock_outline),
                    onChanged: (value) => loginForm.password = value,
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : 'La contraseña debe de ser de 6 caracteres';
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: Colors.deepPurple,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: Text(
                            loading.isLoading ? 'Espere' : 'Ingresar',
                            style: const TextStyle(color: Colors.white),
                          )),
                      onPressed: () async {
                        loading.isLoading = true;
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (loginForm.isValidForm()) {
                          final Map<String, dynamic>? mesage =
                              await authService.loginUsuario(
                                  loginForm.email, loginForm.password);
                          loading.isLoading = false;
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          loading.isLoading = false;
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, 'register'),
                      child: const Text('Crear una nueva cuenta'))
                ],
              ),
            ),
          ),
          const Text('¿Olvido su Contraseña?'),
          const SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }
}
