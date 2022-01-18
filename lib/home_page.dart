import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _ageController = TextEditingController();
  String? _manufacturer;
  String? _msg = '';
  bool oneShot = false;
  bool twoShot = false;
  DateTime? selectedDate;

  _showDataPicker() {
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  _toCheck() {
    int age = int.parse(_ageController.text);

    if (age >= 12 && oneShot) {
      setState(() {
        _msg = 'Você já pode tomar a 1º Dose ';
      });
    } else if (age == '') {
      setState(() {
        _msg = 'Insira sua idade';
      });
    } else if (_manufacturer == null) {
      setState(() {
        _msg = 'Selecione a vacina que você tomou na primeira Dose';
      });
    } else if (selectedDate == null) {
      setState(() {
        _msg = 'Selecione a data';
      });
    } else if (age >= 12 && selectedDate != null && _manufacturer != null) {
      if (age < 18) {
        var today = DateTime.now();
        int diferrence = today.difference(selectedDate!).inDays;
        if (diferrence >= 21 && twoShot == false && oneShot == false) {
          setState(() {
            _msg = 'Você já pode tomar a Segunda Dose';
          });
        } else if (twoShot == true) {
          setState(() {
            _msg = 'Você ainda não pode tomar a Dose Adicional';
          });
        } else {
          setState(() {
            _msg = 'Aguarde completar 28 dias';
          });
        }
      } // fim do if dos Adolescentes
      else if (age >= 18) {
        var today = DateTime.now();
        int diferrence = today.difference(selectedDate!).inDays;
        if (diferrence >= 120 && twoShot == true) {
          setState(() {
            _msg = 'Você já pode tomar a Dose Adicional';
          });
        } else if (oneShot == false && twoShot == false) {
          if (_manufacturer == 'Corona' && diferrence >= 15) {
            setState(() {
              _msg = 'Você já pode tomar a Segunda Dose';
            });
          } else if (_manufacturer == 'Astra' && diferrence >= 56) {
            setState(() {
              _msg = 'Você já pode tomar a Segunda Dose';
            });
          } else if (_manufacturer == 'Pfizer' && diferrence >= 21) {
            setState(() {
              _msg = 'Você já pode tomar a Segunda Dose';
            });
          } else if (_manufacturer == 'Janssen' && diferrence >= 60) {
            setState(() {
              _msg = 'Você já pode tomar a Segunda Dose';
            });
          } else if (_manufacturer == null) {
            setState(() {
              _msg = 'Selecione a vacina que você tomou na primeira Dose';
            });
          } else {
            setState(() {
              _msg = 'Você ainda não pode tomar a Segunda Dose';
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Vacina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
                'Preencha as informações para saber se você já pode tomar a vacina '),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(label: Text('Insira sua idade')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('É a primeira Dose?'),
                Switch(
                    value: oneShot,
                    onChanged: (value) {
                      setState(() {
                        oneShot = value;
                        twoShot = false;
                        _msg = '';
                      });
                    }),
                Text('Tomou a 2º Dose?'),
                Switch(
                    value: twoShot,
                    onChanged: (value) {
                      setState(() {
                        oneShot = false;
                        twoShot = value;
                        _msg = '';
                      });
                    }),
              ],
            ),
            oneShot
                ? Container()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Radio(
                            value: 'Corona',
                            groupValue: _manufacturer,
                            onChanged: (String? manufacturer) {
                              setState(() {
                                _manufacturer = manufacturer;
                              });
                              print(manufacturer);
                            }),
                        const Text('CoronaVac, Butantan'),
                        Radio(
                            value: 'Astra',
                            groupValue: _manufacturer,
                            onChanged: (String? manufacturer) {
                              setState(() {
                                _manufacturer = manufacturer;
                              });
                              print(manufacturer);
                            }),
                        const Text('Oxford, AstraZeneca'),
                        Radio(
                            value: 'Pfizer',
                            groupValue: _manufacturer,
                            onChanged: (String? manufacturer) {
                              setState(() {
                                _manufacturer = manufacturer;
                              });
                              print(manufacturer);
                            }),
                        const Text('Vacina BioNTech, Pfizer'),
                        Radio(
                            value: 'Janssen',
                            groupValue: _manufacturer,
                            onChanged: (String? manufacturer) {
                              setState(() {
                                _manufacturer = manufacturer;
                              });
                            }),
                        const Text('Janssen Johnson & Johnson'),
                      ],
                    ),
                  ),
            oneShot
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      twoShot
                          ? Text('Data da segunda dose')
                          : Text('Data da primeira dose'),
                      TextButton(
                        onPressed: _showDataPicker,
                        child: selectedDate == null
                            ? Text('Selecionar Data')
                            : Text(
                                DateFormat('dd/MM/y')
                                    .format(selectedDate!)
                                    .toString(),
                              ),
                      )
                    ],
                  ),
            TextButton(onPressed: _toCheck, child: Text('Verificar')),
            Text(_msg!),
          ],
        ),
      ),
    );
  }
}
