import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  late Future<List<dynamic>> ordersFuture;

  final Map<String, String> statusLabels = {
    'pending': 'Sipariş Alındı',
    'preparing': 'Hazırlanıyor',
    'shipped': 'Kargoya Verildi',
    'delivered': 'Teslim Edildi',
    'cancelled': 'İptal Edildi',
  };

  @override
  void initState() {
    super.initState();
    ordersFuture = ApiService.getAllOrdersForAdmin();
  }

  void refreshOrders() {
    setState(() {
      ordersFuture = ApiService.getAllOrdersForAdmin();
    });
  }

  Future<void> changeStatus(int orderId, String newStatus) async {
    try {
      await ApiService.updateOrderStatus(
        orderId: orderId,
        orderStatus: newStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sipariş durumu güncellendi.'),
          backgroundColor: Colors.green,
        ),
      );

      refreshOrders();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color getStatusColor(String status) {
    if (status == 'pending') return Colors.orange;
    if (status == 'preparing') return Colors.blue;
    if (status == 'shipped') return Colors.purple;
    if (status == 'delivered') return Colors.green;
    if (status == 'cancelled') return Colors.red;
    return Colors.grey;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Yönetimi'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hata: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text('Henüz sipariş bulunmuyor.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              final int orderId = order['order_id'];
              final String currentStatus =
                  order['order_status']?.toString() ?? 'pending';

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sipariş #$orderId',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(currentStatus)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusLabels[currentStatus] ?? currentStatus,
                              style: TextStyle(
                                color: getStatusColor(currentStatus),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Müşteri: ${order['name'] ?? ''} ${order['surname'] ?? ''}',
                      ),
                      Text('E-posta: ${order['email'] ?? '-'}'),
                      Text('Tutar: ${order['total_amount']} TL'),
                      Text('Tarih: ${formatDate(order['order_date'])}'),
                      const SizedBox(height: 8),
                      Text(
                        'Adres: ${order['city'] ?? '-'} / ${order['district'] ?? '-'}',
                      ),
                      Text(order['full_address']?.toString() ?? '-'),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: statusLabels.containsKey(currentStatus)
                            ? currentStatus
                            : 'pending',
                        decoration: InputDecoration(
                          labelText: 'Sipariş Durumu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: statusLabels.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          changeStatus(orderId, value);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}