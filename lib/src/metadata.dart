import 'package:collection/collection.dart';

final Equality _mapEquality = DeepCollectionEquality();

class BlockMetadata {
  final Map<String, Object?>? data;
  final String? message;

  const BlockMetadata({
    this.data,
    this.message,
  });

  factory BlockMetadata.fromJson(Map<String, Object?> json) {
    return BlockMetadata(
      data: json['data'] as Map<String, Object?>?,
      message: json['message'] as String?,
    );
  }

  static BlockMetadata? maybeFromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    return BlockMetadata.fromJson(json);
  }

  Map<String, Object?> toJson() {
    return {
      'transaction': data,
      'message': message,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is BlockMetadata &&
        _mapEquality.equals(other.data, data) &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hashAll([
        data,
        message,
      ]);
}
