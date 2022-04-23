import 'package:finanzas_personales/model/account.dart';
import 'package:finanzas_personales/model/movement.dart';
import 'package:finanzas_personales/repository/AccountTypeRepository.dart';
import 'package:finanzas_personales/views/movements/movements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color orangeColor = Color.fromARGB(255, 255, 142, 0);
const Color greenColor = Color.fromARGB(255, 6, 211, 152);
const Color grayColor = Color.fromARGB(255, 193, 196, 201);
const Color redColor = Color.fromARGB(255, 229, 57, 53);
const Color yellowColor = Color.fromARGB(255, 255, 204, 0);

class AccountDisplay extends StatefulWidget {
  Account account;
  Function onEdit;
  Function onDelete;
  Function onDragAccept;
  AccountDisplay(
      {required this.account,
      required this.onEdit,
      required this.onDelete,
      required this.onDragAccept,
      Key? key})
      : super(key: key);

  @override
  State<AccountDisplay> createState() => _AccountDisplayState();
}

class _AccountDisplayState extends State<AccountDisplay> {
  List<double> getStops() {
    double restante = 0;
    double cumplido = widget.account.balance / widget.account.planned;
    List<double> stops = [
      0.0,
      cumplido - 0.01,
      cumplido,
    ];
    return stops;
  }

  List<Color> getColors() {
    List<Color> colors = [orangeColor, orangeColor, grayColor];
    if (widget.account.balance == widget.account.planned) {
      colors = [greenColor, greenColor, greenColor];
    }
    if (widget.account.balance > widget.account.planned) {
      colors = [redColor, redColor, redColor];
    }
    return colors;
  }

  Color getTextColor() {
    if (widget.account.typeId == AccountTypeId.walletId.value) {
      return Colors.black;
    }
    if (widget.account.balance > widget.account.planned) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Widget roundedItem(bool isFeedback) {
    return Container(
      width: 95,
      child: Center(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: widget.account.showMenu && !isFeedback
                    ? GestureDetector(
                        onTap: () => widget.onDelete(),
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      )
                    : SizedBox(
                        width: 20,
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isFeedback)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.account.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.account.typeId ==
                                AccountTypeId.walletId.value
                            ? yellowColor
                            : null,
                        gradient: widget.account.typeId ==
                                    AccountTypeId.expendIdGroupA.value ||
                                widget.account.typeId ==
                                    AccountTypeId.expendIdGroupB.value
                            ? LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: getStops(),
                                colors: getColors(),
                              )
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          widget.account.typeId == AccountTypeId.walletId.value
                              ? Icons.wallet
                              : Icons.monetization_on_outlined,
                          color: getTextColor(),
                        ),
                      ),
                    ),
                    if (!isFeedback)
                      Container(
                        child: Text(
                          widget.account.balance.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    if (!isFeedback)
                      Visibility(
                        visible: widget.account.typeId !=
                            AccountTypeId.walletId.value,
                        child: Container(
                          child: Text(
                            widget.account.planned.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                child: widget.account.showMenu
                    ? GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onTap: () {
                          widget.onEdit();
                        },
                      )
                    : SizedBox(width: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gestureWrapped() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.account.showMenu = false;
        });
      },
      onLongPress: () {
        print("long press");
        setState(() {
          widget.account.showMenu = !widget.account.showMenu;
        });
      },
      child: roundedItem(false),
      onDoubleTap: () {
        Get.to(() => Movements(toAccount: widget.account));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.account.typeId == AccountTypeId.walletId.value)
        ? Draggable<Account>(
            data: widget.account,
            child: gestureWrapped(),
            feedback: roundedItem(true),
          )
        : DragTarget<Account>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return gestureWrapped();
            },
            onAccept: (data) {
              widget.onDragAccept(data, widget.account);
              setState(() {});
            },
          );
  }
}
