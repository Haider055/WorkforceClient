import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Models/CheckBoxQuestion.dart';
import 'package:workforceclientapp/Models/QuestionOption.dart';
import 'package:workforceclientapp/Models/RadioQuestion.dart';
import 'package:workforceclientapp/Models/TextQuestion.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class CheckBoxQuestionsScreen extends StatefulWidget {
  const CheckBoxQuestionsScreen({super.key});

  @override
  State<CheckBoxQuestionsScreen> createState() =>
      _CheckBoxQuestionsScreenState();
}

class _CheckBoxQuestionsScreenState extends State<CheckBoxQuestionsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool isLoading = true.obs();
  int selectedServiceId = -1;
  final data = Get.arguments;
  String header = "";
  late List<Map<String, dynamic>> questionsList = [];
  Map<String, List<int>> radioAddedSubQues = {};
  Map<String, List<int>> checkBoxAddedSubQues = {};

  void _nextPage() {
    if (questionsList.elementAt(_currentIndex).entries.first.key ==
        "checkbox") {
      CheckBoxQuestion ques =
          questionsList.elementAt(_currentIndex).values.first;
      if (ques.isRequired! == 1 && ques.selectedOptions.isEmpty) {
        Fluttertoast.showToast(
            msg: Strings.thisQuestionIsCompulsToAns(Get.context!));
        return;
      }
    } else if (questionsList.elementAt(_currentIndex).entries.first.key ==
        "radio") {
      RadioQuestion radioQuestion =
          questionsList.elementAt(_currentIndex).values.first;
      if (radioQuestion.isRequired! == 1 &&
          radioQuestion.selectedOption!.isEmpty) {
        Fluttertoast.showToast(
            msg: Strings.thisQuestionIsCompulsToAns(Get.context!));
        return;
      }
    } else {
      TextQuestion question =
          questionsList.elementAt(_currentIndex).values.first;
      if (question.isRequired! == 1 && question.answer.isEmpty) {
        Fluttertoast.showToast(
            msg: Strings.thisQuestionIsCompulsToAns(Get.context!));
        return;
      }
    }
    //
    if (_currentIndex < questionsList.length - 1) {
      FocusScope.of(context).unfocus();
      Constants.currentJobPostingStep++;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Constants.questionsList = questionsList;
      Constants.currentJobPostingStep++;
      Get.toNamed(AppLinks.job_description_screen);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      Constants.currentJobPostingStep--;
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      FocusScope.of(context).unfocus();
    } else {
      Constants.currentJobPostingStep--;
      Get.offNamed(AppLinks.job_title_screen);
    }
  }

  @override
  void initState() {
    super.initState();
    header = Constants.selectedServiceName;
    questionsList = Constants.questionsList;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          if (FocusScope.of(Get.context!).hasFocus) {
            FocusScope.of(Get.context!).unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width,
            leading: Card(
              color: const Color(MyColors.appbackgroundColor),
              shadowColor: const Color.fromARGB(158, 219, 219, 219),
              elevation: 2,
              shape: const Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(147, 203, 203, 203),
                      style: BorderStyle.solid)),
              child: Center(
                child: Stack(
                  children: [
                    Center(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: Text(Constants.selectedServiceName,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins')),
                    )),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0.w, vertical: 0),
                        child: LinearProgressBar(
                          maxSteps: Constants.jobPostingSteps,
                          progressType: LinearProgressBar.progressTypeLinear,
                          minHeight: 6,
                          currentStep: Constants.currentJobPostingStep,
                          progressColor: const Color(MyColors.themeRedColor),
                          backgroundColor:
                              const Color(MyColors.lightSilverColor),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.0.h, right: 15.0.w),
                          child: Text(
                            "${Strings.skipText(Get.context!)} ${Constants.currentJobPostingStep}/${Constants.jobPostingSteps}",
                            style: TextStyle(
                                fontSize: 14.5.sp,
                                color: const Color(MyColors.midGrayColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: questionsList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: Column(
                          children: [
                            questionsList.elementAt(index).entries.first.key ==
                                    "checkbox"
                                ? _buildCheckboxQuestion(
                                    questionsList
                                        .elementAt(index)
                                        .entries
                                        .first
                                        .value,
                                    context)
                                : questionsList
                                            .elementAt(index)
                                            .entries
                                            .first
                                            .key ==
                                        "radio"
                                    ? _buildMCQQuestion(
                                        questionsList
                                            .elementAt(index)
                                            .entries
                                            .first
                                            .value,
                                        context)
                                    : _buildTextQuestion(
                                        questionsList
                                            .elementAt(index)
                                            .entries
                                            .first
                                            .value,
                                        context),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 25.0.w, right: 12.0.w),
                            child: FullWidthOutlineButton(
                                text: Strings.back(context),
                                fontsize: 15.0.sp,
                                color: MyColors.themeRedColor,
                                onPressed: () {
                                  _previousPage();
                                }),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 12.0.w, right: 25.0.w),
                            child: FullWidthButtonPrimary(
                                text: Strings.next(context),
                                fontsize: 15.0.sp,
                                color: MyColors.themeRedColor,
                                onPressed: () {
                                  _nextPage();
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxQuestion(
      CheckBoxQuestion question, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.h, left: 12.0.w, right: 12.0.w),
            child: HeadingTextW500(
                text: question.question!, centerAlign: false, size: 20.0.sp),
          ),
          SizedBox(height: 12.0.h),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
              child: Headingdescription(
                  text:
                      question.description == null ? "" : question.description!,
                  centerAlign: false,
                  size: 16.0.sp),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1,
                ),
                itemCount: question.options?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildCheckboxOption(
                      question.options!.elementAt(index), question);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
      QuestionOption option, CheckBoxQuestion question) {
    bool selectAnswer = option.selected;
    return Padding(
      padding: EdgeInsets.all(5.0.r),
      child: GestureDetector(
        onTap: () {
          setState(() {
            option.selected = !option.selected;
            if (question.selectedOptions.contains(option.optionText)) {
              question.selectedOptions.remove(option.optionText);
              question.selectedOptionsIds.remove(option.id);
            } else {
              question.selectedOptions.add(option.optionText!);
              question.selectedOptionsIds.add(option.id!);
            }

            if (option.selected) {
              List<int> newIndices = [];
              List<Map<String, dynamic>> qList = option.questionsList;
              for (var i = 0; i < qList.length; i++) {
                int insertIndex = _currentIndex + (i + 1);
                Constants.jobPostingSteps++;
                newIndices.add(insertIndex);
                questionsList.insert(
                    _currentIndex + (i + 1), qList.elementAt(i));
              }

              checkBoxAddedSubQues[option.id.toString()] = newIndices;
            } else {
              if (checkBoxAddedSubQues.containsKey(option.id.toString())) {
                List<int> indicesToRemove =
                    checkBoxAddedSubQues[option.id.toString()]!
                      ..sort((a, b) => b.compareTo(a));
                for (var index in indicesToRemove) {
                  if (index >= 0 && index < questionsList.length) {
                    questionsList.removeAt(index);
                    Constants.jobPostingSteps--;
                  }
                }

                checkBoxAddedSubQues.remove(option.id.toString());
              }
            }
          });
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            side: const BorderSide(
              color: Color(MyColors.silverColor),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    option.icon != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(option.icon!, scale: 50.0.r),
                          )
                        : const Center(),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 4.0.w, right: 4.0.w, bottom: 5.0.h, top: 5.0.h),
                      child: option.optionText != null
                          ? Headingdescription(
                              text: option.optionText!,
                              centerAlign: true,
                              size: 13.5.sp)
                          : const Text("N/A"),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Checkbox(
                  side: BorderSide(
                    width: 2.0.w,
                  ),
                  value: selectAnswer,
                  onChanged: (bool? value) {
                    setState(() {
                      option.selected = value!;
                      if (question.selectedOptions
                          .contains(option.optionText)) {
                        question.selectedOptions.remove(option.optionText);
                        question.selectedOptionsIds.remove(option.id);
                      } else {
                        question.selectedOptions.add(option.optionText!);
                        question.selectedOptionsIds.add(option.id!);
                      }

                      if (value) {
                        List<Map<String, dynamic>> qList = option.questionsList;
                        List<int> newIndices = [];
                        for (var i = 0; i < qList.length; i++) {
                          int insertIndex = _currentIndex + (i + 1);
                          Constants.jobPostingSteps++;
                          newIndices.add(insertIndex);
                          questionsList.insert(
                              _currentIndex + (i + 1), qList.elementAt(i));
                        }
                        checkBoxAddedSubQues[question.id.toString()] =
                            newIndices;
                      } else {
                        if (checkBoxAddedSubQues
                            .containsKey(question.id.toString())) {
                          List<int> indicesToRemove =
                              checkBoxAddedSubQues[question.id.toString()]!
                                ..sort((a, b) => b.compareTo(a));
                          for (var index in indicesToRemove) {
                            if (index >= 0 && index < questionsList.length) {
                              questionsList.removeAt(index);
                              Constants.jobPostingSteps--;
                            }
                          }

                          checkBoxAddedSubQues.remove(question.id.toString());
                        }
                      }
                    });
                  },
                  activeColor: const Color(MyColors.themeRedColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMCQOptions(QuestionOption option, RadioQuestion question) {
    String selectAnswer = question.selectedOption.toString();
    return GestureDetector(
      onTap: () {
        setState(() {
          selectAnswer = option.optionText!;
          question.selectedOption = option.optionText!;
          question.selectedOptionId = option.id!;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
        child: Card(
          elevation: 0,
          color: selectAnswer == option.optionText
              ? Colors.red.shade50
              : const Color(MyColors.whiteColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(
              color: selectAnswer == option.optionText
                  ? const Color(MyColors.themeRedColor)
                  : const Color(MyColors.silverColor),
            ),
          ),
          child: RadioListTile(
            title: Text(option.optionText!),
            value: option.optionText,
            groupValue: selectAnswer,
            activeColor: const Color(MyColors.themeRedColor),
            onChanged: (value) {
              setState(() {
                selectAnswer = value!;
                question.selectedOption = option.optionText!;
                question.selectedOptionId = option.id!;

                if (radioAddedSubQues.containsKey(question.id.toString())) {
                  List<int> indicesToRemove =
                      radioAddedSubQues[question.id.toString()]!
                        ..sort((a, b) => b.compareTo(a));
                  for (var index in indicesToRemove) {
                    if (index >= 0 && index < questionsList.length) {
                      questionsList.removeAt(index);
                      Constants.jobPostingSteps--;
                    }
                  }

                  radioAddedSubQues.remove(question.id.toString());
                }

                List<Map<String, dynamic>> qList = option.questionsList;
                List<int> newIndices = [];
                for (var i = 0; i < qList.length; i++) {
                  int insertIndex = _currentIndex + (i + 1);
                  Constants.jobPostingSteps++;
                  newIndices.add(insertIndex);
                  questionsList.insert(
                      _currentIndex + (i + 1), qList.elementAt(i));
                }
                radioAddedSubQues[question.id.toString()] = newIndices;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMCQQuestion(RadioQuestion question, BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: const Color(MyColors.cardGrayColor50),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Title
              Padding(
                padding: EdgeInsets.only(top: 12.0.h, left: 20.0.w),
                child: HeadingTextW500(
                  text: question.question ?? '',
                  centerAlign: false,
                  size: 20.0.sp,
                ),
              ),
              // Question Description
              Padding(
                padding: EdgeInsets.only(left: 20.0.w, top: 15.0.h),
                child: Headingdescription(
                  text: question.description ?? '',
                  centerAlign: false,
                  size: 16.0.sp,
                ),
              ),
              SizedBox(height: 20.h),
              // Options list - scrolls only if needed
              Expanded(
                child: ListView.builder(
                  itemCount: question.options?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _buildMCQOptions(
                      question.options![index],
                      question,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextQuestion(TextQuestion question, BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(MyColors.cardGrayColor50),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 12.0.h, left: 20.0.w, right: 20.0.w),
              child: HeadingTextW500(
                  text: question.question!, centerAlign: false, size: 20.0.sp),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20.0.w, top: 15.0.h, right: 20.0.w),
              child: Headingdescription(
                  text:
                      question.description == null ? "" : question.description!,
                  centerAlign: false,
                  size: 16.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0.w),
            child: TextField(
              controller: TextEditingController(text: question.answer),
              onChanged: (value) {
                question.answer = value;
              },
              cursorColor: const Color(MyColors.themeRedColor),
              decoration: InputDecoration(
                  fillColor: const Color(MyColors.whiteColor),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0.r),
                      borderSide: const BorderSide(
                          color: Color(MyColors.themeRedColor))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0.r),
                      borderSide: const BorderSide(
                          color: Color(MyColors.themeRedColor)))),
            ),
          )
        ],
      ),
    );
  }
}
