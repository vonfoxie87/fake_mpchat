import 'package:flutter/material.dart';
import 'dart:html' as html; // Voor web-geolocatie
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
          surface: const Color.fromARGB(255, 234, 234, 234),
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  String _street = "";

  final TextEditingController _streetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _streetController.text = _street;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

      // Toon de locatie popup direct na het eerste frame laden:
      _showLocationDialog();
    });
  }

  Future<void> _showLocationDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // gebruiker moet invullen
      builder: (context) => AlertDialog(
        title: Text('Voer je locatie in'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _streetController,
              decoration: InputDecoration(labelText: 'Straat'),
            ),

          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _street = _streetController.text.trim();
              });
              Navigator.of(context).pop();
            },
            child: Text('Opslaan'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    bool shouldLeave = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Voer je locatie in'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _streetController,
              decoration: InputDecoration(labelText: 'Straat'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuleer'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _street = _streetController.text.trim();
              });
              shouldLeave = true;
              Navigator.of(context).pop();
            },
            child: Text('Opslaan en verlaten'),
          ),
        ],
      ),
    );

    return shouldLeave;
  }

@override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        "text":
            "Hallo Anna,\nIk ben heel geintresseerd in deze fiets en zou er graag €75 voor bieden. Mijn zoon is bijna 3 jaar en ongeveer een meter. Denk je dat hij nog even vooruit kan met deze fiets? Ik werk zelf in Delft dus dat is lekker in de buurt.\n\nGroetjes, \n\nStefan",
        "isMe": true,
        "time": "13:22",
        "status": "gelezen"
      },
      {
        "text":
            "Ha Stefan,\n\nMijn zoon heeft deze week een nieuwe fiets gekregen, hij is ruim 4.5 jaar en heeft veel plezier van deze fiets gehad.\n\nHij zou nog langer met de fiets kunnen doen maar kreeg een fiets doorgeschoven uit de familie. Het stuur en zadel kunnen allebei omhoog gezet worden, dus zou zeker geen probleem moeten zijn.\n\n Anna",
        "isMe": false,
        "time": "13:31"
      },
      {
        "text": "Oh super dat klinkt goed! Zou ik de fiets van je kunnen overnemen?",
        "isMe": true,
        "time": "13:34",
        "status": "gelezen"
      },
      {
        "text": "Ik zou eventueel vandaag na mn werk door kunnen rijden, werk tot 16:15u. Ik hoor het wel.",
        "isMe": false,
        "time": "13:35"
      },
      {
        "text": "Vandaag lukt niet, morgen kan wel. Is dat een optie?",
        "isMe": false,
        "time": "14:20"
      },
      {
        "text": "Helemaal goed.",
        "isMe": true,
        "time": "14:26",
        "status": "gelezen"
      },
      {
        "text": "Wat is je adres? Wil je het geld contant of kan het ook via een tikkie?",
        "isMe": true,
        "time": "14:27",
        "status": "gelezen"
      },
      {
        "text": "Liefst digitaal met een qr code",
        "isMe": false,
        "time": "14:29"
      },
      {
        "text": "Adres is $_street",
        "isMe": false,
        "time": "14:30"
      },
      {
        "text": "06-10794628. Bel maar als je er bent, dan kom ik naar buiten.",
        "isMe": false,
        "time": "14:30"
      },
      {
        "text": "Prima, tot morgen",
        "isMe": true,
        "time": "14:32",
        "status": "gelezen"
      },
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          title: Row(
            children: [
              Transform.translate(
                offset: Offset(-10, 0),
                child: Icon(Icons.arrow_back_sharp, size: 26, color: Colors.black),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('images/bike.jpg'),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alpina Yabber 12 inch",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    "Anna",
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 65, 65, 65)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, size: 26, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isMe = messages[index]['isMe'] ?? false;
                  String status = messages[index]['status'] ?? "verzonden";
                  Color checkColor = status == "gelezen" ? Colors.green : Colors.grey;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: FractionallySizedBox(
                            alignment: Alignment.center,
                            widthFactor: 0.8,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 2),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe ? const Color.fromARGB(255, 76, 97, 118) : const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SelectableText(
                                messages[index]['text'],
                                style: TextStyle(fontSize: 14, color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8, left: 8, bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                messages[index]['time'],
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (isMe) ...[
                                SizedBox(width: 5),
                                Icon(Icons.done_all, color: checkColor, size: 16),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Schrijf je bericht...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E4F85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send_sharp, size: 18, color: Colors.white),
                          onPressed: () {},
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black, thickness: 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.local_shipping_outlined, color: const Color(0xFF0E4F85)),
                          SizedBox(width: 20),
                          Icon(Icons.photo_outlined, color: const Color(0xFF0E4F85)),
                          SizedBox(width: 20),
                          Icon(Icons.location_on_outlined, color: const Color(0xFF0E4F85)),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.handshake_outlined, color: const Color(0xFF0E4F85)),
                        label: Text("Doe een voorstel", style: TextStyle(color: const Color(0xFF0E4F85))),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFF0E4F85)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
