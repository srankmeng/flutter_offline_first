import 'package:flutter/material.dart';
import '../models/dog.dart';

class DogBuilder extends StatelessWidget {
  const DogBuilder({
    Key? key,
    required this.dogs,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<Dog>> dogs;
  final Function(Dog) onEdit;
  final Function(Dog) onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dog>>(
      future: dogs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final dog = snapshot.data![index];
              return _buildDogCard(dog, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildDogCard(Dog dog, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Age: ${dog.age.toString()}'),
                      const SizedBox(width: 16.0),
                      Text('Version: ${dog.version.toString()}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(dog),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.edit, color: Colors.orange[800]),
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(dog),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
