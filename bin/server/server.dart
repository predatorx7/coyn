import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

typedef ServerResponse = Response;
typedef ServerRequest = Request;

class ServerApp {
  final HttpServer server;
  final Uri uri;

  const ServerApp({
    required this.server,
    required this.uri,
  });
}

Future<ServerApp> startTestHttpServer(
  void Function(Router router) onRouter, [
  int port = 8080,
]) async {
  var app = Router();

  app.get('/ping', (Request request) {
    return Response.ok('pong');
  });

  onRouter(app);

  final server = await io.serve(app, 'localhost', port);

  final serverUri = Uri.http('${server.address.host}:${server.port}');

  return ServerApp(server: server, uri: serverUri);
}
