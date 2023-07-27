import 'package:equatable/equatable.dart';

class ContactItemChangeableValues extends Equatable {
  final int? numberOfUnReadMessages;
  final String? lastMessage;
  final DateTime? lastMessageDateTime;
  const ContactItemChangeableValues({
    this.numberOfUnReadMessages,
    this.lastMessage,
    this.lastMessageDateTime,
  });

  ContactItemChangeableValues copyWith({
    int? numberOfUnReadMessages,
    String? lastMessage,
    DateTime? lastMessageDateTime,
  }) {
    return ContactItemChangeableValues(
      numberOfUnReadMessages:
          numberOfUnReadMessages ?? this.numberOfUnReadMessages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDateTime: lastMessageDateTime ?? this.lastMessageDateTime,
    );
  }

  @override
  List<Object?> get props => [
        numberOfUnReadMessages,
        lastMessage,
        lastMessageDateTime,
      ];
}
