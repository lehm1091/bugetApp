import 'dart:ffi';

import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/views/balance_movement/controller/balance_movement_controller.dart';
import 'package:finanzas_personales/views/new_account/controller/new_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceMovement extends GetView<BalanceMovementController> {
  Account fromAccount;
  Account toAccount;

  BalanceMovement(
      {required this.fromAccount, required this.toAccount, Key? key})
      : super(key: key);
  var _controller = Get.put(BalanceMovementController());

  Widget porcentageButton(
      {required title, required Function onPress, required Color color}) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: SizedBox(
        height: 50,
        child: Column(
          children: [
            Center(
              child: Container(
                height: 25,
                color: color,
              ),
            ),
            Center(
              child: Text(title),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.saveNewMovementAccount(fromAccount, toAccount,
                    double.parse(controller.movedBalance.text));
              },
              icon: Icon(Icons.save))
        ],
        title: Text("Nuevo Movimiento"),
      ),
      body: GetBuilder<BalanceMovementController>(builder: (_mc) {
        return Container(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("${fromAccount.name} >>> ${toAccount.name}"),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Disponible "),
                  Text("\$${fromAccount.balance}"),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.description,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.movedBalance,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cantidad',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: porcentageButton(
                              color: controller.porcentageValue >= 25
                                  ? Colors.blue
                                  : Colors.grey,
                              onPress: () {
                                controller.movedBalance.text =
                                    (toAccount.planned * 0.25)
                                        .toStringAsFixed(2);
                                controller.porcentageValue = 25;
                                controller.update();
                              },
                              title: "25%"))),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: porcentageButton(
                              color: controller.porcentageValue >= 50
                                  ? Colors.blue
                                  : Colors.grey,
                              onPress: () {
                                controller.movedBalance.text =
                                    (toAccount.planned * 0.50)
                                        .toStringAsFixed(2);
                                controller.porcentageValue = 50;
                                controller.update();
                              },
                              title: "50%"))),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: porcentageButton(
                              color: controller.porcentageValue >= 75
                                  ? Colors.blue
                                  : Colors.grey,
                              onPress: () {
                                controller.movedBalance.text =
                                    (toAccount.planned * 0.75)
                                        .toStringAsFixed(2);
                                controller.porcentageValue = 75;
                                controller.update();
                              },
                              title: "75%"))),
                  Expanded(
                      child: Container(
                          child: porcentageButton(
                              color: controller.porcentageValue >= 100
                                  ? Colors.blue
                                  : Colors.grey,
                              onPress: () {
                                controller.movedBalance.text =
                                    (toAccount.planned).toStringAsFixed(2);
                                controller.porcentageValue = 100;
                                controller.update();
                              },
                              title: "100%"))),
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
