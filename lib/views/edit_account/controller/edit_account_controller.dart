import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAccountController extends GetxController {
  var dashController = Get.put(DashboardController());
  TextEditingController accountNameController = new TextEditingController();
  TextEditingController accountPlanned = new TextEditingController(text: '0.0');
  TextEditingController accountBalance = new TextEditingController(text: '0.0');

  final accountBox = objectbox.store.box<Account>();

  editAccount({required int accountType, required int id}) {
    Account account = Account(
        id: id,
        balance: double.parse(accountBalance.text),
        name: accountNameController.text,
        planned: double.parse(accountPlanned.text),
        typeId: accountType);

    accountBox.put(account);
    dashController.getData();
    Get.back();
    Get.snackbar(
      "Ok",
      "Cuenta Editada",
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
    dashController.update();
  }
}
