import 'dart:convert';
import 'dart:io';

import 'package:coyn/src/error.dart';

import 'blockchain.dart';

class BlockchainManager {
  Blockchain fromJsonString(String jsonString) {
    dynamic data;
    try {
      data = json.decode(jsonString);
    } on FormatException {
      data = [];
    }
    final blockchain = Blockchain.fromJson(data);
    if (!blockchain.isChainIntegrityValidSync()) {
      throw InvalidBlockchainIntegrityError(blockchain.getTheLatestBlock());
    }
    return blockchain;
  }

  String toJsonString(Blockchain blockchain) {
    if (!blockchain.isChainIntegrityValidSync()) {
      throw InvalidBlockchainIntegrityError(blockchain.getTheLatestBlock());
    }
    final data = blockchain.toJson();
    final jsonString = json.encode(data);
    return jsonString;
  }

  Future<Blockchain> fromJsonFile(File file) async {
    if (!await file.exists()) {
      await file.create();
    }
    final fileContent = await file.readAsString();
    return fromJsonString(fileContent);
  }

  Future<File> toJsonFile(Blockchain blockchain, File file) {
    final fileContent = toJsonString(blockchain);
    return file.writeAsString(fileContent);
  }
}
