import 'package:finanzas_personales/model/account.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Movement {
  double total = 0;
  String description = "";
  int id;
  // @Transient()
  // bool showMenu = false;+
  @Property(type: PropertyType.date)
  DateTime date;

  Movement({this.id = 0, required this.date});
  final toAccount = ToOne<Account>();
  final fromAccount = ToOne<Account>();
}
