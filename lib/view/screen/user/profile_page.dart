import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences userdata;

  final _namalengkap = TextEditingController();
  final _nomorhp = TextEditingController();
  final _email = TextEditingController();
  final _token = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userdata = await SharedPreferences.getInstance();
    setState(() {
      _namalengkap.text = userdata.getString('nama_lengkap') ?? '';
      _nomorhp.text = userdata.getString('phonenumber') ?? '';
      _email.text = userdata.getString('email') ?? '';
      _token.text = userdata.getString('token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.lightBlue.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  backgroundColor: Colors.white70,
                  minRadius: 60.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://pbs.twimg.com/media/EwhGG0tVoAg--xv.jpg:large'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _namalengkap.text,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _email.text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '0823542376895', // Replace with user's phone number
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Social Media',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _token.text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
