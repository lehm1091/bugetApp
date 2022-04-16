import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/views/balance_movement/balance_movement.dart';
import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/edit_account/edit_account.dart';
import 'package:finanzas_personales/views/navbar/nav_bar.dart';
import 'package:finanzas_personales/views/widget/account_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({Key? key}) : super(key: key);
  var _controller = Get.put(DashboardController());

  TextStyle titleTextStyle = const TextStyle(fontSize: 14);

  Widget roundedAddButton({required Function onTap}) {
    return Container(
      width: 120,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: grayColor)),
          child: Center(
            child: Icon(
              Icons.add,
              color: grayColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: GetBuilder<DashboardController>(builder: (_mc) {
          return Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Saldos",
                    style: titleTextStyle,
                  ),
                  Text(
                    "\$${controller.totalWallets}",
                    style: titleTextStyle,
                  )
                ],
              ),
              VerticalDivider(
                width: 10,
                thickness: 1,
              ),
              Column(
                children: [
                  Text(
                    "Gastos",
                    style: titleTextStyle,
                  ),
                  Text(
                    "\$${controller.totalExpended}",
                    style: titleTextStyle,
                  )
                ],
              ),
              VerticalDivider(
                width: 10,
                thickness: 1,
              ),
              Column(
                children: [
                  Text(
                    "Planeados",
                    style: titleTextStyle,
                  ),
                  Text(
                    "\$${controller.totalPlanned}",
                    style: titleTextStyle,
                  )
                ],
              ),
            ],
          ));
        }),
      ),
      body: GetBuilder<DashboardController>(
        builder: (_mc) => Center(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...controller.wallets
                        .map((element) => AccountDisplay(
                              account: element,
                              onDelete: () {
                                controller.removeAccount(element);
                              },
                              onEdit: () {
                                Get.to(() => EditAccount(
                                      account: element,
                                    ));
                              },
                              onDragAccept: () {},
                            ))
                        .toList(),
                    roundedAddButton(onTap: () {
                      controller.onAddButtonPress(4);
                    }),
                  ],
                ),
                Divider(
                  height: 10,
                  thickness: 2,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...controller.expends
                        .map((element) => AccountDisplay(
                              account: element,
                              onDelete: () {
                                controller.removeAccount(element);
                              },
                              onEdit: () {
                                Get.to(() => EditAccount(
                                      account: element,
                                    ));
                              },
                              onDragAccept: (Account from, Account to) {
                                print("from");
                                print(from.name);
                                print("to");
                                print(to.name);

                                Get.to(() => BalanceMovement(
                                      fromAccount: from,
                                      toAccount: to,
                                    ));
                              },
                            ))
                        .toList(),
                    roundedAddButton(onTap: () {
                      controller.onAddButtonPress(1);
                    })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     controller.onAddButtonPress();
      //   },
      //   backgroundColor: Colors.red,
      //   foregroundColor: Colors.black,
      // )
    );
  }
}
