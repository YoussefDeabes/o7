import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class PDFAPI {
  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final byets = response.bodyBytes;
    return _storeFile(byets, url);
  }

  static Future<File> _storeFile(List<int> byets, String url) async {
    final fileName = basename(url);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(byets, flush: true);
    return file;
  }
}
