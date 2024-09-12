import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _price = '0.00';
  String _selectedCurrency = 'BRL';

  static const List<String> _currencies = ["BRL", "USD", "EUR"];

  _getPrice() async {
    final url = Uri.parse('https://blockchain.info/ticker');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final price = data[_selectedCurrency]['buy'].toString();
      String formattedPrice;
      switch (_selectedCurrency) {
        case 'USD':
          formattedPrice = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.parse(price));
          break;
        case 'EUR':
          formattedPrice = NumberFormat.currency(locale: 'de_DE', symbol: '€').format(double.parse(price));
          break;
        case 'BRL':
        default:
          formattedPrice = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(price));
          break;
      }
      setState(() {
        _price = formattedPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/bitcoin.png')),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                _price,
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _currencies.map((String currency) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[200],
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCurrency = currency;
                        _getPrice();
                      });
                    },
                    child: Text(currency),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
