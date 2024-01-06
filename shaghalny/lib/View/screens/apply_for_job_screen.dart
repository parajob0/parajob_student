import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:shaghalny/Model/jobs_model/applied_job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/View/components/core/dialog.dart';
import 'package:shaghalny/View/screens/Alerts/delete_application.dart';
import 'package:shaghalny/View/screens/Alerts/to_apply_for_job.dart';
import 'package:shaghalny/View/screens/Alerts/to_complete_info.dart';
import 'package:shaghalny/View/screens/bank_information_screen.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';
import 'package:shaghalny/View/screens/education_scanner.dart';
import 'package:shaghalny/View/screens/education_screen.dart';
import 'package:shaghalny/View/screens/front_ID_scan_screen.dart';
import 'package:shaghalny/ViewModel/cubits/apply_for_job_cubit/apply_for_job_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/home_cubit/home_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import 'package:shaghalny/utils/page_route.dart';
import '../../color_const.dart';
import '../components/apply_for_job_screen/job_details.dart';
import '../components/apply_for_job_screen/job_header.dart';
import '../components/apply_for_job_screen/job_info.dart';
import '../components/core/bottom_sheet_item.dart';
import '../components/core/buttons.dart';
import 'bottom_navigation_screen.dart';
import 'pic_ID_screen.dart';
import 'submit_complaint_job.dart';
import 'submit_complaint_place.dart';
import 'submit_review.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyForJobScreen extends StatefulWidget {
  JobModel model;
  List<JobModel> compoundJobs = [];
  late JobModel currentJobModel;
  late int state;
  String lastJobId ="";
  ApplyForJobScreen({super.key, required this.model});

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  @override
  void initState() {
    super.initState();
    setCurrentJobModel();
  }

  void setCurrentJobModel() async{
    HomeCubit homeCubit = HomeCubit.get(context);
    PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
    JobsCubit jobCubit = JobsCubit.get(context);

    //0 approved
    //1 pending
    //2 declined
    //3 upComing
    //4 signContract
    //5 Completed

    // fill compound jobs
    if (homeCubit.newJobMap[widget.model.parentID] != null) {
      widget.compoundJobs = homeCubit.newJobMap[widget.model.parentID] ?? [];
    }
    //select current job
    if (widget.compoundJobs.isEmpty) {
      widget.compoundJobs.add(widget.model);
    }
    widget.lastJobId =  widget.compoundJobs.last.jobId;
    widget.compoundJobs.forEach((element) {
      print(element.jobId);
    });

    bool takeOne = false;
    // int countOfJobsDidNotAttend = 0;
    for (final element in widget.compoundJobs) {
      // bool isInJobHistory = preferenceCubit.userModel?.jobHistory?.containsKey(element.jobId) ?? false;

        if(element.endDate.toDate().isAfter(DateTime.now())) {
        widget.currentJobModel = element;
        takeOne = true;
        break;
      }
    }

    if (takeOne == false) {
      widget.currentJobModel = widget.compoundJobs.last;
      widget.state = 5;
    }

  }

  String formatTime(int hours) {
    if (hours == 0) {
      return '12 AM';
    } else if (hours < 12) {
      return '$hours AM';
    } else if (hours == 12) {
      return '12 PM';
    } else {
      return '${hours - 12} PM';
    }
  }

  int? jobTimeinSeconds;
  int? jobTimeinHours;

  Widget applyButton(JobsCubit jobCubit,PreferenceCubit preferenceCubit ,ApplyForJobCubit applyCubit, context) {
    // state , jobTitle , companyName ,image,
    // -1 -> not in applied jobs
    // check if parentID in model jobs
    widget.state = preferenceCubit.isInJobs(widget.currentJobModel.parentID);
    print("State is ${widget.state}");

    if (widget.state == -1) {
      // check data before apply for job;
      // then APPLY
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: PrimaryButton(
          onTap: () async {
            // check ID
            PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
            HomeCubit homeCubit = HomeCubit.get(context);
            String uid = preferenceCubit.userModel?.id ?? "";
            // TODO update uid string

            bool checkFrontId = await applyCubit.checkUserFrontId(uid);
            bool checkUniversityId = await applyCubit.checkUniversityId(uid);
            bool checkPicWithId = await applyCubit.checkPicWithId(uid);
            if (!checkFrontId) {
              // Navigate TO Scan ID Screen;

              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    screen: FrontIDScan(),
                  );
                },
              );
            } else if (!checkPicWithId) {
              // Navigate TO Scan Pic With ID Screen;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    screen: PIC_IDScan(),
                  );
                },
              );
            }

            // check university name
            else if (preferenceCubit.userModel?.university?.isEmpty == true) {
              // Navigate to university screen

              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    screen: EducationScreen(),
                  );
                },
              );
            }

            // check universityID
            else if (!checkUniversityId) {
              // Navigate TO Scan ID Screen;

              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    screen: EducationScanner(),
                  );
                },
              );
            }

            // check Bank account
            else if (preferenceCubit.userModel?.bankName?.isEmpty == true) {
              // Navigate to university screen
              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    screen: BankInformation(),
                  );
                },
              );
            }

            //check profile pic
            else if(preferenceCubit.userModel!.profilePic!.isEmpty){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertToCompleteInfo(
                    isProfilePic: true,
                    screen: BottomNavigation(index: 3),
                  );
                },
              );
            }

            else {
              customDialog(
                  context: context,
                  dialog: AlertToApplyJob(
                    jobModel: widget.currentJobModel,
                    jobCubit: jobCubit,
                    homeCubit: homeCubit,
                  ));
            }
          },
          text: "Apply for this job",
        ),
      );
    }
    else if (widget.state == 3) {
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: SecondaryButton(
          onTap: () {

            AppNavigator.customNavigator(
                context: context,
                screen: CheckInOut(
                  model: widget.currentJobModel, jobDurationInSeconds: jobTimeinSeconds!,jobDurationInHours: jobTimeinHours!,
                  lastJobId: widget.lastJobId ,
                ),
                finish: false);
          },
          text: "Go to QR Code page",
        ),
      );
    }
    else if (widget.state == 0 || widget.state == 1 || widget.state == 4) {
      //delete
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: SecondaryButton(
          onTap: () {
            // delete 0 , 1 , 3 , 4
            customDialog(
                context: context,
                dialog: AlertToDeleteApplication(
                    jobId: widget.currentJobModel.parentID,
                    jobsCubit: jobCubit));
          },
          text: "Delete your application",
          color: Color.fromRGBO(255, 77, 77, 1),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var jobCubit = JobsCubit.get(context);

    jobTimeinSeconds = int.parse(widget.currentJobModel.endDate
        .toDate()
        .difference(widget.currentJobModel.startDate.toDate())
        .inSeconds
        .toString());
    jobTimeinHours = int.parse(widget.currentJobModel.endDate
        .toDate()
        .difference(widget.currentJobModel.startDate.toDate())
        .inHours
        .toString());
    var preferenceCubit = PreferenceCubit.get(context);
    print("-------------");
    print(preferenceCubit.userModel?.firstName);
    print("-------------");
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return (widget.currentJobModel != null)?
    Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          //Body
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobHeader(
                  jobTitle: widget.currentJobModel.position,
                  backgroundImage: widget.currentJobModel.image.isEmpty ? widget.currentJobModel.employerModel.image : widget.currentJobModel.image,
                  companyName: widget.currentJobModel.employerModel.name,
                  companyLogo: widget.currentJobModel.employerModel.image,
                  opacity: 0.8,
                  employerModel: widget.currentJobModel.employerModel,
                ),
                SizedBox(
                  height: 42.h,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          JobDetails(
                            text: "${widget.currentJobModel.salary} EGP",
                            //TODO MONEY ICON
                            svgIconPath: "assets/money.svg",
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          JobDetails(
                            text:
                            "${widget.currentJobModel.employerModel.rate}",
                            svgIconPath: "assets/rating.svg",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        children: [
                          JobDetails(
                            text:
                            "${widget.currentJobModel.startDate.toDate().day} ${getMonth(widget.currentJobModel.startDate.toDate().month)}",
                            svgIconPath: "assets/date.svg",
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          JobDetails(
                            text:
                            "${formatTime(widget.currentJobModel.startDate.toDate().hour)} - ${formatTime(widget.currentJobModel.endDate.toDate().hour)}",
                            svgIconPath: "assets/time.svg",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      InkResponse(
                        onTap: ()async{
                          if (!await launchUrl(Uri.parse(widget.currentJobModel.locationLink))) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Couldn't open the Link")));
                          }
                        },
                        child: Row(
                          children: [
                            JobDetails(
                              text: widget.currentJobModel.location,
                              svgIconPath: "assets/location.svg",
                              smallText: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      JobInfo(
                        title: "Description",
                        list: widget.currentJobModel.description,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      JobInfo(
                        title: "Requirements",
                        list: widget.currentJobModel.requirements,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 55.h,
                ),
              ],
            ),
          ),
          // Appbar
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 60.h, 14.w, 0),
            child: Row(
              children: [
                // InkWell(
                //   onTap: () {
                //     //TODO UNCOMMENT BACK BUTTON
                //     Navigator.pop(context);
                //   },
                //   child: SvgPicture.asset("assets/backWhite.svg"),
                // ),
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      },
                    icon: SvgPicture.asset("assets/backWhite.svg")
                ),
                Spacer(),
                if (preferenceCubit.isInJobs(widget.currentJobModel.parentID) == 3)
                  SvgPicture.asset("assets/qrcode.svg"),
                SizedBox(
                  width: 20.w,
                ),
                // InkWell(
                //   onTap: () {
                //     showModalBottomSheet<void>(
                //       context: context,
                //       backgroundColor: primary,
                //       shape: const RoundedRectangleBorder(
                //           borderRadius:
                //           BorderRadius.vertical(top: Radius.circular(20))),
                //       builder: (BuildContext context) {
                //         return Padding(
                //           padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                //           child: Column(
                //             // mainAxisAlignment: MainAxisAlignment.end,
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               SizedBox(
                //                 height: 10.h,
                //               ),
                //               Container(
                //                 width: 50.w,
                //                 height: 3.h,
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(20.sp),
                //                 ),
                //               ),
                //               const SizedBox(
                //                 height: 27,
                //               ),
                //               BottomSheetItem(
                //                   text: "Complaint about the job",
                //                   ontap: () {
                //                     AppNavigator.customNavigator(
                //                         context: context,
                //                         screen: SubmitComplaintAboutJob(
                //                           jobId:
                //                           widget.currentJobModel.parentID,
                //                           employerName: widget.currentJobModel
                //                               .employerModel.name,
                //                         ),
                //                         finish: false);
                //                   }),
                //               const SizedBox(
                //                 height: 10,
                //               ),
                //               BottomSheetItem(
                //                 text:
                //                 "Leave a Review about ${widget.currentJobModel.employerModel.name}",
                //                 ontap: () {
                //                   AppNavigator.customNavigator(
                //                       context: context,
                //                       screen: SubmitReview(
                //                         employerId:
                //                         widget.currentJobModel.employerId,
                //                         employerName: widget
                //                             .currentJobModel.employerModel.name,
                //                         rate: widget.currentJobModel.employerModel.rate,
                //                       ),
                //                       finish: false);
                //                 },
                //               ),
                //               const SizedBox(
                //                 height: 10,
                //               ),
                //               BottomSheetItem(
                //                 text:
                //                 "Complaint about ${widget.currentJobModel.employerModel.name}",
                //                 ontap: () {
                //                   AppNavigator.customNavigator(
                //                       context: context,
                //                       screen: SubmitComplaintAboutPlace(
                //                         employerId:
                //                         widget.currentJobModel.employerId,
                //                         employerName: widget
                //                             .currentJobModel.employerModel.name,
                //                       ),
                //                       finish: false);
                //                 },
                //               ),
                //               const SizedBox(
                //                 height: 30,
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: SvgPicture.asset("assets/settings.svg"),
                // ),
                IconButton(
                    onPressed: (){
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  width: 50.w,
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.sp),
                                  ),
                                ),
                                const SizedBox(
                                  height: 27,
                                ),
                                BottomSheetItem(
                                    text: "Complaint about the job",
                                    ontap: () {
                                      AppNavigator.customNavigator(
                                          context: context,
                                          screen: SubmitComplaintAboutJob(
                                            jobId:
                                            widget.currentJobModel.parentID,
                                            employerName: widget.currentJobModel
                                                .employerModel.name,
                                          ),
                                          finish: false);
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                BottomSheetItem(
                                  text:
                                  "Leave a Review about ${widget.currentJobModel.employerModel.name}",
                                  ontap: () {
                                    AppNavigator.customNavigator(
                                        context: context,
                                        screen: SubmitReview(
                                          employerId:
                                          widget.currentJobModel.employerId,
                                          employerName: widget
                                              .currentJobModel.employerModel.name,
                                          rate: widget.currentJobModel.employerModel.rate,
                                        ),
                                        finish: false);
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                BottomSheetItem(
                                  text:
                                  "Complaint about ${widget.currentJobModel.employerModel.name}",
                                  ontap: () {
                                    AppNavigator.customNavigator(
                                        context: context,
                                        screen: SubmitComplaintAboutPlace(
                                          employerId:
                                          widget.currentJobModel.employerId,
                                          employerName: widget
                                              .currentJobModel.employerModel.name,
                                        ),
                                        finish: false);
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset("assets/settings.svg")
                ),
              ],
            ),
          )
        ],
      ),
      //TODO APPLY_FOR_JOB OR DELETE_YOUR_APPLICATION
      floatingActionButton: BlocConsumer<ApplyForJobCubit, ApplyForJobState>(
        listener: (jobContext, state) {
          // TODO: implement listener
          if (state is AddToAppliedJobsSuccess) {}
        },
        builder: (jobContext, state) {
          var applyCubit = ApplyForJobCubit.get(context);

          return BlocConsumer<JobsCubit, JobsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return applyButton(jobCubit, preferenceCubit,applyCubit, jobContext);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ):Container();
  }
}