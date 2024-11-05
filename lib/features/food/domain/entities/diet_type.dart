enum DietType {
  vegetarian,
  vegan,
  pescatarian,
  glutenFree,
  keto,
  none,
  unknown;

  String get displayName {
    switch (this) {
      case DietType.vegetarian:
        return 'Vegetarian';
      case DietType.vegan:
        return 'Vegan';
      case DietType.pescatarian:
        return 'Pescatarian';
      case DietType.glutenFree:
        return 'Gluten-Free';
      case DietType.keto:
        return 'Keto';
      case DietType.none:
        return 'None';
      case DietType.unknown:
        return 'Unknown';
    }
  }
}

extension DietTypeExtension on DietType {
  static DietType fromString(String value) {
    return DietType.values.firstWhere(
      (DietType type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => DietType.unknown,
    );
  }
}
