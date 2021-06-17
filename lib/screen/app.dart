import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/screen/account.dart';
import 'package:creamee/screen/home.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/screen/order-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  PageController _pageController = PageController();
  UserProvider userProvider;
  List<Widget> _screen = [
    Home(),
    OrderList(),
    Account(),
  ];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    if (!userProvider.userloggedin()) {
      if (index == 1) {
        _screen[1] = Login(topage: "order-list");
      } else if (index == 2) {
        _screen[2] = Login(topage: "account");
      }
    } else {
      _screen[1] = OrderList();
      _screen[2] = Account();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _itemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {
    // _loadUserData();
    super.initState();
  }

  // _loadUserData() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var user = jsonDecode(localStorage.getString('user'));

  //   if (user != null) {
  //     setState(() {
  //       name = user['name'];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _itemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent[700],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
