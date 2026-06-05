import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late Future<List<dynamic>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = ApiService.getOrders();
  }

  void refreshOrders() {
    setState(() {
      ordersFuture = ApiService.getOrders();
    });
  }

  Color getStatusColor(String status) {
  if (status == 'pending') {
    return Colors.orange;
  }

  if (status == 'preparing') {
    return Colors.blue;
  }

  if (status == 'shipped') {
    return Colors.purple;
  }

  if (status == 'delivered') {
    return Colors.green;
  }

  if (status == 'cancelled') {
    return Colors.red;
  }

  return Colors.grey;
}

String getStatusText(String? status) {
  switch (status) {
    case 'pending':
      return 'Sipariş alındı';
    case 'preparing':
      return 'Hazırlanıyor';
    case 'shipped':
      return 'Kargoya verildi';
    case 'delivered':
      return 'Teslim edildi';
    case 'cancelled':
      return 'İptal edildi';
    default:
      return 'Durum bilinmiyor';
  }
}

  String formatDate(dynamic rawDate) {
    if (rawDate == null) return '-';

    try {
      final date = DateTime.parse(rawDate.toString());
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (_) {
      return rawDate.toString();
    }
  }

  double parseAmount(dynamic value) {
    return double.tryParse(value.toString()) ?? 0;
  }

  Future<void> openOrderDetail(BuildContext context, int orderId) async {
    try {
      final detail = await ApiService.getOrderDetail(orderId: orderId);

      if (!context.mounted) return;

      final List<dynamic> items = detail['items'] ?? [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      'Sipariş Detayı #$orderId',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (items.isEmpty)
                      const Text(
                        'Bu sipariş için ürün detayı bulunamadı.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ...items.map((item) {
                        final productName = item['product_name']?.toString() ?? 'Ürün';
                        final quantity = item['quantity']?.toString() ?? '1';
                        final quantityNumber = int.tryParse(quantity) ?? 1;
                        final price = parseAmount(item['price']);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '$quantity adet',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(price * quantityNumber).toStringAsFixed(0)} TL',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişlerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshOrders,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final orders = snapshot.data ?? [];

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  'Henüz bir siparişiniz bulunmuyor.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final int orderId = int.tryParse(order['order_id'].toString()) ?? 0;
    final String status = order['order_status']?.toString() ?? 'pending';
    final Color statusColor = getStatusColor(status);
    final double totalAmount = parseAmount(order['total_amount']);
    final String orderDate = formatDate(order['order_date']);

    return InkWell(
      onTap: () => openOrderDetail(context, orderId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sipariş No: #$orderId',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    getStatusText(status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
                  'Tarih: $orderDate',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  'Tutar: ${totalAmount.toStringAsFixed(0)} TL',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Detay için dokun',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}