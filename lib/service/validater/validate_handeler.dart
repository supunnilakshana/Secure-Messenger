class Validater {
  static String? genaralvalid(String value) {
    if (value.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  static String? signupPassword(String value) {
    if (value.isEmpty) {
      return "Please enter a password";
    } else if (value.length < 7) {
      return "Password must be at least 7 characters";
    }
    return null;
  }

  static String? vaildemail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty) {
      return "This field can't be empty";
    } else if (emailValid == false) {
      return "Please enter a correct email";
    }
    return null;
  }

  static String? isNumeric(String s) {
    if (s.isEmpty) {
      return "Please enter value";
    }
    if (double.tryParse(s) != null) {
      return null;
    } else {
      return "invalid value";
    }
  }

  static String? isSmark(String s) {
    if (s.isEmpty) {
      return "Please enter value";
    }
    if (double.tryParse(s) != null) {
      double val = double.parse(s);
      if ((val >= 0) && (200.0 >= val)) {
        return null;
      } else {
        return "Invalid Mark";
      }
    } else {
      return "Invalid Mark";
    }
  }

  static String? isGrade(String s) {
    if (s.isEmpty) {
      return "Please enter value";
    }
    if (s == 'A' || s == 'B' || s == 'C' || s == 'S' || s == 'F') {
      return null;
    } else {
      return "Please enter Grade Using a Capital letter";
    }
  }

  static String? genaralemptyvalid(String value) {
    return null;
  }

  static String? optionalemailvalid(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty) {
      return null;
    } else {
      if (emailValid == false) {
        return "Please enter a correct email";
      } else {
        return null;
      }
    }
  }
}
