import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mwb_connect_app/service_locator.dart';
import 'package:mwb_connect_app/core/services/api_service.dart';
import 'package:mwb_connect_app/core/models/step_model.dart';
import 'package:mwb_connect_app/core/models/skill_model.dart';
import 'package:mwb_connect_app/core/models/lesson_request_model.dart';
import 'package:mwb_connect_app/core/models/lesson_model.dart';
import 'package:mwb_connect_app/core/models/user_model.dart';

class ConnectWithMentorService {
  final ApiService _api = locator<ApiService>();

  Future<StepModel> getLastStepAdded() async {
    http.Response response = await _api.getHTTP(url: '/last_step_added');
    StepModel step;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      step = StepModel.fromJson(json);
    }
    return step;
  }

  Future<LessonRequestModel> getLessonRequest() async {
    http.Response response = await _api.getHTTP(url: '/lesson_request');
    LessonRequestModel lessonRequest;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      lessonRequest = LessonRequestModel.fromJson(json);
    }
    return lessonRequest;
  }

  Future<LessonRequestModel> sendLessonRequest() async {
    http.Response response = await _api.postHTTP(url: '/lesson_requests', data: {});
    LessonRequestModel lessonRequest;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      lessonRequest = LessonRequestModel.fromJson(json);
    }
    return lessonRequest;
  }  

  Future<void> cancelLessonRequest(String id) async {
    await _api.putHTTP(url: '/lesson_requests/$id/cancel_lesson_request', data: {});  
    return ;
  }  
  
  Future<Lesson> getNextLesson() async {
    http.Response response = await _api.getHTTP(url: '/next_lesson');
    Lesson nextLesson;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      nextLesson = Lesson.fromJson(json);
    }
    return nextLesson;
  }   

  Future<void> cancelNextLesson(Lesson lesson, bool isSingleLesson) async {
    dynamic data = {};
    Lesson lessonData = Lesson(mentor: User(id: lesson.mentor.id));
    if (isSingleLesson && lesson.isRecurrent) {
      lessonData.dateTime = lesson.dateTime;
    }
    data = lessonData.toJson();
    String id = lesson.id;    
    await _api.putHTTP(url: '/lessons/$id/cancel_lesson', data: data);  
    return ;
  }

  Future<Lesson> getPreviousLesson() async {
    http.Response response = await _api.getHTTP(url: '/previous_lesson');
    Lesson previousLesson;
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      previousLesson = Lesson.fromJson(json);
    }
    return previousLesson;
  }   

  Future<List<Skill>> getMentorSkills(String mentorId, String subfieldId) async {
    http.Response response = await _api.getHTTP(url: '/users/$mentorId/subfields/$subfieldId/skills');
    List<Skill> skills = [];
    if (response != null && response.body != null) {
      var json = jsonDecode(response.body);
      skills = List<Skill>.from(json.map((model) => Skill.fromJson(model)));      
    }
    return skills;
  }

  Future<void> addSkills(List<String> skillIds, String subfieldId) async {
    await _api.postHTTP(url: '/user/subfields/$subfieldId/skills', data: skillIds);  
    return ;
  }  
  
  Future<void> setMentorPresence(String id, bool isPresent) async {
    Lesson lesson = Lesson(isMentorPresent: isPresent);
    await _api.putHTTP(url: '/lessons/$id/mentor_presence', data: lesson.toJson());  
    return ;
  }
}