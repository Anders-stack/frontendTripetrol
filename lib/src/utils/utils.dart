import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informacion incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('ok'))
          ],
        );
      });
}

void mostrarAlertaCorrecta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const  Text('Informacion Correcta'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pushNamed(context, 'login'),
                child: const Text('ok'))
          ],
        );
      });
}
void operacionExitosa(BuildContext context, String mensaje, String ruta) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Informacion Correcta'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pushNamed(context, ruta),
                child: const Text('ok'))
          ],
        );
      });
}