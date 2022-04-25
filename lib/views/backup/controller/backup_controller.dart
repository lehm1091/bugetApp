import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:finanzas_personales/main.dart';
import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/movement.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class BackupController extends GetxController {
  RxBool isLoading = false.obs;
  final accountBox = objectbox.store.box<Account>();
  final movementBox = objectbox.store.box<Movement>();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  late List<List<dynamic>> accountData;
  late List<List<dynamic>> movementsData;
  Future<void> getCsv() async {
    List<dynamic> r = [];
    accountData = [];
    r = [];
    r.add("id");
    r.add("name");
    r.add("balance");
    r.add("planned");
    r.add("typeId");
    accountData.add(r);
    accountData.addAll(accountBox.getAll().map((e) {
      r = [];
      r.add(e.id);
      r.add(e.name);
      r.add(e.balance);
      r.add(e.planned);
      r.add(e.typeId);
      return r;
    }).toList());

    movementsData = [];
    r = [];
    r.add("id");
    r.add("description");
    r.add("total");
    r.add("date");
    r.add("fromAccountId");
    r.add("toAccountId");
    movementsData.add(r);
    movementsData.addAll(movementBox.getAll().map((e) {
      r = [];
      r.add(e.id);
      r.add(e.description);
      r.add(e.total);
      r.add(e.date);
      r.add(e.fromAccount.targetId);
      r.add(e.toAccount.targetId);
      return r;
    }).toList());
    if (await Permission.storage.request().isGranted) {
//store file in documents folder
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
// String dir = (await getExternalStorageDirectory())!.path + "/mycsv.csv";
        String dirCuentas = selectedDirectory + "/cuentas.csv";
        String dirMovimientos = selectedDirectory + "/movimientos.csv";

// convert rows to String and write as csv file
        File f1 = new File(dirCuentas);
        String csvCuentas = const ListToCsvConverter().convert(accountData);
        File f2 = new File(dirMovimientos);
        String csv1 = const ListToCsvConverter().convert(accountData);
        String csv2 = const ListToCsvConverter().convert(movementsData);
        var res1 = await f1.writeAsString(csv1);
        var res2 = await f2.writeAsString(csv2);
        if (await res1.exists())
          Get.snackbar(
            "CSV Exportado",
            dirCuentas + "\n" + dirMovimientos,
            icon: Icon(Icons.check, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
        else
          Get.snackbar(
            "Error",
            "CSV no Exportado",
            icon: Icon(Icons.close, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          );
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }
}
