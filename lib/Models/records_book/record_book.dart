import 'dart:typed_data';

class User {
  int id;
  String name;

  User({this.id, this.name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  static final columns = ["id", "name"];
}

class Records {
  int recid;
  int userid;
  String doctor;
  String hospital;
  String problem;
  String date;
  Uint8List img1;
  Uint8List img2;
  Uint8List img3;
  Uint8List img4;

  Records(
      {this.recid,
      this.userid,
      this.doctor,
      this.hospital,
      this.problem,
      this.date,
      this.img1,
      this.img2,
      this.img3,
      this.img4});

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map["rec_id"]=recid;
    map["user_id"] = userid;
    map["doctor"] = doctor;
    map["hospital"] = hospital;
    map["problem"] = problem;
    map["date"] = date;
    map["img1"] = img1;
    map["img2"] = img2;
    map["img3"] = img3;
    map["img4"] = img4;
    return map;
  }
}
