import 'dart:async';
import 'dart:io';

import 'package:coyn/coyn.dart';
import 'package:coyn/src/metadata.dart';

class BlockchainService {
  final File file;
  final BlockchainManager manager;

  BlockchainService(
    this.file,
    this.manager,
  );

  Future<Blockchain> getBlockchain() async {
    await waitForBlockPublish();
    return manager.fromJsonFile(file);
  }

  Future<void> waitForBlockPublish() async {
    if (_completer != null && !_completer!.isCompleted) {
      print('waiting for block publishing');
      await _completer!.future;
      print('block publishing done');
    }
  }

  Completer<void>? _completer;

  Future<Block?> updateBlockchain(
    List<Transaction> transactions,
    BlockMetadata? metadata,
  ) async {
    await waitForBlockPublish();

    _completer = Completer();

    try {
      final blockchain = await manager.fromJsonFile(file);
      blockchain.addNewBlock(BlockRequirement.create(BlockData(
        transactions: transactions,
        metadata: metadata,
      )));
      await manager.toJsonFile(blockchain, file);
      _completer!.complete();
      _completer = null;
      return blockchain.getTheLatestBlock();
    } catch (_) {
      _completer!.complete();
      _completer = null;
      rethrow;
    }
  }
}
