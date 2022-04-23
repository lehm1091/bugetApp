import 'package:finanzas_personales/model/account_type.dart';

List<AccountType> accountTypesList = <AccountType>[
  AccountType(id: AccountTypeId.expendIdGroupA.value, name: "Gasto A"),
  AccountType(id: AccountTypeId.expendIdGroupB.value, name: "Gasto B"),
  // AccountType(id: 2, name: "INCOME"),
  // AccountType(id: 3, name: "SAVING"),
  AccountType(id: AccountTypeId.walletId.value, name: "Billeteras"),
];

enum AccountTypeId {
  expendIdGroupA(1),
  expendIdGroupB(2),
  incomeId(3),
  walletId(4);

  const AccountTypeId(this.value);
  final int value;
}
