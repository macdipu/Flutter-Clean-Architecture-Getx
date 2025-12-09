import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entity/trade_item.dart';
import '../controller/trades_screen_controller.dart';

class TradesScreen extends StatefulWidget {
  const TradesScreen({super.key});

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  final TradesScreenController _controller = Get.put(TradesScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _controller.getData,
          child: Obx(
            () {
              if (_controller.trades.isEmpty) {
                if (_controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                return LayoutBuilder(builder: (context, box) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      alignment: Alignment.center,
                      child: const Text('No data found'),
                    ),
                  );
                });
              }

              return _List();
            },
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  _List();

  final TradesScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<TradeItem> trades = _controller.trades;
    return ListView.builder(
      itemCount: trades.length,
      itemBuilder: (context, index) => _ListTile(item: trades[index]),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.item});
  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Column(
          children: [
            Text("Name:${item.name}"),
            const SizedBox(height: 2),
            Text("Selling Price: ${item.estimateSellingPrice}"),
            const SizedBox(height: 2),
            Text("Buying Price: ${item.estimateBuyingPrice}")
          ],
        ),
      ),
    );
  }
}
