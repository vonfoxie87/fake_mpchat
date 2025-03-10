import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}


class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Hallo Anna,\nIk ben heel geintresseerd in deze fiets en zou er graag €75 voor bieden. Mijn zoon is bijna 3 jaar en ongeveer een meter. Denk je dat hij nog even vooruit kan met deze fiets? Ik werk zelf in Delft dus dat is lekker in de buurt.\n\nGroetjes, \n\nStefan",
      "isMe": true,
      "time": "13:22"
    },
    {
      "text": "Ha Stefan,\n\nMijn zoon heeft ceze week een niewue fiets gekregen, Hij is ruim 4.5 jaar en heeft veel plezier van deze fiets gehad.\n\nHij zou nog langer met de fiets kunnen doen maar kreeg een fiets doorgeschoven uit de familie. Het stuur en zadel kunnen allebei omhoog gezet worden, dus zou zeker geen probleem moeten zijn.\n\n Anna",
      "isMe": false,
      "time": "13:31"
    },
    {
      "text": "Oh super dat klinkt goed! Zou ik de fiets van je kunnen overnemen?",
      "isMe": true,
      "time": "13:34"
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
      "text": "Adres is **********. Dit is mijn nummer: 0652794628, bel maar of app maar als je in de buurt ben, Dan weet ik ongeveer hoelaat.",
      "isMe": false,
      "time": "14:30"
    },
    {
      "text": "Prima, tot morgen",
      "isMe": true,
      "time": "14:32",
      "status": "verzonden"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 144, 90),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/bike.jpg'),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alpina Yabber 12 inch", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Anna", 
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                //bool isLastMessage = index == messages.length - 1;
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
                          widthFactor: 0.8,  // Dit zorgt ervoor dat de breedte maximaal 80% is
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.yellow[100] : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              messages[index]['text'],
                              style: TextStyle(fontSize: 16),
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Schrijf je bericht...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
