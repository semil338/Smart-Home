String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return "Enter email address";
  }
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (regExp.hasMatch(value)) {
    return null;
  }
  return 'Please enter valid email';
}

String? validatePassword(String? value) {
  if (value!.length > 7) {
    return null;
  }
  return 'Password must be upto 8 characters';
}

String? validateName2(String? value) {
  String pattern = r"^([A-Za-z0-9\s]){3,}$";
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Please enter name';
  } else if (!regExp.hasMatch(value.toString())) {
    return 'Please enter valid name';
  }
  return null;
}

String? validateName(String? value) {
  String pattern = r"^\s*([A-Za-z]{4,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Please enter full name';
  } else if (!regExp.hasMatch(value.toString())) {
    return 'Please enter valid full name';
  }
  return null;
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    default:
      return "Login failed. Please try again.";
  }
}
