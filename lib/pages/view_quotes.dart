 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 import 'package:untitled/common/qoutes_data.dart';
import 'package:untitled/pages/profile_page.dart';
import 'package:untitled/pages/splash_screen.dart';

import '../common/theme_helper.dart';
import 'login_page.dart';

class ViewQuotes extends StatelessWidget {
  var cryptoData = QuotesData.getData;
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();


  ViewQuotes({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("View Quotes",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0.5,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace:Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                    )
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only( top: 16, right: 16,),
                  child: Stack(
                    children: <Widget>[
                      const Icon(Icons.notifications),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                          constraints: const BoxConstraints( minWidth: 12, minHeight: 12, ),
                          child: const Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
// scrollDirection: Axis.horizontal,
                        itemCount: cryptoData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 180,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 2.0 ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(left: 10, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      cryptoIcon(cryptoData[index]),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      cryptoNameSymbol(cryptoData[index]),
                                                      Spacer(),
                                                      cryptoChange(cryptoData[index]),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      //changeIcon(cryptoData[index]),
                                                      const SizedBox(
                                                        width: 20,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      cryptoAmount(cryptoData[index]),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),

                                                    ],
                                                  ),
                                                  Row(
                                                      children: <Widget>[
                                                        edit_delete(cryptoData[index], context)
                                                  ]
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )));
  }
  Widget cryptoIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            data['icon'],
            color: data['iconColor'],
            size: 40,
          )),
    );
  }
  Widget cryptoNameSymbol(data) {
    return  Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
      alignment: Alignment.centerLeft,
       child: RichText(
        text: TextSpan(
          text: '${data['name']}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n${data['Category']}',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    )
    );
  }

  Widget edit_delete(data, context) {
    return  Padding(
        padding: const EdgeInsets.only(left: 10.0),
           child: ElevatedButton(
            style: ThemeHelper().buttonStyle(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Text(
                "Edit".toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ProfilePage()
                    ),
                        (Route<dynamic> route) => false
                );
              }
            },
          ),

    );
  }

  Widget cryptoChange(data) {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '${data['Amount']}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n${data['Delivery']}',
                style: TextStyle(
                    color: data['changeColor'],
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget changeIcon(data) {
    return Align(
        alignment: Alignment.topRight,
        child: data['Amount'].contains('-')
            ? Icon(
          Icons.arrow_downward,
          color: data['changeColor'],
          size: 30,
        )
            : Icon(
          Icons.arrow_upward,
          color: data['changeColor'],
          size: 30,
        ));
  }
  Widget cryptoAmount(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n${data['Service_terms']}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}