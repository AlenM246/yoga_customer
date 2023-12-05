import 'package:flutter/material.dart';

import '../helper/ApiService.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartScreen(this.cartItems);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService apiService = ApiService(); // Create an instance of ApiService
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.cartItems[index]["teacher"]),
            subtitle: Text(
              '${widget.cartItems[index]["classDay"]} at ${widget.cartItems[index]["classTime"]}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Item'),
                    content: Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.cartItems.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Checkout'),
                  content: Text('Processing... Please stay on this page!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        submitBookings();
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: Text('Checkout',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }

  void submitBookings() {

    // Extract instanceIds from cartItems
    List instanceIds = widget.cartItems.map((item) => item["instanceId"]).toList();

    // Call the ApiService to submit bookings
    apiService.submitBookings("mm3036m", instanceIds);

    // Clear the cartItems after submitting bookings
    setState(() {
      widget.cartItems.clear();
    });
  }
}
