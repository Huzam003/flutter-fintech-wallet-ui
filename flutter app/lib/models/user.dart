class User {
  final String id;
  final String email;
  final String password;
  final String? name;
  final String? furigana;
  final String? phoneNumber;
  final bool isVerified;
  final double balance;
  final String? profileImagePath;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.name, // Name (氏名)
    this.furigana, // Furigana (フリガナ)
    this.phoneNumber, // Phone Number (電話番号)
    this.isVerified = false,
    this.balance = 0.0,
    this.profileImagePath,
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? furigana,
    String? phoneNumber,
    bool? isVerified,
    double? balance,
    String? profileImagePath,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      furigana: furigana ?? this.furigana,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      balance: balance ?? this.balance,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'furigana': furigana,
    'phoneNumber': phoneNumber,
    'isVerified': isVerified,
    'balance': balance,
    'profileImagePath': profileImagePath,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    password: json['password'],
    name: json['name'],
    furigana: json['furigana'],
    phoneNumber: json['phoneNumber'],
    isVerified: json['isVerified'] ?? false,
    balance: json['balance'] ?? 0.0,
    profileImagePath: json['profileImagePath'],
  );
}
