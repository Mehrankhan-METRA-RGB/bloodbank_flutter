
const String userDoc = "BloodBank_Users";
const String authBox = "AuthBox";
const String authBoxCredentialsKey = "user";
const String authBoxDataKey = "data";
const String mapsAPIKey = "AIzaSyB0KUzlF95tXVWyVvIU8nalWK35W7rIh34";
const List<String>? bloodGroups = [
  "A+",
  "O+",
  "B+",
  "AB+",
  "A-",
  "O-",
  "B-",
  "AB-"
];

const Map<String, dynamic> bloodMap = {
  "A+": {
    "donateTo": ["A+", "AB+"],
    "receiveFrom": ["A+", "A-", "O+", "O-"]
  },
  "O+": {
    "donateTo": ["O+", "A+", "B+", "AB+"],
    "receiveFrom": ["O+", "O-"]
  },
  "B+": {
    "donateTo": ["B+", "AB+"],
    "receiveFrom": ["B+", "B-", "O+", "O-"]
  },
  "AB+": {
    "donateTo": ["AB+"],
    "receiveFrom": ["A+", "A-", "O+", "O-"]
  },
  "A-": {
    "donateTo": ["A+", "AB+", "A-", "AB-"],
    "receiveFrom": ["A-", "O-"]
  },
  "O-": {
    "donateTo": ["A+", "O+", "B+", "AB+", "A-", "O-", "B-", "AB-"],
    "receiveFrom": ["O-"]
  },
  "B-": {
    "donateTo": ["B+", "AB+", "B-", "AB-"],
    "receiveFrom": ["b-", "O-"]
  },
  "AB-": {
    "donateTo": ["AB-", "AB+"],
    "receiveFrom": ["B-", "A-", "AB-", "O-"]
  }
};
const List<String>? accountTypes = ["Donor", "Recipient"];


