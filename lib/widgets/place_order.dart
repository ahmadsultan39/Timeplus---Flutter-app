import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/auth.dart';

class PlaceOrder extends StatefulWidget {
  final watcId;
  PlaceOrder(this.watcId);
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  String location;
  int amount = 1;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<bool> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return false;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<AuthProvider>(context, listen: false);
    try {
      await Provider.of<OrdersProvider>(context, listen: false)
          .placeOrder(Order(
        watchId: widget.watcId,
        userId: user.userId,
        userNumber: user.number,
        amount: amount,
        location: location,
        orderDate: DateTime.now(),
      ));
      return true;
    } catch (error) {
      print(error);
      const errorMessage = 'Could not place order. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value.isEmpty) return "This can't be empty!";
                        return null;
                      },
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (value) {
                        location = value;
                      },
                    ),
                    // inc and dec
                    // Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (amount > 1) {
                                setState(() {
                                  amount--;
                                });
                              }
                            },
                          ),
                        ),
                        Text(
                          amount.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                            ),
                            onPressed: () {
                              setState(() {
                                amount++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    // placeOrderButton
                    if (_isLoading)
                      Center(child: CircularProgressIndicator())
                    else
                      TextButton(
                        onPressed: () async {
                          if (await _submit()) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Container(
                                margin: const EdgeInsets.all(8),
                                child: Text(
                                    'We will contact you as soon as possible to confrim your order'),
                              )),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Place Order',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
