import '../../domain/entities/payment.dart';

double _toDouble(dynamic value, [double fallback = 0.0]) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value') ?? fallback;
}

int _toInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

String? _toNullableString(dynamic value) {
  final str = value?.toString();
  if (str == null || str.isEmpty || str == 'null') return null;
  return str;
}

class PaymentModel extends Payment {
  const PaymentModel({
    required super.orderId,
    required super.transactionId,
    required super.referenceCode,
    super.gateway = 'midtrans',
    super.gatewayOrderId,
    required super.paymentMethod,
    super.paymentType,
    required super.label,
    required super.amount,
    super.baseAmount = 0.0,
    super.serviceFee = 0.0,
    super.channelFee = 0.0,
    required super.totalPay,
    super.qrString,
    super.qrImageUrl,
    super.vaNumber,
    super.bank,
    super.billerCode,
    super.deeplinkUrl,
    super.paymentUrl,
    super.token,
    super.invId,
    super.expiryTime,
    required super.status,
    super.reused = false,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final amount = _toDouble(json['amount']);
    final totalPay = _toDouble(json['total_pay'], amount);
    return PaymentModel(
      orderId: _toInt(json['order_id']),
      transactionId: _toInt(json['transaction_id']),
      referenceCode: json['reference_code']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? 'midtrans',
      gatewayOrderId: _toNullableString(json['gateway_order_id']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentType: _toNullableString(json['payment_type']),
      label: json['label']?.toString() ??
          json['payment_method']?.toString() ??
          'Pembayaran',
      amount: amount,
      baseAmount: _toDouble(json['base_amount']),
      serviceFee: _toDouble(json['service_fee']),
      channelFee: _toDouble(json['channel_fee']),
      totalPay: totalPay > 0 ? totalPay : amount,
      qrString: _toNullableString(json['qr_string']),
      qrImageUrl: _toNullableString(json['qr_image_url']),
      vaNumber: _toNullableString(json['va_number']),
      bank: _toNullableString(json['bank']),
      billerCode: _toNullableString(json['biller_code']),
      deeplinkUrl: _toNullableString(json['deeplink_url']),
      paymentUrl: _toNullableString(json['payment_url']),
      token: _toNullableString(json['token']),
      invId: _toNullableString(json['inv_id']),
      expiryTime: _toNullableString(json['expiry_time']),
      status: json['payment_status']?.toString() ??
          json['status']?.toString() ??
          'pending',
      reused: json['reused'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'transaction_id': transactionId,
      'reference_code': referenceCode,
      'gateway': gateway,
      'gateway_order_id': gatewayOrderId,
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      'label': label,
      'amount': amount,
      'base_amount': baseAmount,
      'service_fee': serviceFee,
      'channel_fee': channelFee,
      'total_pay': totalPay,
      'qr_string': qrString,
      'qr_image_url': qrImageUrl,
      'va_number': vaNumber,
      'bank': bank,
      'biller_code': billerCode,
      'deeplink_url': deeplinkUrl,
      'payment_url': paymentUrl,
      'token': token,
      'inv_id': invId,
      'expiry_time': expiryTime,
      'payment_status': status,
      'reused': reused,
    };
  }
}
