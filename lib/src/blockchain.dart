import 'package:coyn/src/metadata.dart';
import 'package:meta/meta.dart';

import 'block.dart';
import 'data.dart';

class Blockchain {
  final List<Block> blockchain;

  Blockchain(this.blockchain) {
    if (blockchain.isEmpty) {
      blockchain.add(createGenesisBlock());
    }
  }

  @protected
  Block createGenesisBlock() {
    return Block.generate(
      0,
      DateTime.parse('2023-06-25T20:28:37.688Z'),
      const BlockData(
        metadata: BlockMetadata(
          message: 'first block on the chain',
        ),
      ),
      '0',
    );
  }

  Block getTheLatestBlock() {
    return blockchain.last;
  }

  void addNewBlock(BlockRequirement requirement) {
    final last = getTheLatestBlock();
    final previousHash = last.hash;
    final block = Block.generate(
      last.index + 1,
      requirement.timestamp,
      requirement.data,
      previousHash,
    );
    blockchain.add(block);
  }

  bool isChainIntegrityValidSync() {
    for (var i = 1; i < blockchain.length; i++) {
      final currentBlock = blockchain[i];
      final previousBlock = blockchain[i - 1];
      if (!currentBlock.isHashValid()) {
        return false;
      }
      if (currentBlock.previousHash != previousBlock.hash) {
        return false;
      }
    }
    return true;
  }

  Block? getInvalidBlockSync() {
    for (var i = 1; i < blockchain.length; i++) {
      final currentBlock = blockchain[i];
      final previousBlock = blockchain[i - 1];
      if (!currentBlock.isHashValid()) {
        return currentBlock;
      }
      if (currentBlock.previousHash != previousBlock.hash) {
        return currentBlock;
      }
    }
    return null;
  }

  factory Blockchain.fromJson(List<dynamic> json) {
    final data = json.cast<Map<String, Object?>>().map(Block.fromJson).toList();
    return Blockchain(data);
  }

  List<Map<String, Object?>> toJson() {
    return blockchain.map((e) => e.toJson()).toList();
  }
}
