import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/recommend.dart';
import 'package:app/core/services/lookbook.dart';
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
    init = false;
  }

  Future initialize() async {
    setBusy(true);
    await collectionService.initalize();
    init = true;
    setBusy(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
