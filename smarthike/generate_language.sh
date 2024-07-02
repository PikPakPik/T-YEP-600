#!/bin/bash

flutter pub run easy_localization:generate --source-dir 'assets/locales' --output-dir 'lib/core/init/gen' --output-file 'translations.g.dart' --format keys
echo "// ignore_for_file: constant_identifier_names" | cat - lib/core/init/gen/translations.g.dart > temp && mv temp lib/core/init/gen/translations.g.dart