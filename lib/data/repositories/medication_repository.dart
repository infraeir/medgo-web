import 'package:medgo/data/models/medications_pagination_model.dart';
import 'package:medgo/data/providers/medication_service.dart';

class MedicationRepository {
  final MedicationProvider provider;

  MedicationRepository({required this.provider});

  Future<MedicationsPaginationModel> getMedications({
    required int currentPage,
    String? search,
    List<String>? types,
    List<String>? tokens,
    bool? sus,
    bool? popularPharmacy,
  }) async {
    return await provider.getMedications(
      currentPage: currentPage,
      search: search,
      types: types,
      tokens: tokens,
      sus: sus,
      popularPharmacy: popularPharmacy,
    );
  }
}
