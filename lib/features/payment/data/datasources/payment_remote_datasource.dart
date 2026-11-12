import '../../../../core/network/api_client.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDatasource {
  Future<PaymentModel> createOrderPayment({
    required int orderId,
    String paymentMethod = 'qris',
  });

  Future<Map<String, dynamic>> checkPaymentStatus(int orderId);

  Future<Map<String, dynamic>> getPaymentConfig();

  Future<List<Map<String, dynamic>>> getPaymentMethods([String? token]);

  Future<Map<String, dynamic>> cancelPayment(int orderId);
}

class PaymentRemoteDatasourceImpl implements PaymentRemoteDatasource {
  @override
  Future<PaymentModel> createOrderPayment({
    required int orderId,
    String paymentMethod = 'qris',
  }) async {
    final response = await ApiClient.post('/payments/create', {
      'order_id': orderId,
      'payment_method': paymentMethod,
    });

    final data = response['data'] as Map<String, dynamic>;
    return PaymentModel.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> checkPaymentStatus(int orderId) async {
    final response = await ApiClient.get('/payments/status/$orderId');
    return response['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getPaymentConfig() async {
    final response = await ApiClient.get('/payments/methods');
    return (response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods([String? token]) async {
    final data = await getPaymentConfig();
    final methods = data['methods'] as List<dynamic>? ?? [];
    return methods.whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<Map<String, dynamic>> cancelPayment(int orderId) async {
    final response = await ApiClient.post('/payments/cancel/$orderId', {});
    return (response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  }
}
