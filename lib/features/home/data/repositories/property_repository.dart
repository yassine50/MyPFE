import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/property_model.dart';

class PropertyRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<PropertyModel>> fetchProperties() async {
    try {
      final snapshot = await _database.ref('properties').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        List<PropertyModel> properties = [];
        data.forEach((key, value) {
          properties.add(PropertyModel.fromJson(value as Map<dynamic, dynamic>, key.toString()));
        });
        return properties;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch properties: $e');
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    try {
      final newRef = _database.ref('properties').push();
      // Use the newly generated key as the ID for the property.
      // PropertyModel.toJson() does not include the id.
      await newRef.set(property.toJson());
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  // Stream version for real-time updates if needed
  Stream<List<PropertyModel>> get propertiesStream {
    return _database.ref('properties').onValue.map((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        List<PropertyModel> properties = [];
        data.forEach((key, value) {
          properties.add(PropertyModel.fromJson(value as Map<dynamic, dynamic>, key.toString()));
        });
        return properties;
      }
      return [];
    });
  }
}
