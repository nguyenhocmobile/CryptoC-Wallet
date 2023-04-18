import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tradexpro_flutter/ui/features/home/my_portfolios.dart';
import 'package:tradexpro_flutter/ui/features/home/my_portfolios_item.dart';
import 'package:tradexpro_flutter/ui/features/home/slider_item.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tradexpro_flutter/ui/features/home/system_function.dart';

import '../../../data/models/coin_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  void _onSearchTextChanged(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    return await Provider.of<Coins>(context, listen: false).fetchAndSetCoins();
  }

  @override
  void initState() {
    Timer.periodic(
      const Duration(seconds: 5),
      ((timer) {
        Provider.of<Coins>(context, listen: false)
            .fetchAndSetCoins()
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Coins>(context, listen: false).fetchAndSetCoins().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final coinData = Provider.of<Coins>(context, listen: false).coins;
    final double widthSliderItem = MediaQuery.of(context).size.width - 100;
    const double heightSliderItem = 130;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://ss-images.saostar.vn/wp700/pc/1613810558698/Facebook-Avatar_3.png'),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 50,
              ),
              height: 40,
              width: MediaQuery.of(context).size.width - 40 - 20 - 100 - 10,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(50, 50, 50, 50),
                  ),
                  fillColor: Colors.black,
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchText = "";
                        _searchController.clear();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        actions: const [
          Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SliderItem(),
                SizedBox(
                  width: 20,
                ),
                SliderItem(),
                SizedBox(
                  width: 20,
                ),
                SliderItem(),
              ],
            ),
          ),
          const SystemFunction(),
          MyPortfolios(
            isLoading: _isLoading,
            coinData: coinData,
          ),
        ],
      ),
    );
  }
}
