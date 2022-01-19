import 'package:flutter/material.dart';
import 'package:my_vaccine/about_app.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://www.saopaulo.sp.gov.br/wp-content/uploads/2021/01/thumb-vacina-ja.jpg')),
            ),
            child: Text(''),
          ),
          ListTile(
            title: const Text('Instrutivo SP - Site Prefeitura'),
            onTap: () {
              launch(
                  'https://www.prefeitura.sp.gov.br/cidade/secretarias/saude/vigilancia_em_saude/doencas_e_agravos/coronavirus/index.php?p=323901');
            },
          ),
          ListTile(
            title: const Text('Sobre o APP'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutApp()));
            },
          ),
        ],
      ),
    );
  }
}
