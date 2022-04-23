import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/model/movement.dart';
import 'package:finanzas_personales/objectbox.g.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovementController extends GetxController {
  int idAccount = 0;
  var dashController = Get.put(DashboardController());
  final accountBox = objectbox.store.box<Account>();
  final movementBox = objectbox.store.box<Movement>();
  RxBool isLoading = false.obs;
  List<Movement> getAll() {
    return movementBox.getAll();
  }

  List<Movement> getByToAccountId(int id) {
    return getAll()
        .where((element) => element.toAccount.targetId == id)
        .toList();
  }

  List<Movement> movements = [];
  @override
  void onInit() {
    print("on init movements");
    print("idAccount");
    print(idAccount);
    movements = getAll();
    print(movements.length);
    super.onInit();
  }

  Future<void> deleteItem(Movement movement) async {
    isLoading.value = true;
    update();
    var amount = movement.total;
    Account? from = movement.fromAccount.target;
    Account? to = movement.toAccount.target;
    if (from != null && to != null && amount > 0) {
      from.balance += amount;
      to.balance -= amount;
    }

    movementBox.remove(movement.id);
    accountBox.put(from!);
    accountBox.put(to!);
    isLoading.value = false;
    movements = getAll();
    update();
    dashController.getData();
  }
}
