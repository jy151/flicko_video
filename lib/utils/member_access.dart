import 'package:flicko_video/api/model/member_model.dart';

bool isActiveVipMember(Member? member) {
  final endDate = vipEndDateTime(member?.vipEndDate);
  return member?.isVip == true &&
      endDate != null &&
      endDate.isAfter(DateTime.now());
}

DateTime? vipEndDateTime(int? timestamp) {
  if (timestamp == null || timestamp <= 0) {
    return null;
  }

  final milliseconds = timestamp > 1000000000000 ? timestamp : timestamp * 1000;
  return DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
}
