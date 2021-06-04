import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mwb_connect_app/service_locator.dart';
import 'package:mwb_connect_app/core/services/local_storage_service.dart';
import 'package:mwb_connect_app/core/services/api_service.dart';
import 'package:mwb_connect_app/core/models/step_model.dart';

class StepsService {
  final ApiService _api = locator<ApiService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();  

  Future<List<StepModel>> getSteps(String goalId) async {
    http.Response response = await _api.getHTTP(url: '/steps/$goalId');
    List<StepModel> steps = [];
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      steps = List<StepModel>.from(json.map((model) => StepModel.fromJson(model)));      
    }
    return steps;
  }

  Future<StepModel> getStepById(String goalId, String id) async {
    http.Response response = await _api.getHTTP(url: '/steps/$goalId/$id');
    StepModel step;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      step = StepModel.fromJson(json);
    }
    return step;
  }

  Future<StepModel> addStep(String goalId, StepModel step) async {
    String userId = _storageService.userId;
    http.Response response = await _api.postHTTP(url: '/steps/$userId/$goalId', data: step.toJson());  
    StepModel addedStep;
    if (response != null) {
      var json = jsonDecode(response.body);
      addedStep = StepModel.fromJson(json);
    }
    return addedStep;
  }  

  Future<void> updateStep(StepModel step, String id) async {
    await _api.putHTTP(url: '/steps/$id', data: step.toJson());  
    return ;
  }  

  Future<void> deleteStep(String id) async {
    await _api.deleteHTTP(url: '/steps/$id');
    return ;
  }  
}