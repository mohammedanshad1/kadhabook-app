import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kadhabook/constants/app_typography.dart';
import 'package:kadhabook/model/model.dart';
import 'package:kadhabook/view/login_view.dart';
import 'package:kadhabook/viewmodel/login_viewmodel.dart';
import 'package:kadhabook/widgets/custom_button.dart';
import 'package:provider/provider.dart';

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
          title: Text('Enter $type Amount', style: AppTypography.outfitMedium),
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
                    SnackBar(
                      content: Text("Please enter a valid amount",
                          style: AppTypography.outfitRegular),
                      backgroundColor: Colors.red,
                    ),
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
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: AppTypography.outfitBold),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: HexColor("303050"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.userId,
                      style: AppTypography.outfitRegular.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Home", style: AppTypography.outfitRegular),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Settings", style: AppTypography.outfitRegular),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              title: const Text("Logout", style: AppTypography.outfitRegular),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await loginViewModel.logout(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text('${transaction.type}: ${transaction.amount}',
                      style: AppTypography.outfitRegular),
                  subtitle: Text('${transaction.date}',
                      style: AppTypography.outfitLight),
                  trailing: Text(transaction.description,
                      style: AppTypography.outfitRegular),
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
                  buttonColor: Colors.green,
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
