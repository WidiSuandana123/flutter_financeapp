import 'package:flutter/material.dart';
import 'package:flutter_financeapp/pages/bitcoin_wallet_page.dart' as bwp;
import 'package:flutter_financeapp/pages/etherium_wallet_page.dart' as ewp;
import 'package:flutter_financeapp/screens/news_screen.dart';
import 'package:flutter_financeapp/helpers/dbhelper.dart';

import '../dto/wallet_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final dbHelper = DatabaseHelper.instance;
  late Future<List<Wallet>> _wallets;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Jumlah tab menjadi 2
    _loadWallets();
  }

  void _loadWallets() {
    _wallets = dbHelper.getWallets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.account_balance_wallet), text: ''), // Ganti teks 'Balance' dengan ikon
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Widi_4A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Ethereum Wallet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ewp.EthereumWalletPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Bitcoin Wallet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bwp.BitcoinWalletPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Fetch Data'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewScreen()),
                );
              },
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BalanceTab(),
          ProfileTab(),
        ],
      ),
    );
  }
}

class BalanceTab extends StatelessWidget {
  const BalanceTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ewp.EthereumWalletPage()),
              );
            },
            icon: Icon(Icons.account_balance_wallet, size: 36),
            label: Text('Ethereum Wallet', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 24.0),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => bwp.BitcoinWalletPage()),
              );
            },
            icon: Icon(Icons.account_balance_wallet, size: 36),
            label: Text('Bitcoin Wallet', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final dbHelper = DatabaseHelper.instance;
  late String _username = '';
  late String _email = '';
  late String _bio = '';

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    var profile = await dbHelper.getProfile();
    setState(() {
      _username = profile != null ? profile['username'] ?? '' : '';
      _email = profile != null ? profile['email'] ?? '' : '';
      _bio = profile != null ? profile['bio'] ?? '' : '';
      _usernameController.text = _username;
      _emailController.text = _email;
      _bioController.text = _bio;
    });
  }

  void _saveProfile() async {
    final profile = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
    };
    await dbHelper.updateProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Bio',
),
),
const SizedBox(height: 16.0),
ElevatedButton(
onPressed: _saveProfile,
child: const Text('Save'),
),
],
),
);
}
}