import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_nosql_database/boxes/boxes.dart';
import 'package:hive_nosql_database/models/notes_model.dart';

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
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data[index].title.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    _editDialog(
                                        data[index],
                                        data[index].title.toString(),
                                        data[index].description.toString());
                                  },
                                  child: Icon(Icons.edit)),
                              GestureDetector(
                                onTap: () {
                                  delteData(data[index]);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          Text(data[index].description.toString())
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          _showDialog();
          // var box = await Hive.openBox('Muneer');
          // box.put('name', 'Muneer Hasan');
          // box.put('Age', '22');
          // box.put('details', {'Name': 'Muni', 'Pro': 'Software Engineer'});
          // print(box.get('name'));
          // print(box.get('Age'));
          // print(box.get('details'));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  final titleController = TextEditingController();
  final despController = TextEditingController();
  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: despController,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            title: Text('Add Notes'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: despController.text);
                    Navigator.pop(context);
                    final box = Boxes.getData();
                    box.add(data);

                    data.save();
                    print(box);
                    titleController.clear();
                    despController.clear();
                  },
                  child: Text('Add'))
            ],
          );
        });
  }

  Future<void> _editDialog(
      NotesModel notesmodel, String title, String description) async {
    titleController.text = title;
    despController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: despController,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            title: Text('Edit Notes'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    notesmodel.title = titleController.text.toString();
                    notesmodel.description = despController.text.toString();
                    notesmodel.save();
                    // final data = NotesModel(
                    //     title: titleController.text,
                    //     description: despController.text);
                    Navigator.pop(context);
                    // final box = Boxes.getData();
                    // box.add(data);

                    // data.save();
                    // print(box);
                    // titleController.clear();
                    // despController.clear();
                  },
                  child: Text('Edit'))
            ],
          );
        });
  }

  void delteData(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
