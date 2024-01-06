import '../../Model/jobs_model/applied_job_model.dart';
import '../../Model/jobs_model/job_model.dart';
import '../../Model/jobs_model/job_month_model.dart';
import '../../Model/jobs_model/job_year_model.dart';

class JobFunctions{

  // adjust each array
  static List<JobYearModel> execute(List<AppliedJobModel> jobs){
    Map<String,List<AppliedJobModel>>years={};
    List<JobYearModel>jobYearList=[];

    // sort data according to timeZone.
    jobs.sort((a, b) => b.appliedTime.millisecondsSinceEpoch.compareTo(a.appliedTime.millisecondsSinceEpoch));

    // mapping year[2023]-> all jobs;
    jobs.forEach((element) {
      if(years[element.year.toString()]!=null){
        years[element.year.toString()]?.add(element);
      }else{
        years[element.year.toString()] = [];
        years[element.year.toString()]?.add(element);
      }
    });

    years.forEach((key, value) {
      // key -> year
      // value List<Jobs>
      // extract Months;
      List<JobMonthModel> months = getAllMonths(value);

      // add new object in jobYearModelList
      jobYearList.add(JobYearModel(year: key, monthsList: months));
    });

    return jobYearList;
  }

  static List<JobMonthModel> getAllMonths(List<AppliedJobModel> list){
    Map<String,List<AppliedJobModel>>jobMonths = {};
    List<JobMonthModel>jobMonthModelList=[];
    //mapping jobs
    list.forEach((element) {
      if(jobMonths[element.month]!=null){
        jobMonths[element.month]?.add(element);
      }
      else{
        jobMonths[element.month] = [];
        jobMonths[element.month]?.add(element);
      }
    });

    jobMonths.forEach((key, value) {
      jobMonthModelList.add(JobMonthModel(month: key, jobList: value));
    });
    return jobMonthModelList;
  }
}