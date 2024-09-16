const String _defaultSeparator = ',';
const int _defaultGroupSize = 3;
final RegExp _defaultPattern = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

String formatPrice(
  int price, [
  String separator = _defaultSeparator,
  int groupSize = _defaultGroupSize,
]) {
  final RegExp pattern = _defaultPattern;

  return price.toString().replaceAllMapped(
        pattern,
        (Match m) => '${m[1]}$separator',
      );
}
