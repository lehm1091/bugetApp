import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAccountController extends GetxController {
  var dashController = Get.put(DashboardController());
  TextEditingController accountNameController = new TextEditingController();
  TextEditingController accountPlanned = new TextEditingController(text: '0.0');
  TextEditingController accountBalance = new TextEditingController(text: '0.0');
  int accountType = 1;

  final accountBox = objectbox.store.box<Account>();
  List<DropdownMenuItem<int>> accountTypes = accountTypesList
      .map(
        (e) => DropdownMenuItem<int>(
          child: Text(e.name),
          value: e.id,
        ),
      )
      .toList();
  addNewAccount() {
    Account newAccount = Account(
        balance: double.parse(accountBalance.text),
        name: accountNameController.text,
        planned: double.parse(accountPlanned.text),
        typeId: accountType);

    dashController.accountsList.add(newAccount);
    accountBox.put(newAccount);
    Get.back();
    Get.snackbar(
      "Ok",
      "Cuenta agregada",
      icon: Icon(Icons.add, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
    dashController.update();
  }
}
