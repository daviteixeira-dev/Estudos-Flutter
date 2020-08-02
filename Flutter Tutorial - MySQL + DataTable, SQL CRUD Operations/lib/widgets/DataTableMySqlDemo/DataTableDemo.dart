import 'package:flutter/material.dart';
import 'Funcionario.dart';
import 'Servicos.dart';
import 'dart:async';

class DataTableDemo extends StatefulWidget {
  //
  DataTableDemo() : super();

  final String title = 'Flutter Tabela de Dados';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

// Agora vamos escrever uma classe que ajudará na pesquisa.
// Isso é chamado de classe Debouncer.
// Fiz outros vídeos explicando sobre as classes do debouncer
// O link é fornecido na descrição ou toque no botão 'i' no canto direito do vídeo.
// A classe Debouncer ajuda a adicionar um atraso à pesquisa
// isso significa que quando a classe aguardará o usuário parar por um tempo definido
// e comece a pesquisar
// Portanto, se o usuário digitar continuamente sem demora, ele não pesquisará
// Isso ajuda a manter o aplicativo com melhor desempenho e se a pesquisa estiver atingindo diretamente o servidor
// também mantém menos ocorrências no servidor.
// Vamos escrever a classe Debouncer.

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel(); // quando o usuário está digitando continuamente, isso cancela o timer
    }
    // então iniciaremos um novo timer procurando o usuário parar
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Funcionario> _employees;
  // esta lista manterá os funcionários filtrados
  List<Funcionario> _filterEmployees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // controlador para o primeiro nome TextField que vamos criar.
  TextEditingController _firstNameController;
  // controlador para o sobrenome TextField que vamos criar.
  TextEditingController _lastNameController;
  Funcionario _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;
  // Isso aguardará 500 milissegundos após o usuário parar de digitar.
  // Isso coloca menos pressão no dispositivo durante a pesquisa.
  // Se a pesquisa for feita no servidor enquanto você digita, mantém o
  // servidor caiu, melhorando assim o desempenho e conservando
  // duração da bateria ...
  final _debouncer = Debouncer(milliseconds: 2000);
  // Permite aumentar o tempo de espera e pesquisar para 2 segundos.
  // Então agora está pesquisando após 2 segundos quando o usuário para de digitar ...
  // É assim que podemos fazer a filtragem no Flutter DataTables.

  @override
  void initState() {
    super.initState();
    _employees = [];
    _filterEmployees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // para obter o contexto para mostrar uma SnackBar
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  // Método para atualizar o título no AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Criando tabela ...');
    Servicos.createTable().then((result) {
      if ('success' == result) {
        // Tabela criada com sucesso.
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  // Now lets add an Employee
  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding Employee...');
    Servicos.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Servicos.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
        // Initialize to the list from Server when reloading...
        _filterEmployees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Funcionario employee) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Employee...');
    Servicos.updateEmployee(
        employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Funcionario employee) {
    _showProgress('Deleting Employee...');
    Servicos.deleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh after delete...
      }
    });
  }

  // Método para limpar os valores do TextField
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Funcionario employee) {
    _firstNameController.text = employee.primeiroNome;
    _lastNameController.text = employee.ultimoNome;
  }

// Since the server is running locally you may not
// see the progress in the titlebar, its so fast...
// :)

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('PRIMEIRO NOME'),
            ),
            DataColumn(
              label: Text('ULTIMO NOME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          // the list should show the filtered list now
          rows: _filterEmployees
              .map(
                (employee) => DataRow(cells: [
              DataCell(
                Text(employee.id),
                // Add tap in the row and populate the
                // textfields with the corresponding values to update
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  employee.primeiroNome.toUpperCase(),
                ),
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  // Set flag updating to true to indicate in Update Mode
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  employee.ultimoNome.toUpperCase(),
                ),
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteEmployee(employee);
                },
              ))
            ]),
          )
              .toList(),
        ),
      ),
    );
  }

  // Let's add a searchfield to search in the DataTable.
  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter by First name or Last name',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filterEmployees = _employees
                  .where((u) => (u.primeiroNome
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.ultimoNome.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  // id is coming as String
  // So let's update the model...

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // mostramos o progresso no título ...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Primeiro Nome',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Ultimo Nome',
                ),
              ),
            ),

            // Adicione um botão de atualização e um botão Cancelar
            // Mostra esses botões apenas ao atualizar um funcionário
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateEmployee(_selectedEmployee);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            searchField(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
