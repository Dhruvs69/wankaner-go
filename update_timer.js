const fs = require('fs');
const file = 'lib/features/auth/screens/customer_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/int nextPage = _bannerController\.page!\.round\(\) \+ 1;\s*if \(nextPage > 1\) \{\s*nextPage = 0; \/\/ We have 2 banners right now\s*\}/, `int nextPage = _bannerController.page!.round() + 1;
        final length = ref.read(bannersProvider).value?.length ?? 2;
        if (nextPage >= length) {
          nextPage = 0;
        }`);

fs.writeFileSync(file, text);
