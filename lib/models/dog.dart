import 'dart:convert';

class Dog {
  final int? id;
  final String name;
  final int age;

  Dog({
    this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dog.fromJson(String source) => Dog.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
