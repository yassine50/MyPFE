import 'package:flutter/material.dart';

/// Shared form data that flows through all steps of the listing creation wizard.
class AddListingController extends ChangeNotifier {
  // ── Step 2: Location & Basics ──────────────────────────────
  String streetAddress = '';
  String apartment = '';
  String city = 'Bucharest';
  String zipCode = '';
  int guests = 4;
  int bedrooms = 2;
  int bathrooms = 1;
  double latitude = 44.4268;
  double longitude = 26.1025;

  // ── Step 3: Photos ─────────────────────────────────────────
  final List<String> photoUrls = [];

  final List<String> photoLabels = [];

  // ── Step 4: Details & Amenities ────────────────────────────
  String title = '';
  String description = '';

  // amenity key -> selected
  final Map<String, bool> amenities = {
    'wifi': true,
    'workspace': false,
    'kitchen': true,
    'washer': false,
    'ac': false,
    'heating': true,
    'furnished': true,
    'smoke_alarm': false,
  };

  // ── Step 5: Price ──────────────────────────────────────────
  double price = 240.0;

  // ── Step 6: House Rules ────────────────────────────────────
  final Map<String, bool> houseRules = {
    'no_smoking': true,
    'no_parties': true,
    'pets_allowed': false,
    'quiet_hours': true,
  };

  // ── Helpers ────────────────────────────────────────────────
  void updateGuests(int delta) {
    guests = (guests + delta).clamp(1, 20);
    notifyListeners();
  }

  void updateBedrooms(int delta) {
    bedrooms = (bedrooms + delta).clamp(0, 20);
    notifyListeners();
  }

  void updateBathrooms(int delta) {
    bathrooms = (bathrooms + delta).clamp(1, 20);
    notifyListeners();
  }

  void updateCoordinates(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  void toggleAmenity(String key) {
    amenities[key] = !(amenities[key] ?? false);
    notifyListeners();
  }

  List<String> get selectedAmenityLabels {
    const labels = {
      'wifi': 'Wi-Fi',
      'workspace': 'Workspace',
      'kitchen': 'Kitchen',
      'washer': 'Washer',
      'ac': 'Air conditioning',
      'heating': 'Heating',
      'furnished': 'Furnished',
      'smoke_alarm': 'Smoke Alarm',
    };
    return amenities.entries
        .where((e) => e.value)
        .map((e) => labels[e.key] ?? e.key)
        .toList();
  }

  void updatePrice(double newPrice) {
    price = newPrice;
    notifyListeners();
  }

  void toggleHouseRule(String key) {
    houseRules[key] = !(houseRules[key] ?? false);
    notifyListeners();
  }

  List<String> get selectedHouseRules {
    const labels = {
      'no_smoking': 'No smoking',
      'no_parties': 'No parties or events',
      'pets_allowed': 'Pets allowed',
      'quiet_hours': 'Quiet hours (22:00 - 08:00)',
    };
    return houseRules.entries
        .where((e) => e.value)
        .map((e) => labels[e.key] ?? e.key)
        .toList();
  }
}
