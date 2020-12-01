import 'dart:ffi';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "../providers/product.dart";
import "../providers/products.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': ''
  };
  var _editedProduct = Product(
    id: null,
    title: null,
    description: null,
    price: 0,
    imageUrl: null,
  );

  @override
  void initState() {
    // TODO: implement initState
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (productId != null) {
        final product = Provider.of<Products>(context).findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageurl': '',
          'price': _editedProduct.price.toString()
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: Text("An error Occured!"),
                content: Text("Something went wrong!"),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text("Okay"))
                ],
              ),
        );
      }
//      finally{
//        setState(() {
//          _isLoading = false;
//        });
//
//        Navigator.of(context).pop();
//      }

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
          title: Text("Edit Product"),
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: EdgeInsets.all(15),
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter a value";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_desFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Price";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please Enter a Numeric Value";
                      }
                      if (double.parse(value) <= 0) {
                        return "Please Enter Price graeter than 0";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _desFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter a Description";
                      }
                      if (value.length < 10) {
                        return "Should be atleasr 10 Characters!";
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text("Enter the URL")
                            : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration:
                          InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return "Please enter an image URL";
//                          }
//                          if (!value.startsWith('http') ||
//                              !value.startsWith('https')) {
//                            return "Please Enter a valid URL";
//                          }
//                          return null;
//                        },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(12),
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .canvasColor,
                          fontSize: 18),
                    ),
                    onPressed: _saveForm,
                  )
                ],
              )),
        ),
      );
    }
  }

