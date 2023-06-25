import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_framework/http.dart';
import 'package:logging/logging.dart';

import 'server/transactions.dart';

void main() async {
  final logger = Logger('angel_graphql');
  final app = Angel(
    logger: logger
      ..onRecord.listen(
        (rec) {
          print(rec);
          if (rec.error != null) print(rec.error);
          if (rec.stackTrace != null) print(rec.stackTrace);
        },
      ),
  );

  final http = AngelHttp(app);

  TransactionsService.add(app);

  final server = await http.startServer(
    '127.0.0.1',
    3000,
  );
  final uri = Uri(
    scheme: 'http',
    host: server.address.address,
    port: server.port,
  );
  final graphiqlUri = uri.replace(path: 'graphiql');
  print('Listening at $uri');
  print('Access graphiql at $graphiqlUri');
}
