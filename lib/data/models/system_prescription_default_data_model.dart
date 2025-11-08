class SystemPrescriptionDefaultDataModel {
  final double? viscosity;
  final double? volume;
  final double? price;
  final double? concentration;

  SystemPrescriptionDefaultDataModel({
    this.viscosity,
    this.volume,
    this.price,
    this.concentration,
  });

  factory SystemPrescriptionDefaultDataModel.fromMap(Map<String, dynamic> map) {
    return SystemPrescriptionDefaultDataModel(
      viscosity: map['viscosity']?.toDouble(),
      volume: map['volume']?.toDouble(),
      price: map['price']?.toDouble(),
      concentration: map['concentration']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'viscosity': viscosity,
      'volume': volume,
      'price': price,
      'concentration': concentration,
    };
  }
}
