
import 'package:flutter/material.dart';
import 'sureekrani.dart';
import 'ayarlarekrani.dart';
import 'acilisekrani.dart';
import 'arkadasekle.dart';
import 'aliskanlikekle.dart';
import 'splash_screen.dart'; // Splash screen widget'ınızı import edin

void main() {
  runApp(RutinApp());
}

class RutinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>SplashScreen(),
        '/sureekrani': (context) => TimerPage(),
        '/ayarlarekrani': (context) => AyarlarEkrani(),
        '/acilisekrani': (context) => AcilisEkrani(),
        '/arkadasekle': (context) => FriendsPage(),
        '/aliskanlikekle': (context) => HabitScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TimerPage(),
    AyarlarEkrani(),
    AcilisEkrani(),
    FriendsPage(),
  ];

  static List<String> _titleOptions = <String>[
    'Ana Sayfa',
    'Süre Ekranı',
    'Ayarlar',
    'Açılış Ekranı',
    'Arkadaş Ekle',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleOptions[_selectedIndex]), // Set the title dynamically
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/aliskanlikekle');  // Navigate to HabitScreen
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Süre Ekranı'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Açılış Ekranı'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Arkadaş Ekle'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,  // Set color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text('Bugün', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 100,
          color: Colors.grey[300],
          margin: EdgeInsets.only(bottom: 10),
        ),
        Container(
          height: 100,
          color: Colors.grey[300],
          margin: EdgeInsets.only(bottom: 10),
        ),
        Container(
          height: 100,
          color: Colors.grey[300],
          margin: EdgeInsets.only(bottom: 10),
        ),
        Text('Tamamlanan Hedefler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 100,
          color: Colors.grey[300],
          margin: EdgeInsets.only(bottom: 10),
        ),
        Text('Tamamlanacak Hedefler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 100,
          color: Colors.grey[300],
          margin: EdgeInsets.only(bottom: 10),
        ),
      ],
    );
  }
}
