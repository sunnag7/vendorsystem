import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/pages/create_quote.dart';
import 'package:untitled/pages/view_quotes.dart';

import '../common/theme_helper.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
 /* final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');*/

  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

// A function that will convert a response body into a List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({required this.albumId,required this.id,required this.title,required this.url,required this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class MyVendorPage extends StatefulWidget{
  const MyVendorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyVendorPageState();
  }
}

class _MyVendorPageState extends State<MyVendorPage> {
  late final String title;

  //MyVendorPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Vendors",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
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
            margin: EdgeInsets.only( top: 16, right: 16,),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration( color: Colors.blue, borderRadius: BorderRadius.circular(6),),
                    constraints: const BoxConstraints( minWidth: 12, minHeight: 12, ),
                    child: const Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
        child: FutureBuilder<List<Photo>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PhotosList(photos: snapshot.requireData)
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  List<Photo> photos;
  final _formKey = GlobalKey<FormState>();
  PhotosList({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
                constraints: const BoxConstraints.expand(
                  height: 150,
                ),
                color: Colors.white10,
                alignment: Alignment.center,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.network(
                          photos[index].thumbnailUrl,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(photos[index].title),
                        subtitle: Text(photos[index].title),
                      ),
                      Container(
                       // decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          //style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Select".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            final String jsonTags = jsonEncode(photos);
                            var snackbar = SnackBar(
                              content: Text(jsonTags),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewQuotes()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}