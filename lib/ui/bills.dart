import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_netsurf/common/contants.dart';
import 'package:project_netsurf/common/models/billing.dart';
import 'package:project_netsurf/common/models/customer.dart';
import 'package:project_netsurf/common/models/display_data.dart';
import 'package:project_netsurf/common/sp_utils.dart';
import 'package:project_netsurf/common/ui/loader.dart';
import 'package:project_netsurf/ui/drawer.dart';

class BillsPage extends StatefulWidget {
  final DisplayData displayData;
  final User retailer;

  BillsPage({Key key, this.retailer, this.displayData}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<BillsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Billing> bills;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Net Surf", textAlign: TextAlign.center),
            centerTitle: true,
          ),
          key: _scaffoldKey,
          body: FutureBuilder(
            future: Preference.getBills(),
            builder: (context, AsyncSnapshot<List<Billing>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bills = snapshot.data;
                if (bills != null && bills.isNotEmpty) {
                  bills.forEach((element) {
                    print("BILLS: " + element.price.dispFinalAmt());
                  });
                  return inputDataAndNext();
                } else {
                  return Center(child: Text("No bills found!"));
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No product data found");
              }
              return CustomLoader();
            },
          )),
    );
  }

  Widget inputDataAndNext() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: bills.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              margin: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      print("Delete click");
                    },
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      size: 30,
                    ),
                    color: Colors.black87,
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 125),
                      decoration: new BoxDecoration(
                        color: new Color(0xFF333366),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(15.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 24, top: 8, bottom: 8, right: 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        bills[index].customer.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        bills[index].customer.mobileNo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Bill No: " +
                                            bills[index].billingInfo.number,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (bills[index]
                                          .customer
                                          .cRefId
                                          .isNotEmpty)
                                        Text(
                                          "CRef: " +
                                              bills[index].customer.cRefId,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      RUPEE_SYMBOL +
                                          " " +
                                          bills[index].price.dispFinalAmt(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              print("Delete click");
                            },
                            icon: Icon(
                              Icons.navigate_next,
                              size: 35,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
