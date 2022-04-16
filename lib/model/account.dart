import 'package:finanzas_personales/model/account_type.dart';
import 'package:finanzas_personales/objectbox.g.dart';

@Entity()
class Account {
  double balance = 0;
  String name = "";
  int typeId;
  double planned = 0;
  int id;
  @Transient()
  bool showMenu = false;

  Account(
      {this.id = 0,
      required this.balance,
      required this.name,
      required this.planned,
      required this.typeId});

  /// The Store of this app.
  late final Store store;
}
