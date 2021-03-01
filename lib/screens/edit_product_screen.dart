import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_providers.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusnode = FocusNode();
  final _desfoucs = FocusNode();
  final _imageurlcontroller = TextEditingController();
  final _imageurlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedproduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _isinit = true;
  var _isloading = false;
  var _initval = {
    'title': '',
    'desc': '',
    'price': '',
    'imageurl': '',
  };

  @override
  void initState() {
    _imageurlfocusnode.addListener(_update);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _editedproduct =
            Provider.of<products>(context, listen: false).findbyid(productid);
        _initval = {
          'title': _editedproduct.title,
          'desc': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          'imageurl': '',
        };
        _imageurlcontroller.text = _editedproduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusnode.removeListener(_update);
    _priceFocusnode.dispose();
    _desfoucs.dispose();
    _imageurlcontroller.dispose();
    _imageurlfocusnode.dispose();

    super.dispose();
  }

  void _update() {
    if (!_imageurlfocusnode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final isvalid = _form.currentState.validate();

    if (!isvalid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isloading = true;
    });
    if (_editedproduct.id != null) {
      await Provider.of<products>(context, listen: false)
          .updatepro(_editedproduct.id, _editedproduct);
    } else {
      try {
        await Provider.of<products>(context, listen: false)
            .addproduct(_editedproduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('an error occurred'),
                  content: Text('opps someting went wrong'),
                  actions: [
                    FlatButton(
                        child: Text('okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      } //finally {
      //setState(() {
      //_isloading = false;
      //});
      //Navigator.of(context).pop();
      //}
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveform)],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initval['title'],
                      decoration: InputDecoration(
                        labelText: 'title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusnode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please provide val';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedproduct = Product(
                          title: val,
                          price: _editedproduct.price,
                          description: _editedproduct.description,
                          imageUrl: _editedproduct.imageUrl,
                          id: _editedproduct.id,
                          isfavorite: _editedproduct.isfavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initval['price'],
                      decoration: InputDecoration(
                        labelText: 'price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusnode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_desfoucs);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please provide price';
                        }
                        if (double.tryParse(val) == null) {
                          return 'pleas enter valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'pleas enter number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedproduct = Product(
                          title: _editedproduct.title,
                          price: double.parse(val),
                          description: _editedproduct.description,
                          imageUrl: _editedproduct.imageUrl,
                          id: _editedproduct.id,
                          isfavorite: _editedproduct.isfavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initval['desc'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLength: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _desfoucs,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please enter a description';
                        }
                        if (val.length < 10) {
                          return 'enter atleast 10 chr';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedproduct = Product(
                          title: _editedproduct.title,
                          price: _editedproduct.price,
                          description: val,
                          imageUrl: _editedproduct.imageUrl,
                          id: _editedproduct.id,
                          isfavorite: _editedproduct.isfavorite,
                        );
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
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageurlcontroller.text.isEmpty
                              ? Text('enter a url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageurlcontroller.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image UrL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageurlcontroller,
                            focusNode: _imageurlfocusnode,
                            onFieldSubmitted: (_) {
                              _saveform();
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'please enter pic';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'please enter valid link';
                              }
                              if (!val.endsWith('.png') &&
                                  !val.endsWith('.jpg') &&
                                  !val.endsWith('.jpeg')) {
                                return 'enter valid url';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedproduct = Product(
                                title: _editedproduct.title,
                                price: _editedproduct.price,
                                description: _editedproduct.description,
                                imageUrl: val,
                                id: _editedproduct.id,
                                isfavorite: _editedproduct.isfavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
