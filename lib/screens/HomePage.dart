
import 'package:flutter/material.dart';

import '../helper/ApiService.dart';
import '../model/InstanceModel.dart';
import 'CartScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, dynamic>> apiData = [];

  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> shoppingCart = [];
  String searchDay = "";
  String searchTime = "";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int cartItemCount=0;

  @override
  void initState() {
    super.initState();
    loadApiData();
  }

  void filterData() {
    // Clear previous filtered data
    try {
      filteredData.clear();

      if (searchDay.isEmpty && searchTime.isEmpty) {
        filteredData.addAll(apiData);
      }

      // Filter data based on search criteria

      if(searchDay.length >2 && searchTime.length > 2) {
        filteredData.addAll(apiData.where((item) {
          bool dayMatch = item["classDay"].toLowerCase().contains(
              searchDay.toLowerCase());
          bool timeMatch = item["classTime"].toLowerCase().contains(
              searchTime.toLowerCase());
          return dayMatch || timeMatch;
        }));
      }
      else if(searchDay.length >2){
        filteredData.addAll(apiData.where((item) {
          bool dayMatch = item["classDay"].toLowerCase().contains(
              searchDay.toLowerCase());
          return dayMatch;
        }));
      }else if(searchTime.length >2 ){
        filteredData.addAll(apiData.where((item) {
          bool timeMatch = item["classTime"].toLowerCase().contains(
              searchTime.toLowerCase());
          return  timeMatch;
        }));
      }
      // Update the UI
      setState(() {});
    }  catch (e) {
      print(e.toString());
    }
  }

  void updateAppBar() {
    // Calculate the total number of items in the cart

    setState(() {
      cartItemCount = shoppingCart.length;
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,size: 40,),
                onPressed: () {
                  // Open the cart screen when the cart icon is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen(shoppingCart)),
                  );
                },
              ),
              // Display the cart item count
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    cartItemCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchDay = value;
                      filterData();
                    },
                    decoration: InputDecoration(labelText: 'Search by Day'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchTime = value;
                      filterData();
                    },
                    decoration: InputDecoration(labelText: 'Search by Time'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(filteredData[index]["teacher"]),
                    subtitle: Text(
                      '${filteredData[index]["classDay"]} at ${filteredData[index]["classTime"]}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        addToCart(filteredData[index]);
                      },
                    )
                );
              },
            ),
          ),
        ],
      ),

    );
  }
  void addToCart(Map<String, dynamic> item) {
    shoppingCart.add(item);
    updateAppBar();
  }

  Future<void> loadApiData() async {
    String userId = 'mm3036m';
    List<InstanceModel> instances = await ApiService().getInstances(userId);
    apiData = instances.map((instance) => instance.toJson()).toList();

    setState(() {
      filteredData = List.from(apiData);
    });
  }

}