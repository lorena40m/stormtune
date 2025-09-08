class WeatherData {
  final double temperatureC;
  final double? humidityPct;
  final double? pressureHpa;
  final double? iatC;
  final double? cltC;
  final String? location;
  final DateTime timestamp;

  WeatherData({
    required this.temperatureC,
    this.humidityPct,
    this.pressureHpa,
    this.iatC,
    this.cltC,
    this.location,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'temp_c': temperatureC,
      'humidity_pct': humidityPct,
      'baro_hpa': pressureHpa,
      'iat_c': iatC,
      'clt_c': cltC,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperatureC: json['temp_c']?.toDouble() ?? 0.0,
      humidityPct: json['humidity_pct']?.toDouble(),
      pressureHpa: json['baro_hpa']?.toDouble(),
      iatC: json['iat_c']?.toDouble(),
      cltC: json['clt_c']?.toDouble(),
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  WeatherData copyWith({
    double? temperatureC,
    double? humidityPct,
    double? pressureHpa,
    double? iatC,
    double? cltC,
    String? location,
    DateTime? timestamp,
  }) {
    return WeatherData(
      temperatureC: temperatureC ?? this.temperatureC,
      humidityPct: humidityPct ?? this.humidityPct,
      pressureHpa: pressureHpa ?? this.pressureHpa,
      iatC: iatC ?? this.iatC,
      cltC: cltC ?? this.cltC,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
    );
  }
} 