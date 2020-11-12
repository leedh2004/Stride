import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/recommend.dart';
import 'package:app/core/viewmodels/base_model.dart';

class RecommendationModel extends BaseModel {
  RecommendationService collectionService;
  AuthenticationService authService;
  bool init;

  RecommendationModel(
      RecommendationService _service, AuthenticationService _authService) {
    print("RecommendationModel 생성!");
    collectionService = _service;
    authService = _authService;
    init = collectionService.init;
  }

  Future initialize() async {
    setBusy(true);
    await collectionService.initalize();
    init = true;
    // notifyListeners();
    setBusy(false);
  }
}
