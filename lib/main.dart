import 'package:flutter/material.dart';
import 'currency_data.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange app',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _pricesCash = [];
  List _pricesCashless = [];
  int _currencyVariator = 0;
  bool _isLoading = true;

  @override
  void initState() {
    _loadPrices().then((_) => _isLoading = false);
    Future.delayed(Duration(seconds: 3), () {
      if (_pricesCash.isNotEmpty) {
        return null;
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  Future<void> _loadPrices() async {
    List pricesCash = await CurrencyData().getCurrencyData(5);
    List pricesCashless = await CurrencyData().getCurrencyData(11);
    setState(() {
      _pricesCash = pricesCash;
      _pricesCashless = pricesCashless;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('UAH Currency Rates'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                await _loadPrices();
              },
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(
                      child: _pricesCash.isEmpty ? Text('Something went wrong\n    Pull down to refresh\n\n  If you still see this text \n            try it later') : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              _pricesCash[_currencyVariator]['ccy'] +
                                  ' Cash Operationss',
                              style: kHeaderStyle),
                          Text(_pricesCash[_currencyVariator]['buy'] + ' BUY'),
                          Text(
                              _pricesCash[_currencyVariator]['sale'] + ' SELL'),
                          SizedBox(height: 16),
                          Text(_pricesCashless[_currencyVariator]['ccy'] +
                              ' Cashless Operationss', style: kHeaderStyle),
                          Text(_pricesCashless[_currencyVariator]['buy'] +
                              ' BUY'),
                          Text(_pricesCashless[_currencyVariator]['sale'] +
                              ' SELL'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Text('EUR'),
                                  onPressed: () {
                                    setState(() {
                                      _currencyVariator = 0;
                                    });
                                  }),
                              SizedBox(width: 16),
                              ElevatedButton(
                                  child: Text('USD'),
                                  onPressed: () {
                                    setState(() {
                                      _currencyVariator = 1;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
