
class DashboardModel {
  late final String id;
  late final String email;
  late final String image;
  late final String password;

  DashboardModel({required this.id, required this.email,required this.image,required this.password});

  DashboardModel.fromMap(Map<String, dynamic> data){
  id = data["Id"];
  email = data["Email"];
  image = data["Image"];
  password = data["Password"];
  }

  Map<String, dynamic> toMap() {
    // hashmap for setting data to firestore
    return {
      "Id": id,
      "Email": email,
      "Image": image,
      "Password": password

    };
  }

}