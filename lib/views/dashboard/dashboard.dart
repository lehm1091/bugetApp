import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
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

  TextStyle titleTextStyle = const TextStyle(fontSize: 12);

  Widget roundedAddButton({required Function onTap}) {
    return Container(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: 40,
          width: 40,
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
        actions: [
          GetBuilder<DashboardController>(builder: (context) {
            return controller.isEditingModeActive.value == true
                ? IconButton(
                    onPressed: () {
                      controller.setShowMenuTo(false);
                    },
                    icon: Icon(Icons.check))
                : Container();
          })
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: GetBuilder<DashboardController>(
          builder: (_mc) {
            return controller.isEditingModeActive.value == true
                ? Text(
                    "Editar",
                    style: titleTextStyle,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Saldos",
                            style: titleTextStyle,
                          ),
                          Text(
                            "\$${controller.totalWallets.toStringAsFixed(1)}",
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
                            "\$${controller.totalExpended.toStringAsFixed(1)}",
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
                            "\$${controller.totalPlanned.toStringAsFixed(1)}",
                            style: titleTextStyle,
                          )
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),

      body: GetBuilder<DashboardController>(
        builder: (_mc) => Listener(
          onPointerMove: (PointerMoveEvent event) {
            // print("x: ${event.position.dx}, y: ${event.position.dy}");
          },
          child: Center(
            child: Scrollbar(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  key: controller.listViewKey,
                  controller: controller.scroller,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
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
                                          controller.setShowMenuTo(false);
                                        },
                                        onDragAccept: () {
                                          controller.distanceMoved = 0;
                                        },
                                        onDragUpdate:
                                            (DragUpdateDetails details) {
                                          print(details.localPosition.dy);
                                          print(MediaQuery.of(context)
                                              .size
                                              .height);
                                          print("pixel " +
                                              controller
                                                  .scroller.position.pixels
                                                  .toString());

                                          // if (details.localPosition.dy > 500) {
                                          //   controller.scroller.jumpTo(
                                          //       details.localPosition.dy);
                                          // }
                                        },
                                        onLongPress: (bool isMenuVisible) {
                                          controller.isEditingModeActive.value =
                                              true;
                                          controller.update();
                                        },
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: roundedAddButton(onTap: () {
                            controller
                                .onAddButtonPress(AccountTypeId.walletId.value);
                          }),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Gastos: ",
                                style: titleTextStyle,
                              ),
                              Text(
                                "Grupo A",
                                style: titleTextStyle,
                              ),
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
                                "\$${controller.totalExpendedGroupA.toStringAsFixed(1)}",
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
                                "\$${controller.totalPlannedGroupA.toStringAsFixed(1)}",
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
                              roundedAddButton(onTap: () {
                                controller.onAddButtonPress(
                                    AccountTypeId.expendIdGroupA.value);
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        ...controller.expendsGroupA
                            .map((element) => AccountDisplay(
                                  account: element,
                                  onDelete: () {
                                    controller.removeAccount(element);
                                  },
                                  onEdit: () {
                                    Get.to(() => EditAccount(
                                          account: element,
                                        ));
                                    controller.setShowMenuTo(false);
                                  },
                                  onDragUpdate: (DragUpdateDetails details) {},
                                  onDragAccept: (Account from, Account to) {
                                    print("from");
                                    print(from.name);
                                    print("to");
                                    print(to.name);

                                    Get.to(() => BalanceMovement(
                                          fromAccount: from,
                                          toAccount: to,
                                        ));
                                    controller.setShowMenuTo(false);
                                  },
                                  onLongPress: (bool isMenuVisible) {
                                    controller.isEditingModeActive.value = true;
                                    controller.update();
                                  },
                                ))
                            .toList(),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Gastos: ",
                                style: titleTextStyle,
                              ),
                              Text(
                                "Grupo B",
                                style: titleTextStyle,
                              ),
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
                                "\$${controller.totalExpendedGroupB.toStringAsFixed(1)}",
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
                                "\$${controller.totalPlannedGroupB.toStringAsFixed(1)}",
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
                              roundedAddButton(onTap: () {
                                controller.onAddButtonPress(
                                    AccountTypeId.expendIdGroupB.value);
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        ...controller.expendsGroupB
                            .map((element) => AccountDisplay(
                                  account: element,
                                  onDelete: () {
                                    controller.removeAccount(element);
                                  },
                                  onEdit: () {
                                    Get.to(() => EditAccount(
                                          account: element,
                                        ));
                                    controller.setShowMenuTo(false);
                                  },
                                  onDragUpdate: (DragUpdateDetails details) {},
                                  onDragAccept: (Account from, Account to) {
                                    print("from");
                                    print(from.name);
                                    print("to");
                                    print(to.name);

                                    Get.to(() => BalanceMovement(
                                          fromAccount: from,
                                          toAccount: to,
                                        ));
                                    controller.setShowMenuTo(false);
                                  },
                                  onLongPress: (bool isMenuVisible) {
                                    controller.isEditingModeActive.value = true;
                                    controller.update();
                                  },
                                ))
                            .toList(),
                      ],
                    )
                  ],
                ),
              ),
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
