import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class LocalWebAssetServer {
  LocalWebAssetServer({
    this.assetRoot = 'assets/web',
    this.defaultDocument = 'index.html',
    this.proxyBaseUrl = 'https://polenetrendshops.com',
  });

  final String assetRoot;
  final String defaultDocument;
  final String proxyBaseUrl;

  HttpServer? _server;
  Future<Uri>? _starting;
  final http.Client _client = http.Client();

  Future<Uri> start() {
    final existingServer = _server;
    if (existingServer != null) {
      return Future.value(_serverUri(existingServer));
    }

    return _starting ??= _start();
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    _starting = null;
    await server?.close(force: true);
  }

  Future<Uri> _start() async {
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(_handleRequest);

    final server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      0,
      shared: true,
    );
    _server = server;
    return _serverUri(server);
  }

  Future<Response> _handleRequest(Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok(null, headers: _corsHeaders());
    }
    if (request.url.path.startsWith('api/')) {
      return _proxyRequest(request);
    }

    final assetPath = _assetPathFor(request.url.path);

    try {
      final data = await rootBundle.load(assetPath);
      return Response.ok(
        _byteDataToBytes(data),
        headers: {
          HttpHeaders.contentTypeHeader: _contentTypeFor(assetPath),
          HttpHeaders.cacheControlHeader: 'no-cache',
          ..._corsHeaders(),
        },
      );
    } on FlutterError {
      return Response.notFound('Asset not found: $assetPath');
    }
  }

  Future<Response> _proxyRequest(Request request) async {
    final targetUri = Uri.parse(
      proxyBaseUrl,
    ).replace(path: '/${request.url.path}', query: request.url.query);

    final proxyRequest = http.Request(request.method, targetUri);
    proxyRequest.bodyBytes = await request
        .read()
        .expand((chunk) => chunk)
        .toList();
    proxyRequest.headers.addAll(_proxyHeaders(request.headers));

    try {
      final upstream = await _client.send(proxyRequest);
      final body = await upstream.stream.toBytes();
      debugPrint(
        '[LocalWebAssetServer] proxy ${request.method} $targetUri -> ${upstream.statusCode}',
      );
      return Response(
        upstream.statusCode,
        body: body,
        headers: {..._responseHeaders(upstream.headers), ..._corsHeaders()},
      );
    } catch (error) {
      debugPrint('[LocalWebAssetServer] proxy error: $error');
      return Response.internalServerError(
        body: '{"code":-1,"message":"Proxy request failed"}',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          ..._corsHeaders(),
        },
      );
    }
  }

  Map<String, String> _proxyHeaders(Map<String, String> headers) {
    final result = <String, String>{};
    for (final entry in headers.entries) {
      final key = entry.key.toLowerCase();
      if (key == 'host' ||
          key == 'origin' ||
          key == 'referer' ||
          key == 'content-length') {
        continue;
      }
      result[entry.key] = entry.value;
    }
    return result;
  }

  Map<String, String> _responseHeaders(Map<String, String> headers) {
    final result = <String, String>{};
    for (final entry in headers.entries) {
      final key = entry.key.toLowerCase();
      if (key == 'transfer-encoding' ||
          key == 'content-encoding' ||
          key == 'content-length') {
        continue;
      }
      result[entry.key] = entry.value;
    }
    return result;
  }

  Map<String, String> _corsHeaders() {
    return const {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET,POST,PUT,PATCH,DELETE,OPTIONS',
      'Access-Control-Allow-Headers':
          'authorization,content-type,accept,origin,x-requested-with',
    };
  }

  String _assetPathFor(String urlPath) {
    final decodedPath = Uri.decodeComponent(urlPath);
    final normalizedPath = decodedPath
        .split('/')
        .where((segment) => segment.isNotEmpty && segment != '..')
        .join('/');

    if (normalizedPath.isEmpty) {
      return '$assetRoot/$defaultDocument';
    }

    return '$assetRoot/$normalizedPath';
  }

  Uint8List _byteDataToBytes(ByteData data) {
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Uri _serverUri(HttpServer server) {
    return Uri(scheme: 'http', host: '127.0.0.1', port: server.port, path: '/');
  }

  String _contentTypeFor(String path) {
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.html')) {
      return 'text/html; charset=utf-8';
    }
    if (lowerPath.endsWith('.js')) {
      return 'application/javascript; charset=utf-8';
    }
    if (lowerPath.endsWith('.css')) {
      return 'text/css; charset=utf-8';
    }
    if (lowerPath.endsWith('.json')) {
      return 'application/json; charset=utf-8';
    }
    if (lowerPath.endsWith('.svg')) {
      return 'image/svg+xml; charset=utf-8';
    }
    if (lowerPath.endsWith('.png')) {
      return 'image/png';
    }
    if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (lowerPath.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lowerPath.endsWith('.ico')) {
      return 'image/x-icon';
    }
    if (lowerPath.endsWith('.txt')) {
      return 'text/plain; charset=utf-8';
    }
    return 'application/octet-stream';
  }
}
