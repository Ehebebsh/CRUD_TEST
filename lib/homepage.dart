import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = _firestore.collection('items');
  }

  Future<void> _addItem(String itemName) async {
    await _collectionReference.add({'name': itemName});
  }

  Future<void> _updateItem(String documentId, String newName) async {
    await _collectionReference.doc(documentId).update({'name': newName});
  }

  Future<void> _deleteItem(String documentId) async {
    await _collectionReference.doc(documentId).delete();
  }

  void _showEditDialog(String documentId, String currentName) {
    TextEditingController _editController = TextEditingController();
    _editController.text = currentName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'New Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateItem(documentId, _editController.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Firebase CRUD Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addItem(_controller.text);
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _collectionReference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;
                      var documentId = items[index].id;

                      return ListTile(
                        title: Text(item['name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(documentId, item['name']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem(documentId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
