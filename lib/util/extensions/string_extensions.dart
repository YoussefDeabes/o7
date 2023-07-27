extension Validation on String {
  bool get isNullOrEmpty => (this != null && this.isNotEmpty) ? false : true;
}

extension StringExtension on String {
  String capitalizedFirstChar() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

extension DigitsConverter on String {
  String _toArabicDigits() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      switch (this[i]) {
        case '0':
          sb.write('\u0660');
          break;
        case '1':
          sb.write('\u0661');
          break;
        case '2':
          sb.write('\u0662');
          break;
        case '3':
          sb.write('\u0663');
          break;
        case '4':
          sb.write('\u0664');
          break;
        case '5':
          sb.write('\u0665');
          break;
        case '6':
          sb.write('\u0666');
          break;
        case '7':
          sb.write('\u0667');
          break;
        case '8':
          sb.write('\u0668');
          break;
        case '9':
          sb.write('\u0669');
          break;
        default:
          sb.write(this[i]);
          break;
      }
    }
    return sb.toString();
  }

  String translateDigits({required String languageCode}) {
    if (languageCode != 'ar') {
      return this;
    } else {
      return _toArabicDigits();
    }
  }
}
