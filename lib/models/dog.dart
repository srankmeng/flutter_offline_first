import 'dart:convert';

class Dog {
  final int? id;
  final String name;
  final int age;
  final int version;
  final String status;

  Dog({
    this.id,
    required this.name,
    required this.age,
    required this.version,
    required this.status,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'version': version,
      'status': status,
    };
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      version: map['version']?.toInt() ?? 0,
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Dog.fromJson(String source) => Dog.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age, version: $version, status: $status}';
  }
}
