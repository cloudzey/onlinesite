class OrderModel {
  final int orderId;
  final String orderStatus; // Örn: 'Hazırlanıyor', 'Yolda', 'Teslim Edildi'
  final String orderDate;
  final double totalAmount;

  OrderModel({
    required this.orderId,
    required this.orderStatus,
    required this.orderDate,
    required this.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      orderStatus: json['order_status'] ?? 'Onay bekliyor',
      orderDate: json['order_date'] ?? '',
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_status': orderStatus,
      'order_date': orderDate,
      'total_amount': totalAmount,
    };
  }
}