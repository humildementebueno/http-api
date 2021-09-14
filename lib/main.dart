import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:htttp/models/response_characters.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick And Morty Character',
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final _getCharactersUrl = "https://rickandmortyapi.com/api/character";

  @override
  void initState() {
    super.initState();
    /**este metodo se ejecutara una vez realizado toda la pantalla luego de haberse renderizado */
    WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) async {
      /**lo que hace response es conectar con la api */
      var response = await http.get(Uri.parse(_getCharactersUrl));
      /**el body lo estamos codificando para volverlo un mapa porque la funcion fromJson me pide un mapa */
      var responseCharacter =
          ResponseCharacters.fromJson(json.decode(response.body));

      responseCharacter.results!.forEach((element) {
        print(element.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        /**para quitar la sombra del appbar */
        title: Text(
          "Character",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: FutureBuilder(
          future: http.get(Uri.parse(_getCharactersUrl)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              /**entra aqui porque tiene data */
              var response = snapshot.data as http.Response;
              var responseCharacter =
                  ResponseCharacters.fromJson(json.decode(response.body));
              var characters = responseCharacter.results;

              return ListView.builder(
                itemCount: characters!.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 18,
                        left: 12,
                        right: 12,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(3, 3),
                              blurRadius: 3,
                              spreadRadius: 3,
                            )
                          ]),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black87),
                              ),
                              width: 100,
                              height: 100,
                              child: Image.network(character.image!)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(character.name!)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              /**no tiene data */
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
