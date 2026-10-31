class Payment {
  final int orderId;
  final int transactionId;
  final String referenceCode;
  final String paymentMethod;
  final String label;
  final double amount;
  final double baseAmount;
  final double serviceFee;
  final double totalPay;
  final String? qrString;
  final String? paymentUrl;
  final String? token;
  final String? invId;
  final String status;

  const Payment({
    required this.orderId,
    required this.transactionId,
    required this.referenceCode,
    required this.paymentMethod,
    required this.label,
    required this.amount,
    this.baseAmount = 0.0,
    this.serviceFee = 0.0,
    required this.totalPay,
    this.qrString,
    this.paymentUrl,
    this.token,
    this.invId,
    required this.status,
  });

  bool get isPaid => status == 'paid' || status == 'success';
}
