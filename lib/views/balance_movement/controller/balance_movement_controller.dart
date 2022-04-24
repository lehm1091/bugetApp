import 'dart:async';

import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/model/movement.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceMovementController extends GetxController {
  final formKey = GlobalKey<FormState>();
  bool isCantidadIncorrecta = false;
  TextEditingController movedBalance = new TextEditingController();
  TextEditingController description = new TextEditingController();
  final accountBox = objectbox.store.box<Account>();
  final movementBox = objectbox.store.box<Movement>();
  var dashController = Get.put(DashboardController());
  int porcentageValue = 0;
  RxBool isLoading = false.obs;
  Future<void> saveNewMovementAccount(
      Account from, Account to, double movementAmount) async {
    isLoading.value = true;
    update();
    from.balance = from.balance - movementAmount;

    to.balance = to.balance + movementAmount;
    accountBox.put(from);
    accountBox.put(to);
    dashController.getData();
    dashController.update();

    var movement = new Movement(date: new DateTime.now());
    movement.total = movementAmount;
    movement.fromAccount.target = from;
    movement.toAccount.target = to;
    movement.description = description.text;
    movementBox.put(movement);
    Get.back();

    isLoading.value = false;
    update();
  }
}
