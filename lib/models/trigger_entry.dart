class TriggerEntry {
  final String trigger;
  final bool didSmoke;
  final DateTime timestamp;
  final String? note;

  TriggerEntry({
    required this.trigger,
    required this.didSmoke,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'trigger': trigger,
        'didSmoke': didSmoke,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };

  factory TriggerEntry.fromJson(Map<String, dynamic> json) {
    return TriggerEntry(
      trigger: json['trigger'],
      didSmoke: json['didSmoke'],
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
    );
  }
}
