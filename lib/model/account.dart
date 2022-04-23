import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/model/movement.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Account {
  double balance = 0;
  String name = "";
  int typeId;
  double planned = 0;
  int id;
  @Transient()
  bool showMenu = false;
  final movements = ToMany<Movement>();
  Account(
      {this.id = 0,
      required this.balance,
      required this.name,
      required this.planned,
      required this.typeId});
  // Account(
  //     {this.id = 0,
  //     this.balance = 0,
  //     this.name = "",
  //     this.planned = 0,
  //     this.typeId = 0});
}
