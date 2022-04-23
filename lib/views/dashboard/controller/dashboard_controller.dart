import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/objectbox.g.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/new_account/new_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  double totalWallets = 0;
  double totalExpended = 0;
  double totalPlanned = 0;
  double libre = 0;

  double totalExpendedGroupA = 0;
  double totalPlannedGroupA = 0;
  double totalExpendedGroupB = 0;
  double totalPlannedGroupB = 0;

  final accountBox = objectbox.store.box<Account>();

  List<Account> wallets = [];
  List<Account> expendsGroupA = [];
  List<Account> expendsGroupB = [];
  @override
  Future<void> onInit() async {
    super.onInit();
    await getData();
  }

  Future<void> getData() async {
    wallets = getWallets();
    totalPlanned = 0;
    totalExpended = 0;
    expendsGroupA = getExpendsGroupA();
    expendsGroupB = getExpendsGroupB();
  }

  List<Account> getAll() {
    return accountBox.getAll();
  }

  Future<void> resetBalances() async {
    List<Account> lista = getAll();
    lista.forEach((element) {
      if (element.typeId == AccountTypeId.expendIdGroupA.value ||
          element.typeId == AccountTypeId.expendIdGroupB.value) {
        element.balance = 0.0;
      }
      if (element.typeId == AccountTypeId.walletId.value) {
        element.balance = element.planned;
      }
    });

    accountBox.putMany(lista);
    await getData();
    update();
  }

  Future<void> deleteAll() async {
    accountBox.removeAll();
    await getData();
    update();
  }

  List<Account> getByAccountType(int type) {
    final query = (accountBox.query(Account_.typeId.equals(type))).build();
    return query.find();
  }

  List<Account> getWallets() {
    List<Account> wallets = getByAccountType(4);
    totalWallets = 0;
    wallets.forEach((element) {
      totalWallets += element.balance;
    });
    update();
    return wallets;
  }

  List<Account> getExpendsGroupA() {
    List<Account> expendsGroupA =
        getByAccountType(AccountTypeId.expendIdGroupA.value);
    totalPlannedGroupA = 0;
    totalExpendedGroupA = 0;
    expendsGroupA.forEach((element) {
      totalPlanned += element.planned;
      totalExpended += element.balance;
      totalPlannedGroupA += element.planned;
      totalExpendedGroupA += element.balance;
    });
    update();
    return expendsGroupA;
  }

  List<Account> getExpendsGroupB() {
    List<Account> expendsGroupB =
        getByAccountType(AccountTypeId.expendIdGroupB.value);
    totalPlannedGroupB = 0;
    totalExpendedGroupB = 0;
    expendsGroupB.forEach((element) {
      totalPlanned += element.planned;
      totalExpended += element.balance;
      totalPlannedGroupB += element.planned;
      totalExpendedGroupB += element.balance;
    });
    update();
    return expendsGroupB;
  }

  RxList<Account> accountsList = <Account>[
    Account(balance: 70, name: "Prueba1", planned: 100.0, typeId: 1),
    Account(balance: 200, name: "Prueba2", planned: 200.0, typeId: 1),
    Account(balance: 50, name: "Prueba3", planned: 300.0, typeId: 1),
    Account(balance: 40, name: "Prueba4", planned: 300.0, typeId: 1),
    Account(balance: 305, name: "Prueba5", planned: 300.0, typeId: 1)
  ].obs;

  onAddButtonPress(int accountType) {
    print("pressed");

    Get.to(() => NewAccount(
          accountType: accountType,
        ));
  }

  void removeAccount(Account item) {
    print("removed");
    accountBox.remove(item.id);
    getData();
    update();
  }
}
