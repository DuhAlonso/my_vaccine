import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_vaccine/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _ageController = TextEditingController();
  String? _manufacturer;
  String? _msg = '';
  bool oneShot = false;
  bool defCheck = false;
  bool comoCheck = false;
  bool indCheck = false;
  bool twoShot = false;
  DateTime? selectedDate;
  bool isKids = false;

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

  _validator() {
    setState(() {
      _msg = 'Insira sua idade';
    });
  }

  _toCheck() {
    if (_ageController.text.isEmpty) {
      _validator();
    } else {
      int age = int.parse(_ageController.text);

      if (age >= 12 && oneShot) {
        setState(() {
          _msg = 'Você já pode tomar a 1º Dose ';
        });
      } else if (oneShot == false &&
          (_manufacturer == null || selectedDate == null)) {
        setState(() {
          _msg = 'Selecione os itens faltando';
        });
      } else if (age >= 12 &&
          age < 18 &&
          selectedDate != null &&
          _manufacturer != null) {
        if (age > 11 && age < 18) {
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

      } else if (age >= 18) {
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
        } else {
          setState(() {
            _msg = 'Você ainda não pode tomar a Dose Adicional';
          });
        }
        // fim if adultos
      } else if (age >= 5 && age < 12) {
        if (oneShot) {
          if (comoCheck == true || defCheck == true || indCheck == true) {
            setState(() {
              _msg = 'Você já pode tomar a 1º Dose';
            });
          } else {
            setState(() {
              _msg = 'Você ainda não pode tomar a 1º Dose';
            });
          }
        } else if (oneShot == false && twoShot == false) {
          setState(() {
            _msg = 'Ainda não pode tomar a 2º Dose';
          });
        }
      } else if (age < 5) {
        setState(() {
          _msg = 'A vacina ainda não foi liberada para sua idade';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text('Minha Vacina - Sampa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Preencha as informações para saber se você já pode tomar a vacina.',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 150,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    //autofocus: true,
                    controller: _ageController,
                    decoration: InputDecoration(
                        hintText: 'Digite sua idade',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: 'Idade',
                        labelStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                    onFieldSubmitted: (_) {
                      _toCheck();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('É a primeira Dose?'),
                  Switch(
                      value: oneShot,
                      onChanged: (value) {
                        setState(() {
                          oneShot = value;
                          twoShot = false;
                          _msg = '';
                        });
                      }),
                  const Text('Tomou a 2º Dose?'),
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
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          const Text(
                            'Você possui alguma:',
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Comorbidade'),
                              Checkbox(
                                  value: defCheck,
                                  onChanged: (v) {
                                    setState(() {
                                      defCheck = v!;
                                    });
                                  }),
                              const Text('Deficiência permanaemte'),
                              Checkbox(
                                  value: comoCheck,
                                  onChanged: (v) {
                                    setState(() {
                                      comoCheck = v!;
                                    });
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('População indígena?'),
                              Checkbox(
                                  value: indCheck,
                                  onChanged: (v) {
                                    setState(() {
                                      indCheck = v!;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1, color: Colors.black)),
                      height: 130,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                twoShot
                                    ? const Text(
                                        'Escolha a vacina que tomou na 2º dose',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Text(
                                        'Escolha a vacina que tomou na 1º dose',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                RadioListTile(
                                    title: const Text('CoronaVac, Butantan'),
                                    value: 'Corona',
                                    groupValue: _manufacturer,
                                    onChanged: (String? manufacturer) {
                                      setState(() {
                                        _manufacturer = manufacturer;
                                      });
                                    }),
                                RadioListTile(
                                    title: const Text('Oxford, AstraZeneca'),
                                    value: 'Astra',
                                    groupValue: _manufacturer,
                                    onChanged: (String? manufacturer) {
                                      setState(() {
                                        _manufacturer = manufacturer;
                                      });
                                    }),
                                RadioListTile(
                                    title: const Text('BioNTech, Pfizer'),
                                    value: 'Pfizer',
                                    groupValue: _manufacturer,
                                    onChanged: (String? manufacturer) {
                                      setState(() {
                                        _manufacturer = manufacturer;
                                      });
                                    }),
                                RadioListTile(
                                    title:
                                        const Text('Janssen Johnson & Johnson'),
                                    value: 'Janssen',
                                    groupValue: _manufacturer,
                                    onChanged: (String? manufacturer) {
                                      setState(() {
                                        _manufacturer = manufacturer;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              oneShot
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          twoShot
                              ? const Text(
                                  'Data da segunda dose',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : const Text(
                                  'Data da primeira dose',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                          TextButton(
                            onPressed: _showDataPicker,
                            child: selectedDate == null
                                ? const Text('Selecionar Data',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))
                                : Text(
                                    DateFormat('dd/MM/y')
                                        .format(selectedDate!)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: TextButton(
                  onPressed: _toCheck,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Verificar',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  _msg!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
