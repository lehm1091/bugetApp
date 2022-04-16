import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/widget/account_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({Key? key}) : super(key: key);
  var _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Finanzas"),
        ),
        body: GetBuilder<DashboardController>(
          builder: (_mc) => Center(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: controller
                        .getByAccountType(4)
                        .map((element) => AccountDisplay(
                              account: element,
                              onDelete: () {
                                controller.removeAccount(element);
                              },
                              onEdit: (val) {},
                            ))
                        .toList(),
                  ),
                  Container(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: controller
                        .getByAccountType(1)
                        .map((element) => AccountDisplay(
                              account: element,
                              onDelete: () {
                                controller.removeAccount(element);
                              },
                              onEdit: (val) {},
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            controller.onAddButtonPress();
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
        ));
  }
}
