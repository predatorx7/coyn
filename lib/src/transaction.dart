class Transaction {
  final String sender;
  final String recipient;
  final int quantity;

  const Transaction({
    required this.sender,
    required this.recipient,
    required this.quantity,
  });

  static Transaction? maybeFromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    return Transaction.fromJson(json);
  }

  factory Transaction.fromJson(Map<String, Object?> json) {
    return Transaction(
      sender: json['sender'] as String,
      recipient: json['recipient'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'sender': sender,
      'recipient': recipient,
      'quantity': quantity,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Transaction &&
        other.sender == sender &&
        other.recipient == recipient &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hashAll([
        sender,
        recipient,
        quantity,
      ]);
}
