import 'dart:convert';
import 'dart:io';

import 'package:coyn/coyn.dart';

void main(List<String> arguments) async {
  final manager = BlockchainManager();
  final file = File(arguments[0]);
  final blockchain = await manager.fromJsonFile(file);
  blockchain.addNewBlock(
    BlockRequirement.create(
      BlockData(
        transactions: [
          Transaction(
            sender: '1',
            recipient: '2',
            quantity: 1,
          ),
        ],
      ),
    ),
  );
  print('index,timestamp,previousHash,data,hash');
  for (final block in blockchain.blockchain) {
    print(
      '${block.index},${block.timestamp},${block.previousHash},${json.encode(block.data)},${block.hash}',
    );
  }

  await manager.toJsonFile(blockchain, file);
}
