import re

with open('lib/core/api_service.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);", 
                    "return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 5));")

text = text.replace("body: jsonEncode(body),\n    );", 
                    "body: jsonEncode(body),\n    ).timeout(const Duration(seconds: 5));")

text = text.replace("return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);", 
                    "return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 5));")

with open('lib/core/api_service.dart', 'w', encoding='utf-8') as f:
    f.write(text)
