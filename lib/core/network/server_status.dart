import 'package:flutter/foundation.dart';

/// Pelacak global keterjangkauan server DinoyoCraft.
///
/// [ApiClient] memanggil [markDown] saat semua host gagal dijangkau dan
/// [markUp] begitu ada respons apa pun dari server (status HTTP apa pun
/// berarti server hidup). [ConnectionGate] memakai notifier ini untuk
/// menampilkan halaman "server tidak dapat dihubungi".
class ServerStatus {
  ServerStatus._();

  static final ValueNotifier<bool> reachable = ValueNotifier<bool>(true);

  static bool get isReachable => reachable.value;

  static void markUp() {
    if (!reachable.value) {
      debugPrint('[ServerStatus] Server TERJANGKAU kembali.');
      reachable.value = true;
    }
  }

  static void markDown() {
    if (reachable.value) {
      debugPrint('[ServerStatus] Server TIDAK terjangkau.');
      reachable.value = false;
    }
  }
}
