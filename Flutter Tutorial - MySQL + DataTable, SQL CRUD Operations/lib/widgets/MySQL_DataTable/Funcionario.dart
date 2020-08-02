class Funcionario {
  String id;
  String primeiroNome;
  String ultimoNome;

  Funcionario({this.id, this.primeiroNome, this.ultimoNome});

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'] as String,
      primeiroNome: json['primeiro_nome'] as String,
      ultimoNome: json['ultimo_nome'] as String,
    );
  }
}
