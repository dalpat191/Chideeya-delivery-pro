import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(home: RiderHome()));

class RiderHome extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chideeya Rider - 10 Lakh Draw'), backgroundColor: Colors.black, foregroundColor: Colors.amber),
      body: Column(children: [
        Container(padding: EdgeInsets.all(15), color: Colors.amber, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Tickets: 47/50'), Text('Prize: 10 LAKH')])),
        Expanded(child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'pending').snapshots(),
          builder: (c,s){
            if(!s.hasData) return Center(child: CircularProgressIndicator());
            return ListView(children: s.data!.docs.map((d)=>Card(child: ListTile(
              title: Text("${d['pickup']} -> ${d['drop']}"),
              subtitle: Text("Rs 30 Earning"),
              trailing: ElevatedButton(child: Text('ACCEPT'), onPressed: (){
                FirebaseFirestore.instance.collection('orders').doc(d.id).update({'status':'accepted', 'riderId':'dalpat191'});
                FirebaseFirestore.instance.collection('rider_stats').doc('dalpat191').set({'totalDeliveries': FieldValue.increment(1), 'tickets': FieldValue.increment(1)}, SetOptions(merge:true));
              }),
            ))).toList());
          },
        ))
      ]),
    );
  }
}
