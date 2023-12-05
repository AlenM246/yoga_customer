import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/InstanceModel.dart';

class ApiService {
  final String baseUrl = "https://stuiis.cms.gre.ac.uk/COMP1424CoreWS/comp1424cw/";

  Future<void> submitBookings(String userId, List<dynamic> instanceIds) async {
    String apiUrl = "${baseUrl}SubmitBookings";
    final Uri uri = Uri.parse(apiUrl);

    final Map<String, dynamic> requestData = {
      "userId": userId,
      "bookingList": instanceIds.map((instanceId) => {"instanceId": instanceId}).toList(),
    };

    try {

      String payload = 'jsonpayload=${Uri.encodeQueryComponent(jsonEncode(requestData))}';
      final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: payload
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Booking submitted successfully",toastLength: Toast.LENGTH_SHORT);
        print("API Response: ${response.body}");

      } else {
        Fluttertoast.showToast(msg: "Error submitting booking. Status code: ${response.statusCode}",toastLength: Toast.LENGTH_SHORT);
        print("Error Response: ${response.body}");

      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error submitting booking: $error",toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<List<InstanceModel>> getInstances(String userId) async {
    String apiUrl = "${baseUrl}GetInstances";
    final Uri uri = Uri.parse(apiUrl);

    final Map<String, String> requestData = {
      'userid': userId,
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<InstanceModel> instances = jsonList.map((json) => InstanceModel.fromJson(json)).toList();

        return instances;
      } else {
        print("Error getting instances. Status code: ${response.statusCode}");
        return [];
      }
    } catch (error) {
      print("Error getting instances: $error");
      return [];
    }
  }
}