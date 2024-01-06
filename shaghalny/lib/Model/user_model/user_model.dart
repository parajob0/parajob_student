import 'package:cloud_firestore/cloud_firestore.dart';

/*class UserModel {
  static String? _id;
  static String _firstName = '';
  static String _lastName = '';
  static String _email = '';
  static String _phoneNumber = '';
  static String _profilePic = '';
  static String _gender = '';
  static int _level = 0;
  static String _city = '';
  static String _area = '';
  static String _type = '';
  static String _password = '';
  static String _university = '';
  static String _graduationYear = '';
  static String _faculty = '';
  static String _accountName = '';
  static int _accountNumber = 0;
  static String _bankName = '';

  static List<String> _employersCount = [];
  static Map<String, dynamic> _jobHistory = Map<String, dynamic>();
  static Map<String, dynamic> _jobs = Map<String, dynamic>();
  static int _totalIncome = 0;

  static List<String> get employersCount => _employersCount;


  static set employersCount(List<String> value) {
    _employersCount = value;
  }

  static List<dynamic> _warnings = [];
  static int _xp = 0;

  static bool signedInUsingGoogle = false;

  //SETTERS
  static void setSignedInUsingGoogle(bool value){ signedInUsingGoogle = value;}
  static void setID(String? id){ _id = id;}
  static void setFirstName(String firstName){ _firstName = firstName;}
  static void setLastName(String lastName){ _lastName = lastName;}
  static void setEmail(String email){ _email = email;}
  static void setPhoneNumber(String phoneNumber){ _phoneNumber = phoneNumber;}
  static void setProfilePic(String profilePic){ _profilePic = profilePic;}
  static void setGender(String gender){ _gender = gender;}
  static void setLevel(int level){ _level = level;}
  static void setCity(String city){ _city = city;}
  static void setArea(String area){ _area = area;}
  static void setType(String type){ _type = type;}
  static void setPassword(String password){ _password = password;}
  static void setUniversity(String university){ _university = university;}
  static void setGraduationYear(String graduationYear){ _graduationYear = graduationYear;}
  static void setFaculty(String faculty){ _faculty = faculty;}
  static void setAccountName(String accountName){ _accountName = accountName;}
  static void setAccountNumber(int accountNumber){ _accountNumber = accountNumber;}
  static void setBankName(String bankName){ _bankName = bankName;}
  static void setWarnings(List<dynamic> value) {
    _warnings = value;
  }
  static void setJobHistory(Map<String, dynamic> value) {
    _jobHistory = value;
  }
  static void setJobs(Map<String, dynamic> value) {
    _jobs = value;
  }
  static void setTotalIncome(int value) {
    _totalIncome = value;
  }
  static void setXp(int value) {
    _xp = value;
  }
  static void setEmployersCount(List<String> value) {
    _employersCount = value;
  }

  //GETTERS
  static String? getID() => _id;
  static String getFirstName() => _firstName;
  static String getLastName() => _lastName;
  static String getEmail() => _email;
  static String getPhoneNumber() => _phoneNumber;
  static String getProfilePic() => _profilePic;
  static String getGender() => _gender;
  static int getLevel() => _level;
  static String getCity() => _city;
  static String getArea() => _area;
  static String getType() => _type;
  static String getPassword() => _password;
  static String getUniversity() => _university;
  static String getGraduationYear() => _graduationYear;
  static String getFaculty() => _faculty;
  static String getAccountName() => _accountName;
  static int getAccountNumber() => _accountNumber;
  static String getBankName() => _bankName;
  static bool getSignedInUsingGoogle() => signedInUsingGoogle;
  static Map<String, dynamic> get jobHistory => _jobHistory;
  static Map<String, dynamic> get jobs => _jobs;
  static int get totalIncome => _totalIncome;
  static List<dynamic> get warnings => _warnings;
  static int get xp => _xp;



  static void UserModelFromJson(Map<String,dynamic>json){
    setID(json['user_id']??"");
    setFirstName(json['first_name']??"");
    setLastName(json['last_name']??"");
    setEmail(json['email']??"");
    setPhoneNumber(json['phone_number']??"");
    setProfilePic(json['profile_pic']??"");
    setGender(json['gender']??"");
    setLevel(json['level']??0);
    setCity(json['city']??"");
    setArea(json['area']??"");
    setType(json['type']??"");
    setUniversity(json['university']??"");
    setGraduationYear(json['graduation_year']??"");
    setFaculty(json['faculty']??"");
    setAccountName(json['account_name']??"");
    setAccountNumber(json['account_number']??0);
    setBankName(json['bank_name']??"");
    setWarnings(json['warnings']??[]);
    setJobHistory(json['job_history']?? {});
    setJobs(json['jobs']??{});
    setTotalIncome(json['total_income']??0);
    setXp(json['xp']??0);
  }
}*/

class NewUserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? profilePic;
  String? gender;
  int? level;
  String? city;
  String? area;
  String? university;
  String? graduationYear;
  String? faculty;
  String? accountName;
  int? accountNumber;
  String? bankName;
  String? universityId;
  bool isApproved;
  bool isBanned;
  List<dynamic> notifications;

  List<dynamic> employersCount;
  int? xp;
  Map<String, dynamic>? jobs;
  Map<String, dynamic>? jobHistory;
  Map<String, dynamic> warnings;
  int? totalIncome;
  bool? externalSignIn;

  //if he is in a job
  String inJob;

  NewUserModel(
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.password,
      this.profilePic,
      this.gender,
      this.level,
      this.city,
      this.area,
      this.university,
      this.graduationYear,
      this.faculty,
      this.accountName,
      this.accountNumber,
      this.bankName,
      this.xp,
      this.jobs,
      this.jobHistory,
      this.warnings,
      this.totalIncome,
      this.externalSignIn,
      this.universityId,
      this.notifications,
      this.employersCount,
      this.isApproved,
      this.isBanned,
      this.inJob,
      );

  void clearUserModel(){
    try{
      firstName =  '';
      lastName =  '';
      email =  "";
      phoneNumber =  '';
      password = '';
      profilePic = '';
      gender = "";
      level =  0;
      city =  "";
      area =  '';
      university =  '';
      graduationYear =  '';
      faculty = '';
      universityId =  '';
      accountName =  '';
      accountNumber =  0;
      bankName = '';
      xp = 0;
      jobs = {};
      jobHistory =  {};
      warnings = {};
      totalIncome =  0;
      notifications =  [];
      employersCount = [];
      externalSignIn = false;
      isApproved = true;
      isBanned = false;
      inJob = '';
    }catch(e){
      print(e.toString());
    }

  }


  NewUserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        firstName = doc.data()!["first_name"] ?? '',
        lastName = doc.data()!["last_name"] ?? '',
        email = doc.data()!["email"] ?? "",
        phoneNumber = doc.data()!["phone_number"] ?? '',
        password = doc.data()!["password"] ?? '',
        profilePic = doc.data()!["profile_pic"] ?? '',
        gender = doc.data()!["gender"] ?? "",
        level = doc.data()!["level"] ?? 0,
        city = doc.data()!["city"] ?? "",
        area = doc.data()!['area'] ?? '',
        university = doc.data()!['university'] ?? '',
        graduationYear = doc.data()!['graduation_year'] ?? '',
        faculty = doc.data()!['faculty'] ?? '',
        universityId = doc.data()!['university_id'] ?? '',
        accountName = doc.data()!['account_name'] ?? '',
        accountNumber = doc.data()!['account_number'] ?? 0,
        bankName = doc.data()!['bank_name'] ?? '',
        xp = doc.data()!['xp'] ?? 0,
        jobs = doc.data()!['jobs'] ?? {},
        jobHistory = doc.data()!['job_history'] ?? {},
        warnings = doc.data()!['warnings'] ?? {},
        totalIncome = doc.data()!['total_income'] ?? 0,
        notifications = doc.data()!['notifications'] ?? [],
        employersCount = doc.data()?['employer_count']??[],
        externalSignIn = doc.data()!["with_google"] ?? false,
        isApproved = doc.data()!["is_approved"] ?? true,
        isBanned = doc.data()!["is_banned"] ?? false,
        inJob = doc.data()!["in_job"] ?? '';
}
