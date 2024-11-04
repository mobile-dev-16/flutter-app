enum Category {
  restaurant,
  ingredients,
  store,
  dairy,
  drink;

  String get displayName {
    switch (this) {
      case Category.restaurant:
        return 'Restaurant';
      case Category.ingredients:
        return 'Ingredients';
      case Category.store:
        return 'Store';
      case Category.dairy:
        return 'Dairy';
      case Category.drink:
        return 'Drink';
    }
  }
}
