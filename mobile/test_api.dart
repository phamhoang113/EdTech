import 'dart:convert';
import 'dart:io';

void main() async {
  final request = await HttpClient().getUrl(Uri.parse('http://localhost:8080/api/v1/classes/open'));
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final data = jsonDecode(stringData)['data'] as List;
  
  if (data.isNotEmpty) {
    final item = data[0] as Map<String, dynamic>;
    print('Testing null fields:');
    item.forEach((key, value) {
      if (value == null) {
        print('FIELD IS NULL: $key');
      }
    });
  } else {
    print('No data');
  }
}
