enum CuisineType {
  italian,
  chinese,
  mexican,
  indian,
  japanese,
  thai,
  french,
  mediterranean,
  vegan,
  local,
}

extension CuisineTypeExtension on CuisineType {
  String get displayName {
    switch (this) {
      case CuisineType.italian:
        return 'Italian';
      case CuisineType.chinese:
        return 'Chinese';
      case CuisineType.mexican:
        return 'Mexican';
      case CuisineType.indian:
        return 'Indian';
      case CuisineType.japanese:
        return 'Japanese';
      case CuisineType.thai:
        return 'Thai';
      case CuisineType.french:
        return 'French';
      case CuisineType.mediterranean:
        return 'Mediterranean';
      case CuisineType.vegan:
        return 'Vegan';
      case CuisineType.local:
        return 'Local';
    }
  }

  static CuisineType fromString(String cuisine) {
    return CuisineType.values.firstWhere(
      (CuisineType e) =>
          e.toString().split('.').last.toLowerCase() == cuisine.toLowerCase(),
      orElse: () => CuisineType.local,
    );
  }
}
