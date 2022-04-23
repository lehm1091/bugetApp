import 'package:finanzas_personales/views/dashboard/controller/dashboard_controller.dart';
import 'package:finanzas_personales/views/movements/movements.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  var _controller = Get.put(DashboardController());

  Future<bool> showYesOrNoDialog(String title) async {
    return await Get.dialog(AlertDialog(
      content: Container(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Si'),
                    onPressed: () => Get.back(result: true),
                    // ** result: returns this value up the call stack **
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    child: Text('Cancelar'),
                    onPressed: () => Get.back(result: false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Finanzas Personales'),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Icon(Icons.account_balance),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services_rounded),
            title: Text('Reiniciar Balances'),
            onTap: () async {
              bool res = await showYesOrNoDialog(
                  "Se reiniciaran todos los balances, esta seguro?");
              if (res) {
                await _controller.resetBalances();
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Borrar Todo'),
            onTap: () async {
              bool res =
                  await showYesOrNoDialog("Se borrara todo, desea seguir?");
              if (res) {
                await _controller.deleteAll();
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.history_edu),
            title: Text('Historial de movimientos'),
            onTap: () async {
              Get.to(() => Movements());
            },
          ),
        ],
      ),
    );
  }
}
