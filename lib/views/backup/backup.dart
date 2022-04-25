import 'dart:ffi';

import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/views/backup/controller/backup_controller.dart';
import 'package:finanzas_personales/views/balance_movement/controller/balance_movement_controller.dart';
import 'package:finanzas_personales/views/new_account/controller/new_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Backup extends GetView<BackupController> {
  Backup({Key? key}) : super(key: key);
  var _controller = Get.put(BackupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text("Backups"),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
      body: GetBuilder<BackupController>(builder: (_mc) {
        return Container(
          child: Center(
            child: TextButton(
              child: Text(
                "Export to CSV",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                await controller.getCsv();
              },
            ),
          ),
        );
      }),
    );
  }
}
