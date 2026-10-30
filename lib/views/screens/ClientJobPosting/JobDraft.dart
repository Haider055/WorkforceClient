import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/SelectServiceController.dart';
import 'package:workforceclientapp/Models/CheckBoxQuestion.dart';
import 'package:workforceclientapp/Models/QuestionOption.dart';
import 'package:workforceclientapp/Models/RadioQuestion.dart';
import 'package:workforceclientapp/Models/TextQuestion.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/CheckBoxQuestionsScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobTitleScreen.dart';

/// Where CheckBoxQuestionsScreen should open on a resume, plus the
/// sub-question bookkeeping it would have built up had the user tapped
/// through the answers themselves.
typedef QuestionsResume = ({
  int index,
  Map<String, List<int>> radioSubQues,
  Map<String, List<int>> checkBoxSubQues,
});

/// A half-finished job posting, saved between app launches.
class JobDraft {
  final int serviceId;
  final String serviceName;

  /// questionId -> answer. A radio holds an option id, a checkbox a List of
  /// option ids, a text question a String.
  final Map<String, dynamic> answers;

  final String title;
  final String description;
  final List<String> imagePaths;

  final String address;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final String lat;
  final String lng;

  /// The step the user had reached (Constants.currentJobPostingStep).
  final int step;
  final int totalSteps;
  final int savedAtMillis;

  const JobDraft({
    required this.serviceId,
    required this.serviceName,
    required this.answers,
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.lat,
    required this.lng,
    required this.step,
    required this.totalSteps,
    required this.savedAtMillis,
  });

  DateTime get savedAt => DateTime.fromMillisecondsSinceEpoch(savedAtMillis);

  /// Something worth resuming — a service was chosen and at least one step
  /// was completed.
  bool get isResumable => serviceId > 0 && step >= 1;

  Map<String, dynamic> toJson() => {
        'serviceId': serviceId,
        'serviceName': serviceName,
        'answers': answers,
        'title': title,
        'description': description,
        'imagePaths': imagePaths,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
        'lat': lat,
        'lng': lng,
        'step': step,
        'totalSteps': totalSteps,
        'savedAtMillis': savedAtMillis,
      };

  factory JobDraft.fromJson(Map<String, dynamic> json) => JobDraft(
        serviceId: (json['serviceId'] ?? -1) as int,
        serviceName: (json['serviceName'] ?? "").toString(),
        answers: Map<String, dynamic>.from(json['answers'] ?? {}),
        title: (json['title'] ?? "").toString(),
        description: (json['description'] ?? "").toString(),
        imagePaths: List<String>.from(json['imagePaths'] ?? const []),
        address: (json['address'] ?? "").toString(),
        city: (json['city'] ?? "").toString(),
        state: (json['state'] ?? "").toString(),
        country: (json['country'] ?? "").toString(),
        postcode: (json['postcode'] ?? "").toString(),
        lat: (json['lat'] ?? "").toString(),
        lng: (json['lng'] ?? "").toString(),
        step: (json['step'] ?? 1) as int,
        totalSteps: (json['totalSteps'] ?? 4) as int,
        savedAtMillis: (json['savedAtMillis'] ?? 0) as int,
      );
}

class JobDraftService {
  static const String _key = 'job_posting_draft';
  static const String _imageDir = 'job_draft_images';

  static const Duration maxAge = Duration(days: 7);

  static final Rxn<JobDraft> current = Rxn<JobDraft>();

  static Future<void> save({
    required int step,
    Map<String, dynamic>? answers,
  }) async {
    try {
      if (Constants.selectedServiceId <= 0) return;

      final draft = JobDraft(
        serviceId: Constants.selectedServiceId,
        serviceName: Constants.selectedServiceName,
        answers: answers ?? answersFrom(Constants.questionsList),
        title: Constants.jobTitle,
        description: Constants.jobDescription,
        imagePaths: await _persistImages(Constants.selectedImages),
        address: Constants.jobPostingAddress,
        city: Constants.jobPostingCity,
        state: Constants.jobPostingState,
        country: Constants.jobPostingCountry,
        postcode: Constants.jobPostingPostcode,
        lat: Constants.jobPostingLat,
        lng: Constants.jobPostingLng,
        step: step,
        totalSteps: Constants.jobPostingSteps,
        savedAtMillis: DateTime.now().millisecondsSinceEpoch,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(draft.toJson()));
      current.value = draft;
    } catch (e) {
      debugPrint('JobDraftService.save failed: $e');
    }
  }

  /// questionId -> answer for every answered question in [questions].
  static Map<String, dynamic> answersFrom(
      List<Map<String, dynamic>> questions) {
    final answers = <String, dynamic>{};
    for (final question in questions) {
      final entry = question.entries.first;
      if (entry.key == "checkbox") {
        CheckBoxQuestion ques = entry.value;
        if (ques.selectedOptionsIds.isNotEmpty) {
          answers[ques.id.toString()] = List<int>.from(ques.selectedOptionsIds);
        }
      } else if (entry.key == "radio") {
        RadioQuestion ques = entry.value;
        if ((ques.selectedOptionId ?? 0) != 0) {
          answers[ques.id.toString()] = ques.selectedOptionId;
        }
      } else {
        TextQuestion ques = entry.value;
        if (ques.answer.isNotEmpty) {
          answers[ques.id.toString()] = ques.answer;
        }
      }
    }
    return answers;
  }

  // ----------------------------------------------------------- load

  static Future<JobDraft?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return null;

      final draft = JobDraft.fromJson(jsonDecode(raw));
      if (!draft.isResumable) return null;

      if (DateTime.now().difference(draft.savedAt) > maxAge) {
        await clear();
        return null;
      }
      current.value = draft;
      return draft;
    } catch (e) {
      debugPrint('JobDraftService.load failed: $e');
      return null;
    }
  }

  // ---------------------------------------------------------- clear

  static Future<void> clear() async {
    current.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);

      // Drop the copied images too, or they accumulate forever.
      final dir = await _draftImageDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('JobDraftService.clear failed: $e');
    }
  }

  // --------------------------------------------------------- images

  static Future<Directory> _draftImageDir() async {
    final docs = await path_provider.getApplicationDocumentsDirectory();
    return Directory(p.join(docs.path, _imageDir));
  }

  /// image_picker and the compressor write into the TEMP directory, which
  /// both platforms are free to wipe between launches. Copy into documents
  /// so the draft's photos actually survive.
  static Future<List<String>> _persistImages(List<File> images) async {
    if (images.isEmpty) return const [];

    try {
      final dir = await _draftImageDir();
      if (!await dir.exists()) await dir.create(recursive: true);

      final saved = <String>[];
      for (var i = 0; i < images.length; i++) {
        final source = images[i];
        if (!await source.exists()) continue;

        // Already in our folder from an earlier save — keep it as is.
        if (p.isWithin(dir.path, source.path)) {
          saved.add(source.path);
          continue;
        }

        final target = p.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}_$i${p.extension(source.path)}',
        );
        final copy = await source.copy(target);
        saved.add(copy.path);
      }
      return saved;
    } catch (e) {
      debugPrint('JobDraftService._persistImages failed: $e');
      return const [];
    }
  }

  /// Files that still exist on disk. A path can go stale if the user
  /// cleared app storage, so never trust the list blindly.
  static Future<List<File>> restoreImages(List<String> paths) async {
    final files = <File>[];
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) files.add(file);
    }
    return files;
  }

  // -------------------------------------------------- back into Constants

  /// Puts a draft back into the static fields the posting flow reads.
  /// Does NOT restore answers — those need the questions re-fetched first.
  static Future<void> applyToConstants(JobDraft draft) async {
    Constants.selectedServiceId = draft.serviceId;
    Constants.selectedServiceName = draft.serviceName;

    Constants.jobTitle = draft.title;
    Constants.jobDescription = draft.description;

    Constants.jobPostingAddress = draft.address;
    Constants.jobPostingCity = draft.city;
    Constants.jobPostingState = draft.state;
    Constants.jobPostingCountry = draft.country;
    Constants.jobPostingPostcode = draft.postcode;
    Constants.jobPostingLat = draft.lat;
    Constants.jobPostingLng = draft.lng;

    Constants.selectedImages
      ..clear()
      ..addAll(await restoreImages(draft.imagePaths));

    Constants.jobPostingSteps = draft.totalSteps;
    Constants.currentJobPostingStep.value = draft.step;
  }

  // ------------------------------------------------- answers back in

  /// Puts saved answers back onto freshly fetched [questions]. Mirrors the
  /// option taps in CheckBoxQuestionsScreen: a chosen option inserts its
  /// child questions straight after its own question (and bumps
  /// Constants.jobPostingSteps), so walk the list as it grows.
  static ({
    Map<String, List<int>> radioSubQues,
    Map<String, List<int>> checkBoxSubQues,
  }) _restoreAnswers(
      List<Map<String, dynamic>> questions, Map<String, dynamic> answers) {
    final radioSubQues = <String, List<int>>{};
    final checkBoxSubQues = <String, List<int>>{};

    for (var i = 0; i < questions.length; i++) {
      final entry = questions[i].entries.first;
      if (entry.key == "checkbox") {
        CheckBoxQuestion ques = entry.value;
        final saved = answers[ques.id.toString()];
        if (saved is! List) continue;
        for (final optionId in saved) {
          final option = _optionById(ques.options, optionId);
          if (option == null || option.selected) continue;
          option.selected = true;
          ques.selectedOptions.add(option.optionText ?? "");
          ques.selectedOptionsIds.add(option.id!);
          checkBoxSubQues[option.id.toString()] =
              _insertChildQuestions(questions, i, option);
        }
      } else if (entry.key == "radio") {
        RadioQuestion ques = entry.value;
        final option = _optionById(ques.options, answers[ques.id.toString()]);
        if (option == null) continue;
        ques.selectedOption = option.optionText ?? "";
        ques.selectedOptionId = option.id;
        radioSubQues[ques.id.toString()] =
            _insertChildQuestions(questions, i, option);
      } else {
        TextQuestion ques = entry.value;
        final saved = answers[ques.id.toString()];
        if (saved is! String) continue;
        ques.answer = saved;
        ques.editField.value.text = saved;
      }
    }
    return (radioSubQues: radioSubQues, checkBoxSubQues: checkBoxSubQues);
  }

  static QuestionOption? _optionById(List<QuestionOption>? options, id) {
    for (final option in options ?? const <QuestionOption>[]) {
      if (option.id == id) return option;
    }
    return null;
  }

  static List<int> _insertChildQuestions(
      List<Map<String, dynamic>> questions, int at, QuestionOption option) {
    final indices = <int>[];
    for (var j = 0; j < option.questionsList.length; j++) {
      Constants.jobPostingSteps++;
      indices.add(at + j + 1);
      questions.insert(at + j + 1, option.questionsList.elementAt(j));
    }
    return indices;
  }

  // --------------------------------------------------------- resume

  static QuestionsResume? _pendingResume;
  static bool _busy = false;

  /// Read once by CheckBoxQuestionsScreen.initState; null on a fresh start.
  static QuestionsResume? takeResume() {
    final resume = _pendingResume;
    _pendingResume = null;
    return resume;
  }

  /// Re-opens the posting flow on the screen the user left, with every
  /// earlier screen underneath so Back still walks through them.
  static Future<void> resume(JobDraft draft) async {
    if (_busy) return;
    _busy = true;
    try {
      // Questions are fetched fresh — the same call a service tap makes —
      // and it pushes the title screen when it succeeds.
      Commons.showProgressDialog(Get.context!);
      await Get.find<SelectServiceController>()
          .pleaseGetAllServiceQuestions(draft.serviceId, draft.serviceName);
      Commons.hideProgressDialog();

      // Let the title route build so its binding has run.
      await Future.delayed(const Duration(milliseconds: 350));
      if (Get.currentRoute != AppLinks.job_title_screen) return;

      final baseSteps = Constants.jobPostingSteps;
      await applyToConstants(draft);
      Constants.jobPostingSteps = baseSteps;

      final questions = Constants.questionsList;
      final subQues = _restoreAnswers(questions, draft.answers);
      final count = questions.length;
      final step = draft.step.clamp(1, count + 4);
      Constants.currentJobPostingStep.value = step;

      if (Get.isRegistered<JobTitleController>()) {
        Get.find<JobTitleController>().titleTextField.value.text = draft.title;
      }

      // Step 1 is the title, then one step per question, then
      // description, photos and address.
      if (step < 2) return;
      if (count > 0) {
        _pendingResume = (
          index: (step - 2).clamp(0, count - 1),
          radioSubQues: subQues.radioSubQues,
          checkBoxSubQues: subQues.checkBoxSubQues,
        );
        Get.to(() => const CheckBoxQuestionsScreen());
      }
      if (step >= count + 2) {
        await Future.delayed(const Duration(milliseconds: 250));
        Get.toNamed(AppLinks.job_description_screen);
      }
      if (step >= count + 3) {
        await Future.delayed(const Duration(milliseconds: 250));
        Get.toNamed(AppLinks.upload_job_image_screen);
      }
      if (step >= count + 4) {
        await Future.delayed(const Duration(milliseconds: 250));
        Get.toNamed(AppLinks.pick_address_screen);
      }
    } catch (e) {
      Commons.hideProgressDialog();
      debugPrint('JobDraftService.resume failed: $e');
    } finally {
      _busy = false;
    }
  }

  /// Drops the draft and starts the same service again from the title.
  static Future<void> restart(JobDraft draft) async {
    if (_busy) return;
    _busy = true;
    try {
      await clear();
      Constants.selectedImages.clear();
      Commons.showProgressDialog(Get.context!);
      await Get.find<SelectServiceController>()
          .pleaseGetAllServiceQuestions(draft.serviceId, draft.serviceName);
      Commons.hideProgressDialog();
    } catch (e) {
      Commons.hideProgressDialog();
      debugPrint('JobDraftService.restart failed: $e');
    } finally {
      _busy = false;
    }
  }
}
