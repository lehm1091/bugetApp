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
  TextEditingController accountPlanned = new TextEditingController();
  TextEditingController accountBalance = new TextEditingController();
  RxBool isLoading = false.obs;

  final accountBox = objectbox.store.box<Account>();
  List<DropdownMenuItem<int>> accountTypes = accountTypesList
      .map(
        (e) => DropdownMenuItem<int>(
          child: Text(e.name),
          value: e.id,
        ),
      )
      .toList();
  addNewAccount(int accountType) {
    if (isLoading.value) {
      print("guardado en progreso");
      return;
    }
    isLoading.value = true;
    Account newAccount = Account(
        balance: accountBalance.text.isNotEmpty
            ? double.parse(accountBalance.text)
            : 0,
        name: accountNameController.text,
        planned: accountPlanned.text.isNotEmpty
            ? double.parse(accountPlanned.text)
            : 0,
        typeId: accountType);
    if (accountType == 4) {
      newAccount.planned = newAccount.balance;
    }
    accountBox.put(newAccount);
    dashController.getData();
    Get.back();
    isLoading.value = false;
    Get.snackbar(
      "Ok",
      "Cuenta agregada",
      icon: const Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
    dashController.update();
  }
}
