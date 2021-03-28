import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watches.dart';
import '../widgets/image_input.dart';

class AddWatchScreen extends StatefulWidget {
  static const routeName = '/add-watch';
  @override
  _AddWatchScreenState createState() => _AddWatchScreenState();
}

class _AddWatchScreenState extends State<AddWatchScreen> {
  final _form = GlobalKey<FormState>();
  var watch = Watch(
    id: null,
    price: 0,
    title: '',
    description: '',
    imageUrl: '',
  );
  Map _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'image': '',
  };
  var _init = true;
  var _isLoading = false;
  File _image;

  void setImage(File image) {
    setState(() {
      _image = image;
    });
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        watch = Provider.of<WatchesProvider>(context, listen: false).findId(id);
        _initValues = {
          'title': watch.title,
          'price': watch.price.toString(),
          'description': watch.description,
          'imageUrl': watch.imageUrl,
        };
      }
      _init = false;
    }
    super.didChangeDependencies();
  }

  void _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<WatchesProvider>(context, listen: false)
          .addProduct(watch, _image);
    } catch (error) {
      print(error.toString());
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An Error has occured!'),
          content: const Text('Something went wrong please try again later'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Ok'))
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ))
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) return "This can't be empty";
                      return null;
                    },
                    onSaved: (value) {
                      watch = Watch(
                        id: watch.id,
                        title: value,
                        price: watch.price,
                        description: watch.description,
                        imageUrl: watch.imageUrl,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (double.tryParse(value) == null)
                        return "Invalid input!!";
                      return null;
                    },
                    onSaved: (value) {
                      watch = Watch(
                        id: watch.id,
                        title: watch.title,
                        price: double.parse(value),
                        description: watch.description,
                        imageUrl: watch.imageUrl,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.isEmpty) return "This cat't be empty";
                      return null;
                    },
                    onSaved: (value) {
                      watch = Watch(
                        id: watch.id,
                        title: watch.title,
                        price: watch.price,
                        description: value,
                        imageUrl: watch.imageUrl,
                      );
                    },
                  ),
                  ImageInput(setImage, watch.imageUrl),
                ],
              ),
            ),
    );
  }
}
