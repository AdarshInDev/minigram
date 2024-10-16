class AppUser {
  final String uid;
  final String email;
  final String name;

  //constructor
  AppUser({required this.uid, required this.email, required this.name});

  //convert appuser to json
Map<String, dynamic> toJson() {
  return {
    'uid': uid,
    'email': email,
    'name': name
  };
}
//convert Json to AppUser object
factory AppUser.fromJson(Map<String, dynamic>jsonuser){
  return AppUser(
    uid: jsonuser['uid'],
    email: jsonuser['email'],
    name: jsonuser['name'],
  );

}
}
