const fs = require('fs');

let text = fs.readFileSync('lib/models/user_model.dart', 'utf-8');

text = text.replace(
  '@Default(true) bool isActive,',
  '@Default(true) bool isActive,\n    @JsonKey(name: "is_online") int? isOnline,'
);

fs.writeFileSync('lib/models/user_model.dart', text, 'utf-8');
console.log('Added isOnline to UserModel!');
