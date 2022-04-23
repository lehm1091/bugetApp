import 'dart:ffi';

import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/views/movements/controller/movements_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Movements extends GetView<MovementController> {
  Account? toAccount;
  Movements({Key? key, this.toAccount}) : super(key: key) {
    if (toAccount != null) {
      controller.idAccount = toAccount!.id;
      controller.movements = controller.getByToAccountId(toAccount!.id);
    }

    print("constructor");
    print(toAccount!.id);
  }
  var _controller = Get.put(MovementController());
  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: toAccount != null
            ? Text("Movimientos ${toAccount!.name}")
            : Text("Movimientos"),
      ),
      body: GetBuilder<MovementController>(builder: (_mc) {
        print("buider");
        return Container(
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.movements.length == 0
                  ? const Center(child: Text("No hay movimientos"))
                  : ListView.builder(
                      itemCount: controller.movements.length,
                      itemBuilder: (BuildContext context, index) {
                        return Dismissible(
                          background: stackBehindDismiss(),
                          key: ObjectKey(controller.movements[index]),
                          child: ListTile(
                            leading: Icon(Icons.move_down),
                            trailing: Text(
                              "${controller.movements[index].total}",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                            subtitle: Text(
                                "${controller.movements[index].description}"),
                            title: Text(
                                "${controller.movements[index].fromAccount.target?.name} > ${controller.movements[index].toAccount.target?.name} "),
                          ),
                          onDismissed: (direction) async {
                            var item = controller.movements[index];

                            await controller.deleteItem(item);
                          },
                        );
                      }),
        );
      }),
    );
  }
}
