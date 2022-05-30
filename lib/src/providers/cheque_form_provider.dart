import 'package:flutter/material.dart';

class ChequeFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
