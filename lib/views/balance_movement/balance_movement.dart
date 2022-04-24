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
        actions: [],
        title: Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text("${fromAccount.name}"),
              Icon(Icons.arrow_right),
              Text("${toAccount.name}")
            ],
          ),
        ),
      ),
      body: GetBuilder<BalanceMovementController>(builder: (_mc) {
        return Container(
          child: Form(
            key: controller.formKey,
            child: Column(children: [
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, bottom: 12),
                child: Row(
                  children: [
                    Text("Pendiente ${toAccount.name} "),
                    Text("\$${toAccount.planned - toAccount.balance} ")
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.movedBalance,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese la cantidad';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (toAccount.planned > toAccount.balance)
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          ((toAccount.planned -
                                                      toAccount.balance) *
                                                  0.25)
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
                                          ((toAccount.planned -
                                                      toAccount.balance) *
                                                  0.50)
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
                                          ((toAccount.planned -
                                                      toAccount.balance) *
                                                  0.75)
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
                                          ((toAccount.planned -
                                                  toAccount.balance))
                                              .toStringAsFixed(2);
                                      controller.porcentageValue = 100;
                                      controller.update();
                                    },
                                    title: "100%"))),
                      ],
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Disponible ${fromAccount.name}"),
                    Text("\$${fromAccount.balance}"),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  label: Text("Guardar"),
                  icon: controller.isLoading.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Center(child: Icon(Icons.save)),
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      var amount;
                      try {
                        amount = double.parse(controller.movedBalance.text);
                        controller.saveNewMovementAccount(
                            fromAccount, toAccount, amount);
                      } catch (e) {
                        controller.isCantidadIncorrecta = true;
                        controller.update();
                      }
                    }
                  },
                ),
              )
            ]),
          ),
        );
      }),
    );
  }
}
