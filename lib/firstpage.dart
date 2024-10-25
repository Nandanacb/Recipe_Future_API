import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_future_api/datamodel.dart';
import 'package:recipe_future_api/secondpage.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});
  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  late Future<RecipeemodelApi?> futureData;
  @override
  void initState() {
    super.initState();
    futureData = getData();
  }

  Future<RecipeemodelApi?> getData() async {
    try {
      String url = "https://dummyjson.com/recipes";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return RecipeemodelApi.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 212, 156),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 191, 212, 156),
        title: Text("Recipe API"),
      ),
      body: FutureBuilder<RecipeemodelApi?>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error:${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final recipes = snapshot.data!.recipes;
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Secondpage(
                                          recipe: recipe,
                                        )));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                  recipe.image,
                                  width: 100,
                                  height: 80,
                                ),
                                Text(recipe.name),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(recipe.cuisine),
                              ],
                            ),
                          ),
                        );
                      }));
            } else {
              return Center(child: Text("No data available"));
            }
          }),
    );
  }
}
