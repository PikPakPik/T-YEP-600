import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

String formatSecondsToHoursAndMinutes(int? seconds) {
  if (seconds == null) {
    return LocaleKeys.hike_details_unknown.tr();
  }
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  return '${hours}h ${minutes}m';
}
