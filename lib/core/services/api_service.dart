import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mwb_connect_app/service_locator.dart';
import 'package:mwb_connect_app/utils/constants.dart';
import 'package:mwb_connect_app/core/services/local_storage_service.dart';
import 'package:mwb_connect_app/core/models/tokens_model.dart';
import 'package:mwb_connect_app/core/models/user_model.dart';

class ApiService {
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final String baseUrl = 'http://104.131.124.125:3000/api/v1';
  
  Map<String, String> getHeaders() {
    String accessToken = _storageService.accessToken;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$accessToken',
    };
    return headers;    
  }

  Future<http.Response> getHTTP({String url}) async {
    final response = await http.get(
      Uri.parse(baseUrl + url), 
      headers: getHeaders()
    );
    if (_storageService.refreshToken == null) {
      _logout();
    } else if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 400) {
      await _refreshToken();
      return getHTTP(url: url);
    }
  }

  Future<http.Response> postHTTP({String url, dynamic data}) async {
    final response = await http.post(
      Uri.parse(baseUrl + url), 
      headers: getHeaders(),
      body: json.encode(data)
    );
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 400) {
      await _refreshToken();
      return await postHTTP(url: url, data: data);
    }   
  }

  Future<http.Response> putHTTP({String url, dynamic data}) async {
    final response = await http.put(
      Uri.parse(baseUrl + url), 
      headers: getHeaders(),
      body: json.encode(data)
    );
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 400) {
      await _refreshToken();
      return await putHTTP(url: url, data: data);
    }  
  }
  
  Future<http.Response> deleteHTTP({String url, dynamic data}) async {
    final response = await http.delete(
      Uri.parse(baseUrl + url), 
      headers: getHeaders(),
      body: json.encode(data)
    );
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 400) {
      await _refreshToken();
      return await deleteHTTP(url: url, data: data);
    }
  }

  Future<void> _refreshToken() async {
    String userId = _storageService.userId;
    String refreshToken = _storageService.refreshToken;
    final response = await http.get(
      Uri.parse(baseUrl + '/access_token?userId=$userId&refreshToken=$refreshToken'),
      headers: getHeaders()
    );
    var json = jsonDecode(response.body);    
    Tokens tokens = Tokens.fromJson(json);
    _storageService.accessToken = tokens.accessToken;
    _storageService.refreshToken = tokens.refreshToken;
  }
  
  Future<void> _logout() async {
    User user = User(id: _storageService.userId);
    resetStorage();
    await postHTTP(url: '/logout', data: user.toJson());
  }

  void resetStorage() {
    _storageService.userId = null;
    _storageService.userEmail = null;
    _storageService.userName = '';
    _storageService.isMentor = false;
    _storageService.quizNumber = 1;
    _storageService.notificationsEnabled = AppConstants.notificationsEnabled;
    _storageService.notificationsTime = AppConstants.notificationsTime;
  }    
}