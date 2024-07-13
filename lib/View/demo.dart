// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class InstamojoScreen extends StatefulWidget {
//   final CreateOrderBody? body;
//   final String? orderCreationUrl;
//   final bool? isLive;

//   const InstamojoScreen(
//       {Key? key, this.body, this.orderCreationUrl, this.isLive = false})
//       : super(key: key);

//   @override
//   _InstamojoScreenState createState() => _InstamojoScreenState();
// }

// class _InstamojoScreenState extends State<InstamojoScreen> {


// TextEditingController textController = TextEditingController();

// bool isLoading=false;

// List details=[];

  
// Future fetchUserDetailsUsingUPIID(String upiId) async {
//   var url = Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay');
  
//   var requestBody = {
//     'vpa': upiId,
//     'tid': 'txn001', // Replace with your unique transaction ID
//     'am': '10.00', // Optional: Replace with the amount for the transaction
//   };
  
//   var response = await http.post(url, body: requestBody);
  
//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
    
//     // Retrieve the user details from the response
//     var userDetails = data['transaction']['sub'];
    
//     // Process and use the user details as required
//     var name = userDetails['name'];
//     var phone = userDetails['mobileNo'];
//     var email = userDetails['email'];
    
//     print('Name: $name, Phone: $phone, Email: $email');

//     details.add(name);
//     details.add(phone);
//     details.add(email);
//     setState(() {});
//   } else {
    
//     print('Failed to fetch user details. Error: ${response.statusCode}');
//     return [ ];
//   }
// }

// String paymentLink =  "upi://pay?pa=7905879582@paytm&pn=Ritik%20Rai&mc=123456&tid=txn001&tr=ref001&tn=Test%20Payment&am=10.00&cu=INR";

//   @override
//   void initState() {
//     urls();
//     super.initState();
//   }
  

//   void urls()async{
//   if (await canLaunchUrl(Uri.parse(paymentLink))) {
//       await launchUrl(Uri.parse(paymentLink));
//     } else {
//       throw 'Could not launch UPI app.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Instamojo Flutter',style: TextStyle(color: Colors.black)),
//         ),
//         body: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
              
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25,vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Add UPI Id',style: Theme.of(context).textTheme.titleMedium),
//                       SizedBox(height: 12),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(child: TextFormField(
//                               controller: textController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter UPI id',
//                                   hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w400
//                                   ),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       width: 1,color: Colors.grey
//                                     ),
//                                     borderRadius: BorderRadius.circular(12)
//                                   )
//                                 ),
//                             )),
//                             SizedBox(width: 12),
//                              ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 14,horizontal: 20),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)
//                                 )
//                               ),
//                               onPressed: () async{
//                                  isLoading=true;
//                                 setState(() {});
//                                await fetchUserDetailsUsingUPIID(textController.text).then((value) {
//                                 isLoading=false;
//                                 setState(() {});
//                               });
//                             }, child: isLoading ? CircularProgressIndicator() : 
//                               Text('Verfiy',style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.4
//                             ),))
//                           ],
//                         ),
//                       ),
//                       details.isNotEmpty && isLoading==false ? Container(
                        
//                         height: 200,
//                         child: Column(
//                           children: [
//                               Text('Name :'+details[0]),
//                               SizedBox(height: 8),
//                               Text('Email :'+details[1]),
//                               SizedBox(height: 8),
//                               Text('Phone :'+details[2]),
//                           ],
//                         ),
//                       ): Text('')
//                     ],
//                   ),
//                 ),
//                 YourWidget()
//               ],
//             )));
//   }

//   @override
//   void paymentStatus({Map<String, String>? status}) {
//     Navigator.pop(context, status);
//   }
  
// }


// class YourWidget extends StatefulWidget {
//   @override
//   _YourWidgetState createState() => _YourWidgetState();
// }

// class _YourWidgetState extends State<YourWidget> {
//   final MethodChannel _methodChannel = MethodChannel('upi_apps');
//   List<Map<String, String>> _upiApps = [];

//   @override
//   void initState() {
//     super.initState();
//     _methodChannel.setMethodCallHandler(_handleMethodCall);
//   }

//   Future<dynamic> _handleMethodCall(MethodCall call) async {
//     if (call.method == 'updateUPIAppsList') {
//       setState(() {
//         _upiApps = List<Map<String, String>>.from(call.arguments);
//       });
//     }

//     print('data values');
//     print(_upiApps.length);
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(_upiApps.length);
//     // Use the _upiApps list to access the retrieved UPI app details
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: 300,
//       child: ListView.builder(
//         itemCount: _upiApps.length,
//         itemBuilder: (context, index) {
//           final appName = _upiApps[index]['app_name'];
//           final packageName = _upiApps[index]['package'];
//           debugPrint(appName);
    
//           return ListTile(
//             trailing: Text('Null'),
//             title: Text(appName.toString(),style: TextStyle(color: Colors.black),),
//             subtitle: Text(packageName.toString(),style: TextStyle(color: Colors.black),),
//           );
//         },
//       ),
//     );
//   }
// }