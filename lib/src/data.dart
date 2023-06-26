import 'package:collection/collection.dart';
import 'package:coyn/src/transaction.dart';

import 'metadata.dart';

final Equality _listEquality = DeepCollectionEquality();

class BlockData {
  final List<Transaction?>? transactions;
  final BlockMetadata? metadata;

  const BlockData({
    this.transactions = const [],
    this.metadata,
  });

  factory BlockData.fromJson(Map<String, Object?> json) {
    return BlockData(
      transactions: (json['transaction'] as List<dynamic>?)
          ?.cast<Map<String, Object?>>()
          .map(Transaction.fromJson)
          .toList(),
      metadata: BlockMetadata.maybeFromJson(
          json['metadata'] as Map<String, Object?>?),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'transaction': transactions?.map((e) => e?.toJson()).toList(),
      'metadata': metadata,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is BlockData &&
        _listEquality.equals(other.transactions, transactions) &&
        other.metadata == metadata;
  }

  @override
  int get hashCode => Object.hashAll([
        transactions,
        metadata,
      ]);
}
