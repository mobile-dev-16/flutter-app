enum CuisineType {
  local,
  italian,
  mexican,
  chinese,
  japanese,
  indian,
  american,
  thai,
  mediterranean,
  vietnamese,
  korean,
  other;

  String get displayName {
    switch (this) {
      case CuisineType.local:
        return 'Local';
      case CuisineType.italian:
        return 'Italian';
      case CuisineType.mexican:
        return 'Mexican';
      case CuisineType.chinese:
        return 'Chinese';
      case CuisineType.japanese:
        return 'Japanese';
      case CuisineType.indian:
        return 'Indian';
      case CuisineType.american:
        return 'American';
      case CuisineType.thai:
        return 'Thai';
      case CuisineType.mediterranean:
        return 'Mediterranean';
      case CuisineType.vietnamese:
        return 'Vietnamese';
      case CuisineType.korean:
        return 'Korean';
      case CuisineType.other:
        return 'Other';
    }
  }
}

extension CuisineTypeExtension on CuisineType {
  static CuisineType fromString(String value) {
    return CuisineType.values.firstWhere(
      (CuisineType type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => CuisineType.other,
    );
  }
}
