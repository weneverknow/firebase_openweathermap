import 'package:equatable/equatable.dart';

class Member {
  final String? id;
  final String? name;
  final String phone;
  final String verificationId;
  final String pin;
  final String firebaseUserId;
  final String? imageUrl;

  Member(
      {this.id,
      this.name,
      required this.phone,
      required this.verificationId,
      required this.pin,
      required this.firebaseUserId,
      this.imageUrl});

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        verificationId: map['verificationId'],
        pin: map['pin'],
        firebaseUserId: map['firebaseUserId'],
        imageUrl: map['imageUrl']);
  }

  Member copyWith({String? id, String? name, String? imageUrl}) {
    return Member(
        id: id ?? this.id,
        phone: phone,
        verificationId: verificationId,
        pin: pin,
        name: name ?? this.name,
        firebaseUserId: firebaseUserId,
        imageUrl: imageUrl);
  }
}
