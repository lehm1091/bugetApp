import 'package:finanzas_personales/model/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color orangeColor = Color.fromARGB(255, 255, 142, 0);
const Color greenColor = Color.fromARGB(255, 6, 211, 152);
const Color grayColor = Color.fromARGB(255, 193, 196, 201);
const Color redColor = Color.fromARGB(255, 229, 57, 53);
const Color yellowColor = Color.fromARGB(255, 255, 204, 0);

class AccountDisplay extends StatefulWidget {
  Account account;
  Function onEdit;
  Function onDelete;
  AccountDisplay(
      {required this.account,
      required this.onEdit,
      required this.onDelete,
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
    if (widget.account.typeId == 4) {
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
      width: 120,
      child: Center(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: widget.account.showMenu
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.account.typeId != 1 ? yellowColor : null,
                      gradient: widget.account.typeId == 1
                          ? LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: getStops(),
                              colors: getColors(),
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        widget.account.typeId == 1
                            ? "${widget.account.balance.toStringAsFixed(0)}/${widget.account.planned.toStringAsFixed(0)}"
                            : "${widget.account.balance.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 12, color: getTextColor()),
                      ),
                    ),
                  ),
                  if (!isFeedback)
                    Container(
                      margin: const EdgeInsets.all(2),
                      child: Text(widget.account.name),
                    ),
                ],
              ),
              Container(
                child: widget.account.showMenu
                    ? GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onTap: () {
                          widget.onDelete();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.account.typeId == 4)
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
              return roundedItem(false);
            },
            onAccept: (data) {
              print(data.name);
              data.balance = data.balance - 50.0;
              widget.account.balance = widget.account.balance + 50.0;
              setState(() {});
            },
          );
  }
}
