class CarProfile {
  final String id;
  final String name;
  final String drive;
  final String induction;
  final String fuel;
  final String tire;
  final String weightClass;
  final String? ignitionStrength;
  final int launchRpm;
  final double? baseWgdcPct;
  final double? afrTargetWot;
  final double? tireHotPressurePsi;
  final double? boostPsi;
  final String? ecuBrand;
  final DateTime createdAt;

  CarProfile({
    required this.id,
    required this.name,
    required this.drive,
    required this.induction,
    required this.fuel,
    required this.tire,
    required this.weightClass,
    this.ignitionStrength,
    required this.launchRpm,
    this.baseWgdcPct,
    this.afrTargetWot,
    this.tireHotPressurePsi,
    this.boostPsi,
    this.ecuBrand,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'drive': drive,
      'induction': induction,
      'fuel': fuel,
      'tire': tire,
      'weight_class': weightClass,
      'ignition_strength': ignitionStrength,
      'launch_rpm': launchRpm,
      'base_wgdc_pct': baseWgdcPct,
      'afr_target_wot': afrTargetWot,
      'tire_hot_pressure_psi': tireHotPressurePsi,
      'boost_psi': boostPsi,
      'ecu_brand': ecuBrand,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CarProfile.fromJson(Map<String, dynamic> json) {
    return CarProfile(
      id: json['id'],
      name: json['name'],
      drive: json['drive'],
      induction: json['induction'],
      fuel: json['fuel'],
      tire: json['tire'],
      weightClass: json['weight_class'],
      ignitionStrength: json['ignition_strength'],
      launchRpm: json['launch_rpm'],
      baseWgdcPct: json['base_wgdc_pct']?.toDouble(),
      afrTargetWot: json['afr_target_wot']?.toDouble(),
      tireHotPressurePsi: json['tire_hot_pressure_psi']?.toDouble(),
      boostPsi: json['boost_psi']?.toDouble(),
      ecuBrand: json['ecu_brand'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  CarProfile copyWith({
    String? id,
    String? name,
    String? drive,
    String? induction,
    String? fuel,
    String? tire,
    String? weightClass,
    String? ignitionStrength,
    int? launchRpm,
    double? baseWgdcPct,
    double? afrTargetWot,
    double? tireHotPressurePsi,
    double? boostPsi,
    String? ecuBrand,
    DateTime? createdAt,
  }) {
    return CarProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      drive: drive ?? this.drive,
      induction: induction ?? this.induction,
      fuel: fuel ?? this.fuel,
      tire: tire ?? this.tire,
      weightClass: weightClass ?? this.weightClass,
      ignitionStrength: ignitionStrength ?? this.ignitionStrength,
      launchRpm: launchRpm ?? this.launchRpm,
      baseWgdcPct: baseWgdcPct ?? this.baseWgdcPct,
      afrTargetWot: afrTargetWot ?? this.afrTargetWot,
      tireHotPressurePsi: tireHotPressurePsi ?? this.tireHotPressurePsi,
      boostPsi: boostPsi ?? this.boostPsi,
      ecuBrand: ecuBrand ?? this.ecuBrand,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 