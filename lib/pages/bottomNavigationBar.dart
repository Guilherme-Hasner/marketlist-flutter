// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:marketlist/pages/market_list.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late String? _tabSelected;
  int _selectedIndex = 1;

  Future<void> getInitialPageState() async {
    _tabSelected = await NavigationStateSharedPreferences.getPageState();
    if (_tabSelected == 'list') {
      _selectedIndex = 1;
    } else {
      setState(() {
        // Remover setState
        _selectedIndex = 0;
      });
    }
  }

  Future<void> setPageState(int index) async {
    switch (index) {
      case 0:
        await NavigationStateSharedPreferences.savePageState("products");
        PreviousPageRedirect.redirectProductPage(context);
        break;
      case 1:
        await NavigationStateSharedPreferences.savePageState("list");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MarketListScreen()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialPageState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          // Remover setState
          _selectedIndex = index;
          setPageState(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/bens-de-consumo.png'),
          label: "Produtos",
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/lista.png'),
          label: "Lista de Compras",
        ),
      ],
    );
  }
}
