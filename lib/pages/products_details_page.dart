import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshopping/pages/products.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  // final Quantity = TextEditingController();

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedQuantity = 1;
  bool _isOrderPlaced = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.ProductName),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'lib/assets/products.png',
                width: 300.0,
                height: 300.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
            // SizedBox(height: 16.0),
            // Text(
            //   'Description:',
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 8.0),
            Text(widget.product.ProductName),
            Text(
              'Select the quantity to be ordered.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 16.0),
                ),
                //Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (selectedQuantity > 1) {
                          setState(() {
                            selectedQuantity--;
                          });
                        }
                      },
                    ),
                    Text('$selectedQuantity'),
                    Text(
                      ' / ${widget.product.Quantity}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (selectedQuantity < widget.product.Quantity) {
                          setState(() {
                            selectedQuantity++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Maximum quantity reached: ${widget.product.Quantity}',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isOrderPlaced
                  ? null
                  : () async {
                      if (selectedQuantity > widget.product.Quantity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Quantity exceeded! Available quantity: ${widget.product.Quantity}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final response = await http.post(
                        Uri.parse(
                            'https://uiexercise.theproindia.com/api/Order/AddOrder'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8'
                        },
                        body: jsonEncode(<String, dynamic>{
                          "customerId": "d9d30672-54f3-44d7-146a-08dc44b61636",
                          "productId": widget.product.ProductId,
                          "quantity": selectedQuantity,
                        }),
                      );

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        setState(() {
                          _isOrderPlaced = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order placed successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order placement failed!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              child: Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:onlineshopping/pages/products.dart';

// class ProductDetailsPage extends StatefulWidget {
//   final Product product;

//   const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   int selectedQuantity = 1; // Initial selected quantity

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.productName),
//         backgroundColor: Colors.teal, // Apply accent color (optional)
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image placeholder
//             Center(
//               child: Container(
//                 width: 300.0,
//                 height: 300.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: Colors.grey.shade200, // Light grey placeholder color
//                   // child: Container(
//                   //   child: Text(
//                   //     "Image Placeholder",
//                   //     style: TextStyle(color: Colors.grey),
//                   //   ),
//                   // ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0), // Add some spacing
//             Text(
//               'Description:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               // You can add a longer description from your API data here
//               'This is a description for the product.',
//               textAlign:
//                   TextAlign.justify, // Justify text for better readability
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Text(
//                   'Quantity:',
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//                 Spacer(),
//                 Row(
//                   mainAxisSize: MainAxisSize.min, // Compact quantity selection
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         if (selectedQuantity > 1) {
//                           setState(() {
//                             selectedQuantity--;
//                           });
//                         }
//                       },
//                     ),
//                     Text('$selectedQuantity'),
//                     Text(
//                       ' / ${widget.product.quantity}', // Display product quantity
//                       style: TextStyle(
//                           fontSize: 16.0), // Adjust font size as needed
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         // Replace with your logic to check available quantity
//                         // (e.g., from product.availableQuantity)
//                         setState(() {
//                           if (selectedQuantity < widget.product.quantity) {
//                             selectedQuantity++;
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   'Maximum quantity reached: ${widget.product.quantity}',
//                                 ),
//                                 backgroundColor: Colors.orange,
//                               ),
//                             );
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedQuantity > widget.product.quantity) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                           'Quantity exceeded! Available quantity: ${widget.product.quantity}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 } else {
//                   // Implement purchase logic (e.g., add to cart, navigate to checkout)
//                   print(
//                       'Buy Now button pressed with quantity: $selectedQuantity');
//                   // You can navigate to a new page for order details here
//                 }
//               },
//               child: Text('Buy Now'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor:
//                     Colors.teal, // Use accent color for button (optional)
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
