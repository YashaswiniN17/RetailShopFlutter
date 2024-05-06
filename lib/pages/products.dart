import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshopping/pages/add_product_page.dart';
import 'package:onlineshopping/pages/products_details_page.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  final Color backgroundColor = Colors.purpleAccent.shade100;
  final Color cardColor = Colors.white;
  final Color primaryColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://localhost:44301/api/Product/GetAllProducts'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        products =
            (data as List).map((item) => Product.fromJson(item)).toList();
      });
    } else {
      print('Error fetching products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2.0,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'lib/assets/products.png',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18.0,
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsPage(
                                                product: product),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.shopping_bag, size: 18.0),
                                  label: Text('Purchase'),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Product {
  //final String productId;
  final String productName;
  final int quantity;
  //final bool IsActive;

  Product({
    //required this.productId,
    required this.productName,
    required this.quantity,
    //required this.IsActive
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      //productId: json['productId'],
      //IsActive: json['IsActive'],
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ProductsPage extends StatefulWidget {
//   @override
//   _ProductsPageState createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   List<Product> products = []; // List to store fetched products
//   final Color backgroundColor = Colors.purpleAccent; // Light teal background
//   final Color cardColor = Colors.white;
//   final Color primaryColor = Colors.teal; // Teal accent color

//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts(); // Call API on page load
//   }

//   Future<void> _fetchProducts() async {
//     // Replace with your actual API endpoint
//     final response = await http
//         .get(Uri.parse('https://localhost:44301/api/Product/GetAllProducts'));

//     if (response.statusCode == 200) {
//       // Parse JSON response
//       final data = jsonDecode(response.body);
//       setState(() {
//         products =
//             (data as List).map((item) => Product.fromJson(item)).toList();
//       });
//     } else {
//       // Handle API errors
//       print('Error fetching products');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//         backgroundColor: primaryColor,
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return Container(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/pro.jpg', // Placeholder image
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10.0, // Position product name at bottom
//                   left: 10.0,
//                   child: Text(
//                     product.productName,
//                     style: TextStyle(
//                       color: primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class Product {
//   // Model for product data with adjusted fields
//   final String productName;
//   final int quantity;

//   Product({required this.productName, required this.quantity});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productName: json['productName'] ?? '',
//       quantity: json['quantity'] ?? 0,
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ProductsPage extends StatefulWidget {
//   @override
//   _ProductsPageState createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   List<Product> products = [];

//   final Color backgroundColor = Colors.blueGrey.shade100;
//   final Color cardColor = Colors.white;
//   final Color textColor = Colors.black87;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts();
//   }

//   Future<void> _fetchProducts() async {
//     final response = await http
//         .get(Uri.parse('https://localhost:44301/api/Product/GetAllProducts'));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         products =
//             (data as List).map((item) => Product.fromJson(item)).toList();
//       });
//     } else {
//       print('Error fetching products');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//       ),
      // body: ListView.builder(
      //   itemCount: products.length,
      //   itemBuilder: (context, index) {
      //     final product = products[index];
      //     return Card(
      //       child: ListTile(
      //         title: Text(product.productName),
      //         subtitle: Text('Quantity: ${product.quantity}'),
      //       ),
      //     );
      //   },
      // ),
//     );
//   }
// }

// class Product {
//   final String productName;
//   final int quantity;

//   Product({required this.productName, required this.quantity});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productName: json['productName'] ?? '',
//       quantity: json['quantity'] ?? '',
//     );
//   }
// }
