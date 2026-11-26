import 'dart:convert';

import '../../../core/app_text.dart';
import '../../../core/assets.dart';
import '../../../core/network/api_client.dart';
import '../../../data/mock_data.dart';

/// Model preview pesanan untuk ditampilkan sebagai banner di atas input chat
/// maupun sebagai kartu pesanan interaktif di dalam gelembung pesan chat
/// (dua arah antara Customer Mobile <-> Mitra Web <-> Admin Web).
class OrderChatPreview {
  const OrderChatPreview({
    required this.orderId,
    required this.orderCode,
    required this.status,
    required this.statusLabel,
    required this.sectionLabel,
    required this.storeName,
    required this.productName,
    this.mitraOrderCode,
    this.referenceCode,
    this.initiatedBy = 'customer',
    this.customerName,
    this.productId,
    this.variant = '',
    this.quantity = 1,
    this.totalItems = 1,
    this.otherItemsCount = 0,
    this.unitPrice = 0,
    this.totalAmount = 0,
    this.imageUrl = '',
    this.trackingNumber,
    this.shippingMethod,
  });

  final int orderId;
  final String orderCode;
  final String? mitraOrderCode;
  final String? referenceCode;
  final String initiatedBy;
  final String status;
  final String statusLabel;
  final String sectionLabel;
  final String storeName;
  final String? customerName;
  final String? productId;
  final String productName;
  final String variant;
  final int quantity;
  final int totalItems;
  final int otherItemsCount;
  final int unitPrice;
  final int totalAmount;
  final String imageUrl;
  final String? trackingNumber;
  final String? shippingMethod;

  String get resolvedImage {
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty || trimmed == 'null') return AppAssets.productVas;
    if (trimmed.startsWith('assets/')) return trimmed;
    return ApiClient.resolveImageUrl(trimmed);
  }

  Map<String, dynamic> toJson() {
    return {
      'context_type': 'order',
      'initiated_by': initiatedBy,
      'badge': sectionLabel,
      'order_id': orderId,
      'order_code': orderCode,
      if (mitraOrderCode != null && mitraOrderCode!.isNotEmpty)
        'mitra_order_code': mitraOrderCode,
      if (referenceCode != null && referenceCode!.isNotEmpty)
        'reference_code': referenceCode,
      'status': status,
      'status_label': statusLabel,
      'section_label': sectionLabel,
      'store_name': storeName,
      if (customerName != null && customerName!.isNotEmpty)
        'customer_name': customerName,
      if (productId != null && productId!.isNotEmpty) 'product_id': productId,
      'product_name': productName,
      'variant': variant,
      'quantity': quantity,
      'total_items': totalItems,
      'other_items_count': otherItemsCount,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'image_url': imageUrl,
      if (trackingNumber != null && trackingNumber!.isNotEmpty)
        'tracking_number': trackingNumber,
      if (shippingMethod != null && shippingMethod!.isNotEmpty)
        'shipping_method': shippingMethod,
    };
  }

  factory OrderChatPreview.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v, [int fallback = 0]) {
      if (v is int) return v;
      if (v is num) return v.round();
      if (v is String) {
        return int.tryParse(v) ?? double.tryParse(v)?.round() ?? fallback;
      }
      return fallback;
    }

    final rawId = json['order_id'];
    int parsedOrderId = asInt(rawId, 0);
    if (parsedOrderId <= 0 && rawId is String) {
      final digits = RegExp(r'(\d+)$').firstMatch(rawId)?.group(1);
      if (digits != null) parsedOrderId = int.tryParse(digits) ?? 0;
    }

    final rawStatus = (json['status'] ?? 'paid')
        .toString()
        .trim()
        .toLowerCase();
    final orderCode = (json['order_code'] ?? '').toString().trim().isNotEmpty
        ? json['order_code'].toString().trim()
        : (parsedOrderId > 0 ? '#DNC-$parsedOrderId' : '#DNC');

    final defaultStatusLabel = switch (rawStatus) {
      'pending' => 'Menunggu Pembayaran'.tr,
      'paid' => 'Dibayar • Perlu Dikemas'.tr,
      'packed' => 'Dikemas Penjual'.tr,
      'shipped' => 'Sedang Dikirim'.tr,
      'completed' => 'Pesanan Selesai'.tr,
      'cancelled' => 'Dibatalkan'.tr,
      _ => 'Pesanan Aktif'.tr,
    };

    final defaultSectionLabel = switch (rawStatus) {
      'pending' => 'Konfirmasi Pembayaran'.tr,
      'paid' || 'packed' => 'Produk Dikemas'.tr,
      'shipped' => 'Pesanan Dikirim'.tr,
      'completed' => 'Pesanan Selesai'.tr,
      'cancelled' => 'Pesanan Dibatalkan'.tr,
      _ => 'Detail Pesanan'.tr,
    };

    final tracking = (json['tracking_number'] ?? '').toString().trim();
    final shipping = (json['shipping_method'] ?? '').toString().trim();
    final rawMitraCode = (json['mitra_order_code'] ?? '').toString().trim();
    final rawRefCode = (json['reference_code'] ?? '').toString().trim();
    final isTrxInMitra = rawMitraCode.toUpperCase().startsWith('TRX-');
    final cleanMitraCode =
        (!isTrxInMitra && rawMitraCode.isNotEmpty && rawMitraCode != 'null')
        ? rawMitraCode
        : null;
    final cleanRefCode = (rawRefCode.isNotEmpty && rawRefCode != 'null')
        ? rawRefCode
        : (isTrxInMitra ? rawMitraCode : null);
    final custName = (json['customer_name'] ?? '').toString().trim();
    final prodId = (json['product_id'] ?? '').toString().trim();

    return OrderChatPreview(
      orderId: parsedOrderId,
      orderCode: orderCode,
      mitraOrderCode: cleanMitraCode,
      referenceCode: cleanRefCode,
      initiatedBy: (json['initiated_by'] ?? 'customer').toString(),
      status: rawStatus,
      statusLabel: (json['status_label'] ?? '').toString().trim().isNotEmpty
          ? json['status_label'].toString().trim()
          : defaultStatusLabel,
      sectionLabel:
          (json['section_label'] ?? json['badge'] ?? '')
              .toString()
              .trim()
              .isNotEmpty
          ? (json['section_label'] ?? json['badge']).toString().trim()
          : defaultSectionLabel,
      storeName: (json['store_name'] ?? json['studio'] ?? 'Toko Keramik')
          .toString()
          .trim(),
      customerName: custName.isNotEmpty && custName != 'null' ? custName : null,
      productId: prodId.isNotEmpty && prodId != 'null' && prodId != '0'
          ? prodId
          : null,
      productName: (json['product_name'] ?? 'Produk Keramik').toString().trim(),
      variant: (json['variant'] ?? '').toString().trim(),
      quantity: asInt(json['quantity'], 1).clamp(1, 9999),
      totalItems: asInt(
        json['total_items'] ?? json['quantity'],
        1,
      ).clamp(1, 9999),
      otherItemsCount: asInt(json['other_items_count'], 0).clamp(0, 9999),
      unitPrice: asInt(json['unit_price'] ?? json['price'], 0),
      totalAmount: asInt(json['total_amount'] ?? json['price'], 0),
      imageUrl: (json['image_url'] ?? '').toString().trim(),
      trackingNumber: tracking.isNotEmpty && tracking != 'null'
          ? tracking
          : null,
      shippingMethod: shipping.isNotEmpty && shipping != 'null'
          ? shipping
          : null,
    );
  }

  /// Membangun [OrderChatPreview] langsung dari map pesanan `/orders` atau `/orders/:id/tracking`.
  factory OrderChatPreview.fromOrderMap(
    Map<String, dynamic> order, {
    String initiatedBy = 'customer',
    String? fallbackStoreName,
  }) {
    int asInt(dynamic v, [int fallback = 0]) {
      if (v is int) return v;
      if (v is num) return v.round();
      if (v is String) {
        return int.tryParse(v) ?? double.tryParse(v)?.round() ?? fallback;
      }
      return fallback;
    }

    String extractFirstImage(Map<String, dynamic>? item) {
      if (item == null) return '';
      final direct = item['image_url'] ?? item['image'];
      if (direct is String && direct.trim().isNotEmpty && direct != 'null') {
        return direct.trim();
      }
      final raw = item['image_urls'];
      if (raw is List && raw.isNotEmpty) return raw.first.toString();
      if (raw is String && raw.trim().isNotEmpty) {
        final trimmed = raw.trim();
        if (trimmed.startsWith('[')) {
          try {
            final decoded = jsonDecode(trimmed);
            if (decoded is List && decoded.isNotEmpty) {
              return decoded.first.toString();
            }
          } catch (_) {}
        }
        return trimmed;
      }
      return '';
    }

    final id = asInt(order['id'], 0);
    final status = (order['status'] ?? 'paid').toString().trim().toLowerCase();
    final items = (order['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final first = items.isNotEmpty ? items.first : null;
    final firstQty = first == null
        ? 1
        : asInt(first['quantity'], 1).clamp(1, 9999);
    final totalQty = items.isEmpty
        ? 1
        : items.fold<int>(0, (sum, it) => sum + asInt(it['quantity'], 1));
    final firstPrice = first == null ? 0 : asInt(first['unit_price'], 0);
    final totalDue = asInt(
      order['total_due'] ?? order['total_amount'],
      firstPrice * firstQty,
    );
    final store = (order['store_name'] ?? fallbackStoreName ?? 'Toko Keramik')
        .toString()
        .trim();
    final tracking = (order['tracking_number'] ?? '').toString().trim();
    final shipping = (order['shipping_method'] ?? '').toString().trim();
    final rawMitraOrderCode = (order['mitra_order_code'] ?? '')
        .toString()
        .trim();
    final refCode = (order['reference_code'] ?? '').toString().trim();

    String? computedMitraCode;
    if (rawMitraOrderCode.isNotEmpty && rawMitraOrderCode != 'null') {
      computedMitraCode = rawMitraOrderCode;
    } else if (id > 0) {
      final created =
          DateTime.tryParse((order['created_at'] ?? '').toString())?.toUtc() ??
          DateTime.now().toUtc();
      final y = created.year.toString().padLeft(4, '0');
      final m = created.month.toString().padLeft(2, '0');
      final d = created.day.toString().padLeft(2, '0');
      computedMitraCode = 'ORD-$y$m$d-00$id';
    }

    final statusLabel = switch (status) {
      'pending' => 'Menunggu Pembayaran'.tr,
      'paid' => 'Dibayar • Menunggu Dikemas'.tr,
      'packed' => 'Dikemas Penjual'.tr,
      'shipped' => 'Sedang Dikirim'.tr,
      'completed' => 'Pesanan Selesai'.tr,
      'cancelled' => 'Pesanan Dibatalkan'.tr,
      _ => 'Pesanan Aktif'.tr,
    };

    final sectionLabel = switch (status) {
      'pending' => 'Konfirmasi Pembayaran'.tr,
      'paid' || 'packed' => 'Produk Dikemas'.tr,
      'shipped' => 'Pesanan Dikirim'.tr,
      'completed' => 'Pesanan Selesai'.tr,
      'cancelled' => 'Pesanan Dibatalkan'.tr,
      _ => 'Detail Pesanan'.tr,
    };

    final prodIdStr = first?['product_id']?.toString() ?? '';

    return OrderChatPreview(
      orderId: id,
      orderCode: id > 0 ? '#DNC-$id' : '#DNC',
      mitraOrderCode: computedMitraCode,
      referenceCode: refCode.isNotEmpty && refCode != 'null' ? refCode : null,
      initiatedBy: initiatedBy,
      status: status,
      statusLabel: statusLabel,
      sectionLabel: sectionLabel,
      storeName: store.isEmpty ? 'Toko Keramik' : store,
      productId: prodIdStr.isNotEmpty && prodIdStr != '0' && prodIdStr != 'null'
          ? prodIdStr
          : null,
      productName: (first?['product_name'] ?? 'Produk Pesanan')
          .toString()
          .trim(),
      variant: (first?['variant'] ?? '').toString().trim(),
      quantity: firstQty,
      totalItems: totalQty > 0 ? totalQty : firstQty,
      otherItemsCount: items.length > 1 ? items.length - 1 : 0,
      unitPrice: firstPrice,
      totalAmount: totalDue,
      imageUrl: extractFirstImage(first),
      trackingNumber: tracking.isNotEmpty && tracking != 'null'
          ? tracking
          : null,
      shippingMethod: shipping.isNotEmpty && shipping != 'null'
          ? shipping
          : null,
    );
  }
}

/// Helper parsing & serialisasi metadata konteks chat (`product` & `order`).
class ChatContextHelper {
  const ChatContextHelper._();

  static Map<String, dynamic>? parseMetadata(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final type = map['context_type']?.toString();
      if (type == 'product' || type == 'order') return map;
      return null;
    }
    if (raw is String && raw.trim().isNotEmpty && raw.trim() != 'null') {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          final map = Map<String, dynamic>.from(decoded);
          final type = map['context_type']?.toString();
          if (type == 'product' || type == 'order') return map;
        }
      } catch (_) {}
    }
    return null;
  }

  static Map<String, dynamic> productToMetadata(
    Product product, {
    String? storeFallback,
  }) {
    final store = product.studio.trim().isNotEmpty
        ? product.studio.trim()
        : (storeFallback ?? 'Toko Keramik');
    return {
      'context_type': 'product',
      'initiated_by': 'customer',
      'badge': 'Ditanyakan',
      'product_id': product.id,
      'product_name': product.name,
      'studio': store,
      'store_name': store,
      'price': product.price,
      'rating': product.rating,
      'sold_count': product.soldCount,
      'image_url': product.image,
    };
  }

  static Product? productFromMetadata(Map<String, dynamic>? meta) {
    if (meta == null || meta['context_type'] != 'product') return null;
    final prodId = (meta['product_id'] ?? '').toString().trim();
    if (prodId.isNotEmpty) {
      for (final existing in MockData.products) {
        if (existing.id == prodId) return existing;
      }
    }
    final rawImg = (meta['image_url'] ?? '').toString().trim();
    return Product.fromJson({
      'id': prodId.isNotEmpty ? prodId : '0',
      'name': (meta['product_name'] ?? 'Produk Keramik').toString(),
      'store_name': (meta['store_name'] ?? meta['studio'] ?? 'Toko Keramik')
          .toString(),
      'price': meta['price'] ?? meta['unit_price'] ?? 0,
      'rating': meta['rating'] ?? 0,
      'sold_count': meta['sold_count'] ?? 0,
      'image': rawImg.isNotEmpty ? rawImg : AppAssets.productVas,
    });
  }

  static OrderChatPreview? orderFromMetadata(Map<String, dynamic>? meta) {
    if (meta == null || meta['context_type'] != 'order') return null;
    return OrderChatPreview.fromJson(meta);
  }

  static String formatMetadataPreview(dynamic rawMeta) {
    final meta = parseMetadata(rawMeta);
    if (meta == null) return '';
    if (meta['context_type'] == 'product') {
      final name = (meta['product_name'] ?? 'Produk').toString().trim();
      return 'Menanyakan produk: $name';
    }
    if (meta['context_type'] == 'order') {
      final order = OrderChatPreview.fromJson(meta);
      return '${order.sectionLabel} ${order.orderCode} • ${order.productName}';
    }
    return '';
  }
}
