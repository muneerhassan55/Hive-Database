import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Hive Database',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('Muneer'),
              builder: (context, snapshot) {
                return Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.get('name').toString()),
                        subtitle: Text(snapshot.data!.get('Age').toString()),
                        trailing: IconButton(
                            onPressed: () {
                              snapshot.data!.delete('name');
                              setState(() {});
                            },
                            icon: Icon(Icons.edit)),
                      )
                    ],
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          var box = await Hive.openBox('Muneer');
          box.put('name', 'Muneer Hasan');
          box.put('Age', '22');
          box.put('details', {'Name': 'Muni', 'Pro': 'Software Engineer'});
          print(box.get('name'));
          print(box.get('Age'));
          print(box.get('details'));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
