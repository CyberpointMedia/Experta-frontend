class SetAvailabilityModel {
  String id;
  String startTime;
  String endTime;
  List<String> weeklyRepeat;
  int v;

  SetAvailabilityModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.weeklyRepeat,
    required this.v,
  });

  factory SetAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return SetAvailabilityModel(
      id: json["_id"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      weeklyRepeat: List<String>.from(json["weeklyRepeat"]),
      v: json["__v"],
    );
  }

  bool get isEveryday {
    final allDays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
    return weeklyRepeat.length == 7 &&
        weeklyRepeat.every((day) => allDays.contains(day));
  }
}
