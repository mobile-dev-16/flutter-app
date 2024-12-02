import 'package:eco_bites/features/support/presentation/widgets/ticket_form.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _showOptions(BuildContext context, String category, List<String> options) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((String option) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(option),
                        onTap: () {
                          Navigator.pop(context);
                          _showTicketForm(context, category, option);
                        },
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _showTicketForm(BuildContext context, String category, String subOption) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text('Submit Ticket'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: TicketForm(category: category, subOption: subOption),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Request'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Order Management'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'Order Management', <String>[
                        'Track Order',
                        'Cancel Order',
                        'Return Order',
                        'Order History',
                      ]);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Payment Management'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'Payment Management', <String>[
                        'Payment Methods',
                        'Refund Status',
                        'Payment Issues',
                        'Billing History',
                      ]);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Account and Profile Management'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'Account and Profile Management', <String>[
                        'Update Profile',
                        'Change Password',
                        'Privacy Settings',
                        'Delete Account',
                      ]);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About EcoBites'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'About EcoBites', <String>[
                        'Company Information',
                        'Terms of Service',
                        'Privacy Policy',
                        'Contact Us',
                      ]);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'Security', <String>[
                        'Report a Security Issue',
                        'Account Security Tips',
                        'Two-Factor Authentication',
                        'Security Updates',
                      ]);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Message History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showOptions(context, 'Message History', <String>[
                        'View Messages',
                        'Delete Messages',
                        'Archive Messages',
                        'Message Settings',
                      ]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
