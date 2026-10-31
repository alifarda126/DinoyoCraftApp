import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../network/api_client.dart';

/// Konfigurasi koneksi Pusher Channels.
class PusherConfig {
  /// App Key Pusher (didapat dari dashboard Pusher / backend .env).
  static String apiKey = const String.fromEnvironment(
    'PUSHER_APP_KEY',
    defaultValue: '',
  );

  /// Cluster Pusher (contoh: 'ap1' untuk Asia Pacific / Jakarta/Singapore).
  static String cluster = const String.fromEnvironment(
    'PUSHER_APP_CLUSTER',
    defaultValue: 'ap1',
  );

  /// Endpoint autentikasi untuk private / presence channels.
  static String authEndpoint = const String.fromEnvironment(
    'PUSHER_AUTH_ENDPOINT',
    defaultValue: '',
  );

  /// Gunakan enkripsi TLS/WSS.
  static bool useTLS = true;

  /// Cek apakah kredensial Pusher sudah terkonfigurasi.
  static bool get isConfigured => apiKey.trim().isNotEmpty;
}

/// Model pesan realtime chat yang diterima atau dikirim lewat Pusher.
class PusherChatMessage {
  const PusherChatMessage({
    required this.id,
    required this.channel,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.time,
    this.imagePath,
    this.isMine = false,
    this.extraData,
  });

  final String id;
  final String channel;
  final String senderId;
  final String senderName;
  final String text;
  final String time;
  final String? imagePath;
  final bool isMine;
  final Map<String, dynamic>? extraData;

  factory PusherChatMessage.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final senderId = json['sender_id']?.toString() ?? json['userId']?.toString() ?? '';
    final isMine = currentUserId != null && currentUserId.isNotEmpty
        ? senderId == currentUserId
        : json['is_mine'] == true;

    return PusherChatMessage(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      channel: json['channel']?.toString() ?? '',
      senderId: senderId,
      senderName: json['sender_name']?.toString() ?? json['userName']?.toString() ?? 'Penjual Toko',
      text: json['message']?.toString() ?? json['text']?.toString() ?? '',
      time: json['time']?.toString() ?? json['created_at']?.toString() ?? '',
      imagePath: json['image_url']?.toString() ?? json['imagePath']?.toString(),
      isMine: isMine,
      extraData: json['extra'] is Map<String, dynamic> ? json['extra'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'channel': channel,
        'sender_id': senderId,
        'sender_name': senderName,
        'message': text,
        'time': time,
        if (imagePath != null) 'image_url': imagePath,
        'is_mine': isMine,
        if (extraData != null) 'extra': extraData,
      };
}

/// Status koneksi Pusher Channels.
enum PusherConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Service singleton untuk realtime chat menggunakan Pusher Channels.
/// Siap diintegrasikan dengan Backend (Laravel Reverb / Pusher / Soketi).
class PusherService {
  PusherService._internal();
  static final PusherService instance = PusherService._internal();

  PusherChannelsFlutter? _pusher;
  bool _isInitialized = false;
  PusherConnectionState _connectionState = PusherConnectionState.disconnected;

  final StreamController<PusherChatMessage> _messageStreamController =
      StreamController<PusherChatMessage>.broadcast();
  final StreamController<PusherConnectionState> _connectionStateController =
      StreamController<PusherConnectionState>.broadcast();
  final StreamController<Map<String, dynamic>> _typingStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  final Map<String, List<void Function(PusherChatMessage)>> _chatListeners = {};

  /// Stream pesan chat baru dari channel manapun.
  Stream<PusherChatMessage> get messageStream => _messageStreamController.stream;

  /// Stream status koneksi realtime.
  Stream<PusherConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  /// Stream indikator sedang mengetik (typing).
  Stream<Map<String, dynamic>> get typingStream =>
      _typingStreamController.stream;

  /// Status koneksi realtime saat ini.
  PusherConnectionState get connectionState => _connectionState;

  /// Inisialisasi koneksi Pusher.
  Future<void> init({
    String? apiKey,
    String? cluster,
    String? authEndpoint,
  }) async {
    if (apiKey != null && apiKey.isNotEmpty) PusherConfig.apiKey = apiKey;
    if (cluster != null && cluster.isNotEmpty) PusherConfig.cluster = cluster;
    if (authEndpoint != null && authEndpoint.isNotEmpty) {
      PusherConfig.authEndpoint = authEndpoint;
    }

    if (!PusherConfig.isConfigured) {
      debugPrint(
        '[PusherService] Pusher App Key belum diatur. Menggunakan mode simulasi / menunggu konfigurasi BE.',
      );
      return;
    }

    try {
      _pusher = PusherChannelsFlutter.getInstance();
      await _pusher!.init(
        apiKey: PusherConfig.apiKey,
        cluster: PusherConfig.cluster,
        useTLS: PusherConfig.useTLS,
        authEndpoint: PusherConfig.authEndpoint.isNotEmpty
            ? PusherConfig.authEndpoint
            : '${ApiClient.baseUrl}/broadcasting/auth',
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onEvent,
        onSubscriptionError: _onSubscriptionError,
        onAuthorizer: _onAuthorizer,
      );

      _isInitialized = true;
      await connect();
    } catch (e) {
      debugPrint('[PusherService] Inisialisasi Pusher gagal (safe fallback): $e');
      _setConnectionState(PusherConnectionState.error);
    }
  }

  /// Hubungkan websocket ke server Pusher.
  Future<void> connect() async {
    if (!_isInitialized || _pusher == null) return;
    try {
      _setConnectionState(PusherConnectionState.connecting);
      await _pusher!.connect();
    } catch (e) {
      debugPrint('[PusherService] Gagal menyambung ke websocket: $e');
      _setConnectionState(PusherConnectionState.error);
    }
  }

  /// Putuskan sambungan dari server Pusher.
  Future<void> disconnect() async {
    if (!_isInitialized || _pusher == null) return;
    try {
      await _pusher!.disconnect();
      _setConnectionState(PusherConnectionState.disconnected);
    } catch (e) {
      debugPrint('[PusherService] Gagal disconnect: $e');
    }
  }

  /// Subscribe ke channel chat tertentu (misal: `chat.store.dinoyo_ceramic_studio`).
  Future<void> subscribeToChat({
    required String channelName,
    void Function(PusherChatMessage message)? onMessage,
  }) async {
    if (onMessage != null) {
      _chatListeners.putIfAbsent(channelName, () => []).add(onMessage);
    }

    if (!_isInitialized || _pusher == null) {
      debugPrint(
        '[PusherService] Menyimak channel $channelName dalam mode lokal (Pusher backend belum terhubung).',
      );
      return;
    }

    try {
      await _pusher!.subscribe(
        channelName: channelName,
        onEvent: (event) {
          if (event is PusherEvent) {
            _handleIncomingPusherEvent(event);
          }
        },
      );
      debugPrint('[PusherService] Berhasil subscribe ke channel: $channelName');
    } catch (e) {
      debugPrint('[PusherService] Gagal subscribe ke $channelName: $e');
    }
  }

  /// Unsubscribe dari channel obrolan saat meninggalkan ruang obrolan.
  Future<void> unsubscribe(String channelName) async {
    _chatListeners.remove(channelName);
    if (!_isInitialized || _pusher == null) return;

    try {
      await _pusher!.unsubscribe(channelName: channelName);
      debugPrint('[PusherService] Berhasil unsubscribe dari: $channelName');
    } catch (e) {
      debugPrint('[PusherService] Gagal unsubscribe dari $channelName: $e');
    }
  }

  /// Kirim event 'client-typing' ke channel.
  Future<void> triggerTyping({
    required String channelName,
    required bool isTyping,
    required String userId,
  }) async {
    if (!_isInitialized || _pusher == null) return;

    try {
      await _pusher!.trigger(
        PusherEvent(
          channelName: channelName,
          eventName: 'client-typing',
          data: jsonEncode({
            'userId': userId,
            'isTyping': isTyping,
          }),
        ),
      );
    } catch (e) {
      debugPrint('[PusherService] Gagal mengirim event typing: $e');
    }
  }

  /// Kirim pesan chat lewat trigger langsung atau API backend.
  Future<void> sendChatMessage({
    required String channelName,
    required PusherChatMessage message,
  }) async {
    // 1. Pancarkan ke subscriber lokal
    _messageStreamController.add(message);

    // 2. Jika tersambung ke backend/Pusher, kirim via websocket atau API
    if (_isInitialized && _pusher != null) {
      try {
        if (channelName.startsWith('private-') || channelName.startsWith('presence-')) {
          await _pusher!.trigger(
            PusherEvent(
              channelName: channelName,
              eventName: 'client-message',
              data: jsonEncode(message.toJson()),
            ),
          );
        }
      } catch (e) {
        debugPrint('[PusherService] Gagal trigger websocket message: $e');
      }
    }
  }

  /// Memungkinkan pengujian atau simulasi pesan masuk dari BE / Penjual.
  void simulateIncomingMessage(PusherChatMessage message) {
    _messageStreamController.add(message);
    final listeners = _chatListeners[message.channel];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(message);
      }
    }
  }

  // --- Handlers & Callbacks Internal ---

  void _onConnectionStateChange(String currentState, String previousState) {
    debugPrint('[PusherService] Status koneksi: $previousState -> $currentState');
    final mapped = switch (currentState.toUpperCase()) {
      'CONNECTED' => PusherConnectionState.connected,
      'CONNECTING' => PusherConnectionState.connecting,
      'RECONNECTING' => PusherConnectionState.reconnecting,
      'DISCONNECTED' => PusherConnectionState.disconnected,
      _ => PusherConnectionState.error,
    };
    _setConnectionState(mapped);
  }

  void _onError(String message, int? code, dynamic error) {
    debugPrint('[PusherService] Pusher error [$code]: $message ($error)');
    _setConnectionState(PusherConnectionState.error);
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint('[PusherService] Subscription sukses di channel: $channelName');
  }

  void _onSubscriptionError(String message, dynamic error) {
    debugPrint('[PusherService] Subscription error: $message ($error)');
  }

  void _onEvent(PusherEvent event) {
    _handleIncomingPusherEvent(event);
  }

  void _handleIncomingPusherEvent(PusherEvent event) {
    final eventName = event.eventName;
    final rawData = event.data;

    Map<String, dynamic> dataMap = {};
    if (rawData is Map<String, dynamic>) {
      dataMap = rawData;
    } else if (rawData is String && rawData.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          dataMap = decoded;
        }
      } catch (_) {}
    }

    // Tangani event chat baru
    if (eventName == 'new-message' ||
        eventName == 'client-message' ||
        eventName == 'message.created') {
      final msg = PusherChatMessage.fromJson(dataMap);
      _messageStreamController.add(msg);

      final listeners = _chatListeners[event.channelName];
      if (listeners != null) {
        for (final listener in listeners) {
          listener(msg);
        }
      }
    } else if (eventName == 'typing' || eventName == 'client-typing') {
      _typingStreamController.add({
        'channel': event.channelName,
        'userId': dataMap['userId'],
        'isTyping': dataMap['isTyping'] ?? true,
      });
    }
  }

  dynamic _onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      'headers': {
        'Authorization': 'Bearer ${ApiClient.authToken ?? ''}',
        'Accept': 'application/json',
      },
    };
  }

  void _setConnectionState(PusherConnectionState newState) {
    _connectionState = newState;
    _connectionStateController.add(newState);
  }
}

