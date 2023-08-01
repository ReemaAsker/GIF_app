import 'package:flutter/material.dart';
import 'package:gif_project/Network.dart';
import 'package:http/http.dart';
import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

////// print(data['results'][0]['content_description']);
// print(data['results'][0]['media'][0]['gif']['url']);
class _HomePageState extends State<HomePage> {
  // late List<dynamic> imagesData;
  Network network = Network();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('GIF App'),
        backgroundColor: Colors.purple,
      ),
      body: allGifImages(),
    );
  }

  Widget allGifImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemCount: 20,
        itemBuilder: (context, index) {
          return FutureBuilder<List<dynamic>>(
              future: network.getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No results');
                } else {
                  String gifUrl =
                      snapshot.data![index]['media'][0]['gif']['url'];
                  return GestureDetector(
                    onTap: () => showImageAlert(gifUrl),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purple, // Set the border color here
                          width: 1.0, // Set the border width here
                        ),
                      ),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(gifUrl),
                      ),
                    ),
                  );
                }
              });
        },
      ),
    );
  }

  void showImageAlert(String gifUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple[50], // Set custom background color here
        content: Image.network(gifUrl),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                // Call the method we just created
                onPressed: () => _saveImage(context, gifUrl),
                icon: const Icon(Icons.save),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String url) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/image.gif';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image is saved ';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }
    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
