import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/objectbox.g.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final accountBox = objectbox.store.box<Account>();
  List<Account> getAll() {
    return accountBox.getAll();
  }

  List<Account> getByAccountType(int type) {
    final query = (accountBox.query(Account_.typeId.equals(type))).build();
    return query.find();
  }

  RxList<Account> accountsList = <Account>[
    Account(balance: 70, name: "Prueba1", planned: 100.0, typeId: 1),
    Account(balance: 200, name: "Prueba2", planned: 200.0, typeId: 1),
    Account(balance: 50, name: "Prueba3", planned: 300.0, typeId: 1),
    Account(balance: 40, name: "Prueba4", planned: 300.0, typeId: 1),
    Account(balance: 305, name: "Prueba5", planned: 300.0, typeId: 1)
  ].obs;
  onAddButtonPress() {
    print("pressed");
    Get.to(() => NewAccount());
  }

  void removeAccount(Account item) {
    print("removed");
    accountBox.remove(item.id);
    update();
  }
}
