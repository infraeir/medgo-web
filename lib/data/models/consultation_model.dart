import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/models/child_birth_data_model.dart';
import 'package:medgo/data/models/discharge_model.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/food_data_model.dart';
import 'package:medgo/data/models/physical_exam_model.dart';
import 'package:medgo/data/models/pregnancy_model.dart';
import 'package:medgo/data/models/prenatal_model.dart';
import 'package:medgo/data/models/serologies_model.dart';
import 'package:medgo/data/models/vaccines_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

class ConsultationModel {
  String? id;
  String? status;
  String? createdAt;
  DoctorModel? doctor;
  PatientsModel? patient;
  List<ResponseForm>? forms;
  List<CompanionModel> companions;

  ConsultationModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.patient,
    required this.doctor,
    required this.forms,
    // required this.data,
    required this.companions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt,
      'patient': patient?.toJson(),
      // 'data': data?.toJson(),
      'forms': forms?.map((form) => form.toJson()).toList(),
      'companions': companions.map((companion) => companion.toJson()).toList(),
    };
  }

  factory ConsultationModel.fromMap({required Map<String, dynamic> map}) {
    return ConsultationModel(
      id: map['id'],
      status: map['status'] ?? 'N/A',
      createdAt: map['createdAt'] ?? 'N/A',
      patient: PatientsModel.fromMap(map: map['patient']),
      doctor: map['doctor'] != null
          ? DoctorModel.fromMap(map: map['doctor'])
          : null,
      companions: map['companions'] != null
          ? map['companions']
              .map<CompanionModel>(
                (item) => CompanionModel.fromMap(map: item),
              )
              .toList()
          : [],
      forms: map['forms'] != null
          ? map['forms']
              .map<ResponseForm>(
                (item) => ResponseForm.fromJson(item),
              )
              .toList()
          : [],
      // data: ChildCareDataModel.fromMap(map['data'] ?? {}),
    );
  }
}

class ChildCareDataModel {
  PregnancyModel? pregnancyData;
  PrenatalModel? prenatalData;
  ChildBirthDataModel? childbirthData;
  DischargeModel? dischargeData;
  FoodDataModel? foodData;
  PhysicalExamModel? physicalExamData;

  ChildCareDataModel({
    this.pregnancyData,
    this.prenatalData,
    this.childbirthData,
    this.dischargeData,
    this.foodData,
    this.physicalExamData,
  });

  Map<String, dynamic> toJson() {
    return {
      'pregnancyData': pregnancyData?.toJson(),
      'prenatalData': prenatalData?.toJson(),
      'childbirthData': childbirthData?.toJson(),
      'dischargeData': dischargeData?.toJson(),
      'foodData': foodData?.toJson(),
      'physicalExamData': physicalExamData?.toJson(),
    };
  }

  factory ChildCareDataModel.fromMap(Map<String, dynamic> map) {
    return ChildCareDataModel(
      pregnancyData: map['pregnancyData'] != null
          ? PregnancyModel.fromMap(map: map['pregnancyData'])
          : PregnancyModel(
              pregnancyType: null,
              totalTwins: 0,
              riskPregnancyDetail: null,
              prenatalCareCompleted: null,
              plannedPregnancy: null,
              riskPregnancy: null,
            ),
      prenatalData: map['prenatalData'] != null
          ? PrenatalModel.fromMap(map: map['prenatalData'])
          : PrenatalModel(
              firstConsultationQuarter: null,
              numberOfConsultations: 2,
              ironSupplementationDone: null,
              vaccines: VacinnesModel(
                dPta: null,
                influenza: null,
                hepatitisB: null,
                covid19: null,
              ),
              serologies: SerologiesModel(
                syphilis: QuadroModel(
                  q1: null,
                  q2: null,
                  q3: null,
                ),
                toxoplasmosis: QuadroModel(
                  q1: null,
                  q2: null,
                  q3: null,
                ),
                viralHepatitis: QuadroModel(
                  q1: null,
                  q2: null,
                  q3: null,
                ),
                zika: QuadroModel(
                  q1: null,
                  q2: null,
                  q3: null,
                ),
              ),
            ),
      childbirthData: map['childbirthData'] != null
          ? ChildBirthDataModel.fromMap(map: map['childbirthData'])
          : ChildBirthDataModel(
              birthplace: null,
              birthplaceName: null,
              childbirthType: null,
              reasonForCesarean: null,
              hadBirthCompanion: null,
              skinToSkinContact: null,
              breastfedInFirstHour: null,
              timelyUmbilicalCordClamping: null,
              neonatalHospitalization: null,
              apgar: ApgarModel(
                firstMinute: null,
                fifthMinute: null,
              ),
              birthBodyData: BirthBodyDataModel(
                headCircumference: null,
                length: null,
                weight: null,
              ),
              gestationalAge: GestationalAgeModel(
                inDays: null,
                inWeeks: null,
                method: null,
                examDescription: null,
              ),
            ),
      dischargeData: map['dischargeData'] != null
          ? DischargeModel.fromMap(map: map['dischargeData'])
          : DischargeModel(
              cephalicPerimeter: null,
              date: null,
              length: null,
              weight: null,
            ),
      foodData: map['foodData'] != null
          ? FoodDataModel.fromMap(map: map['foodData'])
          : FoodDataModel(
              approximateWeaningDate: null,
              difficultyBreastfeeding: null,
              foodType: null,
              maternalIronSupplementation: null,
              reasonForDifficultyBreastfeeding: null,
              reasonForEarlyWeaning: null,
              stoppedBreastfeeding: null,
              stoppedBreastfeedingAge: null,
            ),
      physicalExamData: map['physicalExamData'] != null
          ? PhysicalExamModel.fromMap(map: map['physicalExamData'])
          : PhysicalExamModel(
              headCircumference: null,
              heartFrequency: null,
              length: null,
              respiratoryFrequency: null,
              weight: null,
            ),
    );
  }
}
