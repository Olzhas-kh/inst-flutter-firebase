import 'package:flutter/material.dart';
import 'package:inst_fire/screens/add_task.dart';
import 'package:inst_fire/screens/profile_screen.dart';
import 'package:inst_fire/screens/users_search/almaty_search_screen.dart';
import 'package:inst_fire/screens/users_search/astana_search_screen.dart';
import 'package:inst_fire/screens/users_search/karagandy_search_screen.dart';
import 'package:inst_fire/screens/users_search/kyzylorda_search_screen.dart';
import 'package:inst_fire/screens/users_search/shymkent_search_screen.dart';
import 'package:inst_fire/utils/colours.dart';

class CitiesForSearch extends StatefulWidget {
  const CitiesForSearch({super.key});

  @override
  State<CitiesForSearch> createState() => _CitiesForSearchState();
}

class _CitiesForSearchState extends State<CitiesForSearch> {
  final citList = ["Almaty", "Astana", "Shymkent", "Kyzylorda", "Karaganda"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        title: Text(
          "Города",
        ),
      ),
      body: ListView.builder(
        itemCount: citList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: maroon),
              child: ListTile(
                  onTap: () => {
                        if (index == 0)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AlmatySearchScreen(),
                              ),
                            ),
                          }
                        else if (index == 1)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AstanaSearchScreen(),
                              ),
                            ),
                          }
                        else if (index == 2)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShymkentSearchScreen(),
                              ),
                            ),
                          }
                        else if (index == 3)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KyzylordaSearchScreen(),
                              ),
                            ),
                          }
                        else if (index == 4)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KaragandySearchScreen(),
                              ),
                            ),
                          }
                      },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: CircleAvatar(
                      radius: 16,
                    ),
                  ),
                  title: Text(
                    citList[index].toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      Text(citList[index].toString(),
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0)),
            ),
          );
        },
      ),
    );
  }
}
