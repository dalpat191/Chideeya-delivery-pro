import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(home: ClientHome()));

class ClientHome extends StatefulWidget {
  @override _ClientHomeState createState() => _ClientHomeState();
}
class _ClientHomeState extends State<ClientHome> {
  final pick = TextEditingController();
  final drop = TextEditingController();
  final ref = TextEditingController();
  String myCode = "CHID191A"; // Example

  void createOrder() async {
    // Referral check
    if(ref.text.isNotEmpty){
      var q = await FirebaseFirestore.instance.collection('referral_codes').where('code', isEqualTo: ref.text.trim()).get();
      if(q.docs.isNotEmpty){
        var referrerId = q.docs.first['userId'];
        FirebaseFirestore.instance.collection('wallets').doc(referrerId).set({'balance': FieldValue.increment(50)}, SetOptions(merge:true));
      }
    }
    FirebaseFirestore.instance.collection('orders').add({
      'pickup': pick.text, 'drop': drop.text, 'status': 'pending',
      'price': 40, 'createdAt': FieldValue.serverTimestamp()
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Bhej Diya!')));
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chideeya Client - $myCode'), backgroundColor: Colors.amber),
      body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
        Container(padding: EdgeInsets.all(10), color: Colors.amber[100], child: Text('Aapka Referral Code: $myCode\nShare karo, Rs 50 kamao')),
        TextField(controller: pick, decoration: InputDecoration(labelText: 'Pickup Address')),
        TextField(controller: drop, decoration: InputDecoration(labelText: 'Drop Address')),
        TextField(controller: ref, decoration: InputDecoration(labelText: 'Referral Code (CHIDXXXX)')),
        SizedBox(height: 20),
        ElevatedButton(onPressed: createOrder, child: Text('RIDER BULAO - Rs 40'), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50))),
      ])),
    );
  }
}
