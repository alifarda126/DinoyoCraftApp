import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.orderId,
    required super.transactionId,
    required super.referenceCode,
    required super.paymentMethod,
    required super.label,
    required super.amount,
    super.baseAmount = 0.0,
    super.serviceFee = 0.0,
    required super.totalPay,
    super.qrString,
    super.paymentUrl,
    super.token,
    super.invId,
    required super.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse('${json['order_id']}') ?? 0,
      transactionId: json['transaction_id'] is int ? json['transaction_id'] : int.tryParse('${json['transaction_id']}') ?? 0,
      referenceCode: json['reference_code']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      label: json['label']?.toString() ?? json['payment_method']?.toString() ?? 'Pembayaran',
      amount: (json['amount'] is num ? (json['amount'] as num).toDouble() : double.tryParse('${json['amount']}') ?? 0.0),
      baseAmount: (json['base_amount'] is num ? (json['base_amount'] as num).toDouble() : double.tryParse('${json['base_amount']}') ?? 0.0),
      serviceFee: (json['service_fee'] is num ? (json['service_fee'] as num).toDouble() : double.tryParse('${json['service_fee']}') ?? 0.0),
      totalPay: (json['total_pay'] is num ? (json['total_pay'] as num).toDouble() : double.tryParse('${json['total_pay']}') ?? 0.0),
      qrString: json['qr_string']?.toString(),
      paymentUrl: json['payment_url']?.toString(),
      token: json['token']?.toString(),
      invId: json['inv_id']?.toString(),
      status: json['payment_status']?.toString() ?? json['status']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'transaction_id': transactionId,
      'reference_code': referenceCode,
      'payment_method': paymentMethod,
      'label': label,
      'amount': amount,
      'base_amount': baseAmount,
      'service_fee': serviceFee,
      'total_pay': totalPay,
      'qr_string': qrString,
      'payment_url': paymentUrl,
      'token': token,
      'inv_id': invId,
      'payment_status': status,
    };
  }
}
