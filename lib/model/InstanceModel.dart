class InstanceModel {
  final int instanceId;
  final String date;
  final String teacher;
  final String classDay;
  final String classTime;

  InstanceModel({
    required this.instanceId,
    required this.date,
    required this.teacher,
    required this.classDay,
    required this.classTime,
  });

  factory InstanceModel.fromJson(Map<String, dynamic> json) {
    return InstanceModel(
      instanceId: json['instanceId'],
      date: json['date'],
      teacher: json['teacher'],
      classDay: json['classDay'],
      classTime: json['classTime'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'instanceId': instanceId,
      'date': date,
      'teacher': teacher,
      'classDay': classDay,
      'classTime': classTime,
    };
  }
}
