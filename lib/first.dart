import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notesaap/second.dart';
import 'package:notesaap/update.dart';
import 'package:sqflite/sqflite.dart';

class first extends StatefulWidget {
  Database? database;

  first(this.database);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  List note = [];
  List title = [];

  Future get() async {
    String sql = "SELECT * FROM notes";
    List<Map> lm = await widget.database!.rawQuery(sql);
    return lm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUPER NOTE"),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        actions: [
          IconButton(
              onPressed: () {
                // showSearch(delegate: ,context: context)
              },
              icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.cloud_upload_outlined)),
          PopupMenuButton(
            offset: Offset(10, 55),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("First")),
              PopupMenuItem(child: Text("Second")),
              PopupMenuItem(child: Text("Thirid")),
            ],
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        curve: Curves.bounceIn,
        overlayColor: Colors.black45,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.note_alt_rounded, color: Colors.white),
            label: "Checklist",
            foregroundColor: Colors.white,
            labelBackgroundColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return second(widget.database);
                },
              ));
            },
            child: Icon(Icons.fact_check_rounded, color: Colors.white),
            label: "Note",
            foregroundColor: Colors.white,
            labelBackgroundColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: get(),
          builder: (context, snapshot) {
            title.clear();
            note.clear();
            if (snapshot.connectionState == ConnectionState.done) {
              List? l;
              if (snapshot.hasData) {
                l = snapshot.data as List<Map>;
                l.forEach((element) {
                  title.add(element['title']);
                  note.add(element['note']);
                });
              }
              return l!.isEmpty
                  ? InkWell(
                      child: Image.asset(
                        "image/a1.png",
                        scale: 3,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return second(widget.database);
                          },
                        ));
                      },
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.white),
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        print("ti = ${title[index]}");
                        print("no = ${note[index]}");

                        return ListTile(
                          onLongPress: () {
                            showDialog(
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text("Delete Message"),
                                    children: [
                                      Text("Are you shure delete your note",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15,)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                String d =
                                                    "delete from notes where title = '${title[index]}'";
                                                int de = await widget.database!
                                                    .rawDelete(d);
                                                if (de == 1) {
                                                  setState(() {});
                                                  print("this is delete");
                                                } else {
                                                  print("This is not Delete");
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text("Yes")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"))
                                        ],
                                      )
                                    ],
                                  );
                                },
                                context: context);
                          },
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Update(
                                    widget.database, title[index], note[index]);
                              },
                            ));
                          },
                          title: Text("${title[index]}"),
                          leading: Icon(Icons.note_alt_sharp, size: 25),
                        );
                      },
                    );
            } else {
              return Center(
                child: CircularProgressIndicator(
                    color: Colors.blue, strokeWidth: 2),
              );
            }
          },
        ),
      ),
    );
  }
}
