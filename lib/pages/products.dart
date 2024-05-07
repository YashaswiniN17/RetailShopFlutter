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
  List<Product> filteredProducts = [];
  final Color backgroundColor = Colors.purpleAccent.shade100;
  final Color cardColor = Colors.white;
  final Color primaryColor = Colors.teal;

  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_searchProducts);
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://uiexercise.theproindia.com/api/Product/GetAllProduct'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        products =
            (data as List).map((item) => Product.fromJson(item)).toList();
        filteredProducts = List.from(products);
      });
    } else {
      print('Error fetching products');
    }
  }

  void _searchProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product.ProductName.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        filteredProducts = List.from(products);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              )
            : Text('Products'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            color: Colors.white,
            onPressed: _toggleSearch,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ),
                ).then((value) {
                  _fetchProducts();
                });
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
                        child: Image.asset(
                          'lib/assets/products.png',
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.error)),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${product.ProductName}      Quantity:${product.Quantity}",
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
  final String ProductId;
  final String ProductName;
  final int Quantity;
  final bool IsActive;

  Product({
    required this.ProductId,
    required this.ProductName,
    required this.Quantity,
    required this.IsActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ProductName: json['ProductName'] ?? '',
      Quantity: json['Quantity'] ?? 0,
      ProductId: json['ProductId'] ?? '',
      IsActive: json['IsActive'] ?? false,
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
