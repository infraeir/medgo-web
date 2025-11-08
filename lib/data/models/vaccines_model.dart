class VacinnesModel {
  final bool? dPta;
  final bool? influenza;
  final bool? hepatitisB;
  final bool? covid19;

  VacinnesModel({
    required this.dPta,
    required this.influenza,
    required this.hepatitisB,
    required this.covid19,
  });

  factory VacinnesModel.fromMap({required Map<String, dynamic> map}) {
    return VacinnesModel(
      dPta: map['dPta'] ?? false,
      influenza: map['influenza'] ?? false,
      hepatitisB: map['hepatitisB'] ?? false,
      covid19: map['covid19'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dPta': dPta,
      'influenza': influenza,
      'hepatitisB': hepatitisB,
      'covid19': covid19,
    };
  }

}
