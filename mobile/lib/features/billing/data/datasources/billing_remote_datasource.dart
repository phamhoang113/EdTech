import '../../../../core/network/dio_client.dart';
import '../../domain/entities/billing_detail_entity.dart';

abstract class BillingDataSource {
  /// Lấy tất cả hóa đơn của PH.
  Future<List<BillingDetailEntity>> getBillings();

  /// PH xác nhận đã chuyển khoản.
  Future<void> confirmTransfer(String billingId);
}

class BillingRemoteDataSource implements BillingDataSource {
  final DioClient _dioClient;

  BillingRemoteDataSource(this._dioClient);

  @override
  Future<List<BillingDetailEntity>> getBillings() async {
    final response = await _dioClient.dio.get('/api/v1/parents/billings');
    final rawData = response.data;
    final List<dynamic> data;
    if (rawData is Map && rawData['data'] is List) {
      data = rawData['data'] as List;
    } else if (rawData is List) {
      data = rawData;
    } else {
      data = [];
    }
    return data
        .map((e) => BillingDetailEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> confirmTransfer(String billingId) async {
    await _dioClient.dio.post('/api/v1/parents/billings/$billingId/confirm');
  }
}
