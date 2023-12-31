import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import "package:pointycastle/export.dart" as pointycastle;

import 'data.dart';

class BlockRequirement {
  final DateTime timestamp;
  final BlockData data;

  const BlockRequirement(
    this.timestamp,
    this.data,
  );

  factory BlockRequirement.create(
    BlockData data,
  ) {
    return BlockRequirement(
      DateTime.now(),
      data,
    );
  }

  factory BlockRequirement.fromJson(Map<String, Object?> json) {
    return BlockRequirement(
      DateTime.parse(json['timestamp'] as String),
      BlockData.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'data': data.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Block && other.timestamp == timestamp && other.data == data;
  }

  @override
  int get hashCode => Object.hashAll([
        timestamp,
        data,
      ]);
}

class Block implements BlockRequirement {
  final int index;
  @override
  final DateTime timestamp;
  @override
  final BlockData data;
  final String previousHash;
  final String hash;

  const Block(
    this.index,
    this.timestamp,
    this.data,
    this.previousHash,
    this.hash,
  );

  Block.generate(
    this.index,
    this.timestamp,
    this.data,
    this.previousHash,
  ) : hash = generateHash(
          index,
          timestamp,
          data,
          previousHash,
        );

  bool isHashValid() {
    final newHash = generateHash(
      index,
      timestamp,
      data,
      previousHash,
    );
    return hash == newHash;
  }

  factory Block.fromJson(Map<String, Object?> json) {
    return Block(
      json['index'] as int,
      DateTime.parse(json['timestamp'] as String),
      BlockData.fromJson(json['data'] as Map<String, Object?>),
      json['previousHash'] as String,
      json['hash'] as String,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      'index': index,
      'timestamp': timestamp.toIso8601String(),
      'data': data.toJson(),
      'previousHash': previousHash,
      'hash': hash,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Block &&
        other.index == index &&
        other.timestamp == timestamp &&
        other.data == data &&
        other.previousHash == previousHash;
  }

  @override
  int get hashCode => Object.hashAll([
        index,
        timestamp,
        data,
        previousHash,
      ]);

  static String generateHash(
    int index,
    DateTime timestamp,
    BlockData data,
    String previousHash,
  ) {
    final buffer = StringBuffer();
    buffer.write(index);
    buffer.write(timestamp.toIso8601String());
    buffer.write(previousHash);
    buffer.write(json.encode(data));
    final bytes = utf8.encode(buffer.toString()) as Uint8List;
    final digest = sha256Digest(bytes);
    return digest.toString();
  }
}

Digest sha256Digest(Uint8List dataToDigest) {
  final d = pointycastle.SHA256Digest();

  final digest = d.process(dataToDigest);
  return Digest(digest);
}
