import 'package:flutter/material.dart';
import 'package:onlineshopping/pages/add_product_page.dart';
import 'package:onlineshopping/pages/products.dart';
import 'package:onlineshopping/pages/products_details_page.dart';
import 'package:provider/provider.dart';
//import 'package:onlineshopping/pages/home_page.dart';
import 'package:onlineshopping/themes/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/productList': (context) => ProductsPage(),
        '/productsDetails': (context) => ProductDetailsPage(
            product: Product(
                IsActive: true, ProductId: "", ProductName: "", Quantity: 2)),
        '/addProducts': (context) => AddProductPage(),
      },
    );
  }
}
