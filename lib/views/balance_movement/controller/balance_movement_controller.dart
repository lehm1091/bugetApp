import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceMovementController extends GetxController {
  TextEditingController movedBalance = new TextEditingController();

  final accountBox = objectbox.store.box<Account>();
  var dashController = Get.put(DashboardController());
  saveNewMovementAccount(Account from, Account to, double movementAmount) {
    from.balance = from.balance - movementAmount;

    to.balance = to.balance + movementAmount;
    accountBox.put(from);
    accountBox.put(to);
    dashController.getData();
    dashController.update();
    Get.back();
    Get.snackbar(
      "Ok",
      "Movimiento Guardado",
      icon: Icon(Icons.add, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }
}
