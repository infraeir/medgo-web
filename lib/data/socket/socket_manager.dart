import 'package:medgo/env.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  Map<String, IO.Socket> _sockets = {};

  SocketManager._internal();

  factory SocketManager.getInstance() {
    return _instance;
  }

  connect(String path, String observeEvent, String token,
      Function(dynamic eventData) f) async {
    try {
      final urlFinal = Env.socketURL + path;

      // Desconecta e remove o socket existente, se houver
      if (_sockets.containsKey(path)) {
        _sockets[path]?.disconnect();
        _sockets.remove(path);
      }

      IO.Socket socket = IO.io(
          urlFinal,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({'Authorization': 'Bearer $token'})
              .build());

      socket.onConnect((_) {
        print('&& conectado a $path');
        socket.on(observeEvent, (data) {
          f(data);
        });
      });

      socket.onConnectError(
          (data) => print('&& erro de conexão em $path: $data'));
      socket.onError((data) => print('&& erro em $path: $data'));
      socket.onDisconnect((_) => print('&& desconectado de $path'));

      socket.connect();

      _sockets[path] = socket;
    } catch (e) {
      print('&& erro durante a conexão a $path: $e');
    }
  }

  notifyServerWith(String event, Map<String, dynamic> data) {
    _sockets.values.forEach((socket) {
      socket.emit(event, data);
    });
  }

  disconnect(String path) {
    if (_sockets.containsKey(path)) {
      _sockets[path]?.disconnect();
      _sockets.remove(path);
      print("&& SOCKET para $path FOI DESCONECTADO!");
    }
  }

  disconnectAll() {
    _sockets.forEach((path, socket) {
      socket.disconnect();
    });
    _sockets.clear();
    print("&& TODOS OS SOCKETS FORAM DESCONECTADOS!");
  }
}
