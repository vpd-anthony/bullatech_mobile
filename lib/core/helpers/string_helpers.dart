import 'package:html/parser.dart' show parse;

class StringHelper {
  StringHelper._();

  static String stripHtml(final String htmlText) {
    final document = parse(htmlText);
    return document.body?.text ?? '';
  }
}
