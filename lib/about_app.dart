import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o APP'),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Este App trata de uma simulação com base nas informações fornecidas pela prefeitura de São Paulo. \nPara confirmação procure sua unidade de saúde.',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.justify,
          ),
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: SizedBox(height: 10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Feito com ❤️ por '),
            TextButton(
                onPressed: () {
                  launch('https://github.com/DuhAlonso');
                },
                child: const Text('DuhAlonso'))
          ],
        )
      ]),
    );
  }
}
