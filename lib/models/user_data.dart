class UserData {
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  String? dateOfBirth;

  // We'll store it as "Male" or "Female"
  String? gender;


  void setGenderFromTitle(String title) {
    gender = (title == "Mr.") ? "Male" : "Female";
  }
  String? formatDateOfBirth(String? dateOfBirth) {

    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {

      try {
        final parsedDate = DateTime.parse(dateOfBirth);
        return parsedDate.toIso8601String().split('T')[0]; // Format "yyyy-MM-dd"
      } catch (e) {

        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'dateOfBirth':  formatDateOfBirth(dateOfBirth), // yyyy-MM-dd
      'gender': gender,
    };
  }

}