import 'package:coyn/src/transaction.dart';

class BlockData {
  final Transaction? transaction;
  final String message;

  const BlockData({
    this.transaction,
    required this.message,
  });

  factory BlockData.fromJson(Map<String, Object?> json) {
    return BlockData(
      transaction: Transaction.maybeFromJson(
        json['transaction'] as Map<String, Object?>?,
      ),
      message: json['message'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'transaction': transaction?.toJson(),
      'message': message,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is BlockData &&
        other.transaction == transaction &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hashAll([
        transaction,
        message,
      ]);
}
