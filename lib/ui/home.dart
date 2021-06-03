import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_netsurf/common/models/customer.dart';
import 'package:project_netsurf/common/models/product.dart';
import 'package:project_netsurf/common/product_constant.dart';
import 'package:project_netsurf/common/sp_constants.dart';
import 'package:project_netsurf/common/sp_utils.dart';
import 'package:project_netsurf/common/ui/edittext.dart';
import 'package:project_netsurf/ui/drawer.dart';
import 'package:project_netsurf/ui/select_products.dart';

class HomePage extends StatefulWidget {
  final bool isRetailer;

  HomePage({Key key, this.isRetailer}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController categoryTextController =
      new TextEditingController();
  final TextEditingController itemTextController = new TextEditingController();
  ScrollController _controller;
  bool silverCollapsed = false;

  List<Product> allCategories;
  List<Product> allProducts;
  bool isRetailer = false;
  String textValue = "";
  User user = User("", "", "", "", "");

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    isRetailer = widget.isRetailer;

    // Preference.getItem(SP_CUSTOMER_NAME).then((value) => {name = value});
    // Preference.getItem(SP_CUSTOMER_M_NO).then((value) => {mobileNo = value});
    // Preference.getItem(SP_CUSTOMER_RF_ID).then((value) => {cRefId = value});
    // Preference.getItem(SP_CUSTOMER_ADDRESS).then((value) => {address = value});
    // Preference.getItem(SP_CUSTOMER_EMAIL).then((value) => {email = value});
    _controller.addListener(() {
      if (_controller.offset > 100 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;
        }
      }
      if (_controller.offset <= 100 && !_controller.position.outOfRange) {
        if (silverCollapsed) {
          silverCollapsed = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        key: _scaffoldKey,
        body: FutureBuilder(
          future: Preference.getProducts(SP_CATEGORY_IDS),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              allCategories = snapshot.data;
              return FutureBuilder(
                future: Preference.getProducts(SP_PRODUCTS),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    allProducts = snapshot.data;
                    return FutureBuilder(
                      future: Preference.getRetailer(),
                      builder: (context, AsyncSnapshot<User> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null &&
                              snapshot.data.name.isNotEmpty &&
                              snapshot.data.mobileNo.isNotEmpty) {
                            print("RetailerData: " + snapshot.data.name);
                            isRetailer = false;
                            return scrollView();
                          } else {
                            isRetailer = true;
                            return scrollView();
                          }
                        } else if (snapshot.hasError) {
                          return Text(
                            "Sorry, Something went wrong.",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("No product data found");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No product data found");
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget scrollView() {
    textValue = isRetailer ? "Retailer" : "Customer";
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        scrollAppBar(),
        inputDataAndNext(),
      ],
    );
  }

  Widget scrollAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "",
          style: TextStyle(color: Colors.grey[100]),
        ),
        centerTitle: true,
        background: Image.asset(
          'assets/netsurf.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget inputDataAndNext() {
    return SliverFillRemaining(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 0),
            EditText(
                required: true,
                initTextValue: user.name ?? "",
                type: TextInputType.name,
                editTextName: textValue + " Name",
                onText: (text) async {
                  user.name = text;
                  Preference.setItem(SP_CUSTOMER_NAME, text);
                  print(text);
                },
                onTap: () {
                  _controller.jumpTo(_controller.position.maxScrollExtent);
                }),
            EditText(
                required: true,
                initTextValue: user.mobileNo ?? "",
                type: TextInputType.phone,
                editTextName: textValue + " Mobile Number",
                onText: (text) async {
                  user.mobileNo = text;
                  Preference.setItem(SP_CUSTOMER_M_NO, text);
                  print(text);
                },
                onTap: () {
                  _controller.jumpTo(_controller.position.maxScrollExtent);
                }),
            if (!isRetailer)
              EditText(
                  required: false,
                  initTextValue: user.cRefId ?? "",
                  editTextName: textValue + " Reference ID",
                  onText: (text) async {
                    user.cRefId = text;
                    await Preference.setItem(SP_CUSTOMER_RF_ID, text);
                    print(text);
                  },
                  onTap: () {
                    _controller.jumpTo(_controller.position.maxScrollExtent);
                  }),
            EditText(
                required: false,
                editTextName: "Address",
                initTextValue: user.address ?? "",
                type: TextInputType.streetAddress,
                maxline: 3,
                onText: (text) async {
                  user.address = text;
                  await Preference.setItem(SP_CUSTOMER_ADDRESS, text);
                  print(text);
                },
                onTap: () {
                  _controller.jumpTo(_controller.position.maxScrollExtent);
                }),
            if (!isRetailer)
              EditText(
                  required: false,
                  initTextValue: user.email ?? "",
                  editTextName: "Email",
                  type: TextInputType.emailAddress,
                  onText: (text) async {
                    user.email = text;
                    await Preference.setItem(SP_CUSTOMER_EMAIL, text);
                    print(text);
                  },
                  onTap: () {
                    _controller.jumpTo(_controller.position.maxScrollExtent);
                  }),
            CustomButton(
              buttonText: isRetailer ? "Save" : "Next",
              onClick: () {
                if (user.name.isEmpty && user.mobileNo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill all the required fields!"),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
                if (isRetailer) {
                  Preference.setRetailer(user);
                  setState(() {});
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (__) => new SelectProductsPage(
                        customerData: user,
                        allCategories: allCategories,
                        allProducts: allProducts,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
