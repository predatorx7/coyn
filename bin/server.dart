import 'dart:convert';
import 'dart:io';

import 'package:coyn/coyn.dart';
import 'package:coyn/src/manager.dart';
import 'package:coyn/src/metadata.dart';

import 'server/server.dart';
import 'server/service.dart';

List<Transaction> transactions = [];

void main(List<String> arguments) async {
  final service = BlockchainService(
    File(arguments[0]),
    BlockchainManager(),
  );

  final app = await startTestHttpServer(
    (router) {
      // curl http://localhost:8080/block/hash/some-hash
      router.get('/block/hash/<hash>',
          (ServerRequest request, String hash) async {
        return ServerResponse.ok(
          await service.getBlockchain().then(
            (value) {
              return value.blockchain
                  .where((element) => element.hash == hash)
                  .toList();
            },
          ).then(json.encode),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          },
        );
      });

      // curl http://localhost:8080/block/latest
      router.get('/block/latest', (ServerRequest request) async {
        return ServerResponse.ok(
          await service
              .getBlockchain()
              .then((value) => value.getTheLatestBlock())
              .then(json.encode),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          },
        );
      });

      // curl http://localhost:8080/block
      router.get('/block', (ServerRequest request) async {
        return ServerResponse.ok(
          await service
              .getBlockchain()
              .then((value) => value.blockchain)
              .then(json.encode),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          },
        );
      });

      // curl http://localhost:8080/commit/abc -X POST -d '{"message": "second block", "data": null}'
      router.post('/commit/<key>', (ServerRequest request, String key) async {
        if (key != 'abc') {
          return ServerResponse.unauthorized(null);
        }
        if (transactions.isEmpty) {
          return ServerResponse.badRequest(
            body: json.encode({
              'message': 'No transactions',
            }),
          );
        }
        BlockMetadata? metadata;
        try {
          final data = await request.readAsString();
          metadata = BlockMetadata.fromJson(json.decode(data));
        } catch (e, s) {
          print('$e\n$s');
          return ServerResponse.internalServerError();
        }
        final target = [for (final it in transactions) it];
        transactions = [];
        if (target.isEmpty) {
          return ServerResponse.internalServerError();
        }
        final current = await service
            .updateBlockchain(
          target,
          metadata,
        )
            .catchError((e, s) {
          print('$e\n$s');
          return null;
        });
        return ServerResponse.ok(
          json.encode(current),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          },
        );
      });

      // curl http://localhost:8080/transaction -X POST -d '{"sender": "mushaheed", "recipient": "duck", "quantity":20}'
      router.post('/transaction', (ServerRequest request) async {
        final data = await request.readAsString();
        final transaction = Transaction.fromJson(json.decode(data));
        transactions.add(transaction);
        return ServerResponse.ok(
          await service
              .getBlockchain()
              .then((value) => value.getTheLatestBlock().index + 1)
              .then(json.encode),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          },
        );
      });
    },
  );

  print('Server running on ${app.uri}');
}
