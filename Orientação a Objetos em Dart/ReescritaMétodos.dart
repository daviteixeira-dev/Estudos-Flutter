class Animal {
  
  String nome;
  double peso;
  
  Animal(this.nome, this.peso);
  
  void comer() {
    print("$nome comeu!");
  }
  
  void fazerSom() {
    print("$nome fez algum som!");
  }
  
  @override
  String toString() {
    return "Animal | Nome: $nome, Peso: $peso";
  }
  
}

class Cachorro extends Animal {
  
  int fofura;
  
  Cachorro(String nome, double peso, this.fofura) : super(nome, peso);
  
  void brincar() {
    fofura += 10;
    print("Fofura do $nome aumentou para $fofura!!!");
  }
  
  @override
  void fazerSom() {
    print("$nome fez au au!");
  }
  
  @override
  String toString() {
    return "Cachorro | Nome: $nome, Peso: $peso, Fofura: $fofura";
  }
  
}

class Gato extends Animal {
  
  Gato(String nome, double peso) : super(nome, peso);
  
  bool estaAmigavel() {
    return true;
  }
  
  @override
  void fazerSom() {
    print("$nome fez miaaauuu!");
  }
  
  @override
  String toString() {
    return "Gato | Nome: $nome, Peso: $peso";
  }
  
}


void main() {
  Animal animal = Animal("Rex", 20.0);
  animal.fazerSom();
  animal.comer();
  print(animal);
  
  Cachorro cachorro = Cachorro("Dog", 10.0, 100);
  cachorro.fazerSom();
  cachorro.comer();
  cachorro.brincar();
  print(cachorro);
  
  Gato gato = Gato("Cat", 10.0);
  gato.fazerSom();
  gato.comer();
  print("Esta amigável? ${gato.estaAmigavel()}");
  print(gato);
}