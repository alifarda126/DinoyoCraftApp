class Payment {
  final int orderId;
  final int transactionId;
  final String referenceCode;
  final String gateway;
  final String? gatewayOrderId;
  final String paymentMethod;
  final String? paymentType;
  final String label;
  final double amount;
  final double baseAmount;
  final double serviceFee;
  final double channelFee;
  final double totalPay;
  final String? qrString;
  final String? qrImageUrl;
  final String? vaNumber;
  final String? bank;
  final String? billerCode;
  final String? deeplinkUrl;
  final String? paymentUrl;
  final String? token;
  final String? invId;
  final String? expiryTime;
  final String status;
  final bool reused;

  const Payment({
    required this.orderId,
    required this.transactionId,
    required this.referenceCode,
    this.gateway = 'midtrans',
    this.gatewayOrderId,
    required this.paymentMethod,
    this.paymentType,
    required this.label,
    required this.amount,
    this.baseAmount = 0.0,
    this.serviceFee = 0.0,
    this.channelFee = 0.0,
    required this.totalPay,
    this.qrString,
    this.qrImageUrl,
    this.vaNumber,
    this.bank,
    this.billerCode,
    this.deeplinkUrl,
    this.paymentUrl,
    this.token,
    this.invId,
    this.expiryTime,
    required this.status,
    this.reused = false,
  });

  bool get isPaid => status == 'paid' || status == 'success';
  bool get isTerminal =>
      status == 'expired' || status == 'cancelled' || status == 'failed';

  DateTime? get expiryDateTime =>
      expiryTime == null || expiryTime!.isEmpty
          ? null
          : DateTime.tryParse(expiryTime!);
}
