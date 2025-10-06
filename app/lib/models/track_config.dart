class TrackConfig {
  final String surface;
  final String condition;
  final String prep;
  final double? trackTempC;

  TrackConfig({
    required this.surface,
    required this.condition,
    required this.prep,
    this.trackTempC,
  });

  Map<String, dynamic> toJson() {
    return {
      'surface': surface,
      'condition': condition,
      'prep': prep,
      'track_temp_c': trackTempC,
    };
  }

  factory TrackConfig.fromJson(Map<String, dynamic> json) {
    return TrackConfig(
      surface: json['surface'] ?? 'asphalt',
      condition: json['condition'] ?? 'dry',
      prep: json['prep'] ?? 'unprepped',
      trackTempC: json['track_temp_c']?.toDouble(),
    );
  }

  TrackConfig copyWith({
    String? surface,
    String? condition,
    String? prep,
    double? trackTempC,
  }) {
    return TrackConfig(
      surface: surface ?? this.surface,
      condition: condition ?? this.condition,
      prep: prep ?? this.prep,
      trackTempC: trackTempC ?? this.trackTempC,
    );
  }

  static const List<String> surfaces = [
    'asphalt',
    'concrete',
    'gravel',
    'snow',
    'tarmac',
  ];

  static const List<String> conditions = [
    'dry',
    'damp',
    'wet',
  ];

  static const List<String> prepLevels = [
    'unprepped',
    'light',
    'heavy',
  ];

  String get surfaceDisplayName {
    switch (surface) {
      case 'asphalt':
        return 'Asphalt';
      case 'concrete':
        return 'Concrete';
      case 'gravel':
        return 'Gravel';
      case 'snow':
        return 'Snow';
      case 'tarmac':
        return 'Tarmac';
      default:
        return surface;
    }
  }

  String get conditionDisplayName {
    switch (condition) {
      case 'dry':
        return 'Dry';
      case 'damp':
        return 'Damp';
      case 'wet':
        return 'Wet';
      default:
        return condition;
    }
  }

  String get prepDisplayName {
    switch (prep) {
      case 'unprepped':
        return 'Unprepped';
      case 'light':
        return 'Light Prep';
      case 'heavy':
        return 'Heavy Prep';
      default:
        return prep;
    }
  }
}
