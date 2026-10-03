const fs = require('fs');

let text = fs.readFileSync('lib/models/user_model.dart', 'utf-8');

text = text.replace(
  '@JsonKey(name: "is_online") int? isOnline,',
  '// ignore: invalid_annotation_target\n    @JsonKey(name: "is_online") int? isOnline,'
);

fs.writeFileSync('lib/models/user_model.dart', text, 'utf-8');
console.log('Added ignore comment to UserModel!');
