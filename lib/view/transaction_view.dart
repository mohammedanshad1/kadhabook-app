import 'package:flutter/material.dart';
import 'package:kadhabook/model/model.dart';
import 'package:kadhabook/view/login_view.dart';
import 'package:kadhabook/widgets/custom_button.dart';

class TransactionAddingView extends StatefulWidget {
  final String userId;

  TransactionAddingView({required this.userId});

  @override
  _TransactionAddingViewState createState() => _TransactionAddingViewState();
}

class _TransactionAddingViewState extends State<TransactionAddingView> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final records = await pb
          .collection('Transactions_Collection')
          .getList(filter: 'user_id = "${widget.userId}"');
      setState(() {
        transactions = records.items
            .map((item) => Transaction.fromMap(item.data))
            .toList();
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Future<void> _addTransaction(
      String type, double amount, String description) async {
    final body = <String, dynamic>{
      "user_id": widget.userId,
      "amount": amount,
      "type": type,
      "date": DateTime.now().toUtc().toString(),
      "description": description,
    };

    try {
      await pb.collection('Transactions_Collection').create(body: body);
      _fetchTransactions(); // Refresh transaction list
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  void _showTransactionDialog(String type) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter $type Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            CustomButton(
              buttonName: "Cancel",
              onTap: () {
                Navigator.of(context).pop();
              },
              buttonColor: Colors.red,
              height: 40,
              width: 80,
            ),
            CustomButton(
              buttonName: "Submit",
              onTap: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                final description = descriptionController.text;

                if (amount > 0) {
                  _addTransaction(type, amount, description);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid amount")),
                  );
                }
              },
              buttonColor: Colors.green,
              height: 40,
              width: 80,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text('${transaction.type}: ${transaction.amount}'),
                  subtitle: Text('${transaction.date}'),
                  trailing: Text(transaction.description),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  buttonName: "Add Cash In",
                  onTap: () => _showTransactionDialog("cash in"),
                  buttonColor: Colors.blue,
                  height: 40,
                  width: 150,
                ),
                CustomButton(
                  buttonName: "Add Cash Out",
                  onTap: () => _showTransactionDialog("cash out"),
                  buttonColor: Colors.red,
                  height: 40,
                  width: 150,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
