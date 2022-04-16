import 'dart:ffi';

import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/views/edit_account/controller/edit_account_controller.dart';
import 'package:finanzas_personales/views/new_account/controller/new_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAccount extends GetView<EditAccountController> {
  Account account;
  var _controller = Get.put(EditAccountController());
  EditAccount({required this.account, Key? key}) : super(key: key) {
    _controller.accountBalance.text = account.balance.toString();
    _controller.accountNameController.text = account.name.toString();
    _controller.accountPlanned.text = account.planned.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.editAccount(
                    accountType: account.typeId, id: account.id);
              },
              icon: Icon(Icons.save))
        ],
        title: Text("Editar Cuenta"),
      ),
      body: GetBuilder<EditAccountController>(builder: (_mc) {
        return Container(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.accountNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.all(10),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: DropdownButton<int>(
            //             value: controller.accountType,
            //             icon: const Icon(Icons.arrow_drop_down),
            //             iconSize: 24,
            //             elevation: 16,
            //             underline: Container(
            //               height: 2,
            //               // color: Colors.deepPurpleAccent,
            //             ),
            //             onChanged: (dynamic data) {
            //               controller.accountType = data;
            //               controller.update();
            //             },
            //             items: controller.accountTypes),
            //       ),
            //     ],
            //   ),
            // ),
            if (account.typeId != 4)
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.accountPlanned,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Planeado',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.accountBalance,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Balance',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
