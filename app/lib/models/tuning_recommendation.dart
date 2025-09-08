class TuningRecommendation {
  final String raceMode;
  final Map<String, dynamic> corrections;
  final Map<String, dynamic> sparkGap;
  final String insight;

  TuningRecommendation({
    required this.raceMode,
    required this.corrections,
    required this.sparkGap,
    required this.insight,
  });

  factory TuningRecommendation.fromJson(Map<String, dynamic> json) {
    return TuningRecommendation(
      raceMode: json['race_mode'] ?? '',
      corrections: json['corrections'] ?? {},
      sparkGap: json['spark_gap'] ?? {},
      insight: json['insight'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'race_mode': raceMode,
      'corrections': corrections,
      'spark_gap': sparkGap,
      'insight': insight,
    };
  }

  // Helper getters for easy access to correction values
  int get launchRpm => corrections['launch_rpm'] ?? 0;
  double get fuelTrimPct => corrections['fuel_trim_pct']?.toDouble() ?? 0.0;
  double get ignitionTrimDeg => corrections['ignition_trim_deg']?.toDouble() ?? 0.0;
  double get wgdcTrimPct => corrections['wgdc_trim_pct']?.toDouble() ?? 0.0;
  String get antilag => corrections['antilag'] ?? 'off';
  double? get tirePressureHotPsi => corrections['tire_pressure_hot_psi']?.toDouble();

  // Helper getters for spark gap data
  List<double> get gapIn => (sparkGap['gap_in'] as List?)?.cast<double>() ?? [0.0, 0.0];
  List<double> get gapMm => (sparkGap['gap_mm'] as List?)?.cast<double>() ?? [0.0, 0.0];
  List<String> get notes => (sparkGap['notes'] as List?)?.cast<String>() ?? [];
} 