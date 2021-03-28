import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widgets/place_order.dart';

import '../providers/watches.dart';

class WatchDetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final watch = ModalRoute.of(context).settings.arguments as Watch;
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: mediaquery.size.width,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        height: mediaquery.size.width,
                        width: double.infinity,
                        child: Hero(
                          tag: watch.id,
                          child: FadeInImage(
                            placeholder:
                                const AssetImage('assets/images/watch.png'),
                            image: NetworkImage(
                              watch.imageUrl,
                            ),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return const Center(
                                  child: const Text('Can\'t load image'));
                            },
                          ),
                        ),
                      ),
                      title: SABT(
                        child: Text(
                          watch.title,
                        ),
                      )),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'السعر : ${watch.price.toStringAsFixed(0)}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'المواصفات : ${watch.description}',
                      textAlign: TextAlign.right,
                      softWrap: true,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ]))
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              showMaterialModalBottomSheet(
                  context: context, builder: (ctx) => PlaceOrder(watch.id));
            },
            icon: const Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.black,
            ),
            label: const Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'Order Now',
                style: TextStyle(color: Colors.black),
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType();
    // print(settings.minExtent);
    bool visible =
        settings == null || settings.currentExtent > settings.minExtent + 10;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _visible ? 0 : 1,
      child: widget.child,
    );
  }
}
