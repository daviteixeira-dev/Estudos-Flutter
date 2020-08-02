import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import 'Funcionario.dart';

class Servicos {
  static const ROOT = 'http://127.0.0.1/CrediarioDB/funcionarios_actions.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // Metodo para criar a tabela de funcionarios.
  static Future<String> createTable() async {
    try {
      // adicione os parâmetros para passar para a solicitação.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Criar resposta da tabela: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Funcionario>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getFuncionarios Respota: ${response.body}');
      if (200 == response.statusCode) {
        List<Funcionario> list = parseResponse(response.body);
        return list;
      } else {
        return List<Funcionario>();
      }
    } catch (e) {
      return List<Funcionario>(); // retorna uma lista vazia em exceção / erro
    }
  }

  static List<Funcionario> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Funcionario>((json) => Funcionario.fromJson(json)).toList();
  }

  // Método para adicionar funcionário ao banco de dados ...
  static Future<String> addEmployee(String primeiroNome, String ultimoNome) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['primeiro_nome'] = primeiroNome;
      map['ultimo_nome'] = ultimoNome;
      final response = await http.post(ROOT, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Método para atualizar um funcionário no banco de dados ...
  static Future<String> updateEmployee(
      String empId, String primeiroNome, String ultimoNome) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['primeiro_nome'] = primeiroNome;
      map['ultimo_nome'] = ultimoNome;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Método para excluir um funcionário do banco de dados ...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // retornando apenas uma string "error" para manter isso simples ...
    }
  }
}
