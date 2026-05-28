import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/order_model.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişlerim'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<OrderModel>>(
          valueListenable: AppConstants.ordersNotifier,
          builder: (context, siparisListesi, child) {
            if (siparisListesi.isEmpty) {
              return const Center(
                child: Text('Henüz bir siparişiniz bulunmuyor.', style: TextStyle(color: Colors.grey)),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: siparisListesi.length,
              itemBuilder: (context, index) {
                final order = siparisListesi[index];
                return _buildOrderCard(order);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    // Duruma göre renk belirleme
    Color statusColor = Colors.orange;
    if (order.orderStatus == 'Teslim Edildi') statusColor = Colors.green;
    if (order.orderStatus == 'Yolda') statusColor = Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sipariş No: #${order.orderId}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.orderStatus,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tarih: ${order.orderDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                'Tutar: ${order.totalAmount.toStringAsFixed(0)} TL',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}