// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/service/user/user_service.dart';
import 'package:quickmed/util/constant.dart';

class MyChatApp extends StatefulWidget {
  String? userId;
  String? name;
  String? img;
  bool isOnline;

  MyChatApp(
      {Key? key,
      required this.userId,
      required this.name,
      required this.img,
      required this.isOnline})
      : super(key: key);

  @override
  MyChatAppState createState() => MyChatAppState();
}

class MyChatAppState extends State<MyChatApp> {
  TextEditingController textEditingController = TextEditingController();
  late String senderMessage, receiverMessage;

  UserDataBaseServices services = UserDataBaseServices();

  ScrollController scrollController = ScrollController();

  Future<void> scrollAnimation() async {
    return await Future.delayed(
        const Duration(milliseconds: 100),
        () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear));
  }

  // void send() async {
  //   await services.sendMessage(textEditingController.text);
  //   setState(() {
  //     messageList.add(MessageData(textEditingController.text, true));
  //     textEditingController.clear();
  //   });

  //   await scrollAnimation();
  // }

  @override
  Widget build(BuildContext context) {
    //UserAppProvider appstate = Provider.of<UserAppProvider>(context);

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        leadingWidth: 50.0,
        titleSpacing: -8.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.img ?? ""),
          ),
        ),
        title: ListTile(
          title: Text("${widget.name}",
              style: const TextStyle(
                color: Colors.white,
              )),
          subtitle: Text(
            widget.isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: widget.isOnline ? Colors.green : Colors.red,
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.phone))),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatListView(scrollController: scrollController)),
          Container(
            // height: 50,
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFF333D56),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                  child: Transform.rotate(
                      angle: 45,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_sharp),
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 11.0),
                  child: Transform.rotate(
                    angle: -3.14 / 5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: GestureDetector(
                        onTap: () {
                        },
                        onLongPress: () {
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) => (messageList[index].isSender)
          ? SenderRowView(senderMessage: messageList[index].message)
          : ReceiverRowView(receiverMessage: messageList[index].message),
    );
  }
}

class SenderRowView extends StatelessWidget {
  const SenderRowView({Key? key, required this.senderMessage})
      : super(key: key);

  final String senderMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 8.0, right: 5.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFF7CE994),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      senderMessage,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 10.0, bottom: 8.0),
                child: const Text(
                  '8:55 AM, Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7.0,
                  ),
                ),
              ),
            ],
          ),
          //
        ),
        const Flexible(
          flex: 13,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(right: 10.0, top: 1.0, bottom: 9.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF90C953),
              child: Text('A',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
        )
      ],
    );
  }
}

class ReceiverRowView extends StatelessWidget {
  const ReceiverRowView({Key? key, required this.receiverMessage})
      : super(key: key);

  final String receiverMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Flexible(
          flex: 13,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, top: 1.0, bottom: 9.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF90C953),
              child: Text('X',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
        ),
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 8.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFF87D4E6),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      receiverMessage,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                child: const Text(
                  '8:55 AM, Today',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 7.0,
                  ),
                ),
              ),
            ],
          ),
          //
        ),
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
      ],
    );
  }
}
