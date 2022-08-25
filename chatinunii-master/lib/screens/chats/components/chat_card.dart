import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/Chat.dart';

class ChatCard extends StatefulWidget {
  const ChatCard(
      {Key? key, required this.chat, required this.press, required this.chatId})
      : super(key: key);
  final Chat chat;
  final chatId;
  final VoidCallback press;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

enum Menu { itemOne, itemTwo, itemThree }

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    widget.chat.image,
                  ),
                ),
                if (widget.chat.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        widget.chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(widget.chat.time),
            ),
            PopupMenuButton<Menu>(
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) {
                  setState(() {
                    // _selectedMenu = item.name;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      PopupMenuItem<Menu>(
                        value: Menu.itemOne,
                        child: InkWell(
                          onTap: () {
                            Apis().deleteChat(widget.chatId).then((value) {
                              Navigator.pop(context);
                            });
                            // Navigator.pop(context);
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.delete,
                                color: kPrimaryColor,
                              ),
                              Text(
                                'Delete Chat',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<Menu>(
                        value: Menu.itemTwo,
                        child: InkWell(
                          onTap: () {
                            Apis()
                                .blockByUser(
                                    blockedUserNme: widget.chat.name,
                                    chatId: widget.chatId)
                                .then((value) {
                              if (value == 'Bad Request') {
                                showToast('Error while blocking user');
                                Navigator.pop(context);
                              } else {
                                showToast('User hs been blocked!');
                                Navigator.pop(context);
                                setState(() {});
                              }

                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.report,
                                color: kPrimaryColor,
                              ),
                              Text(
                                'Block User',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<Menu>(
                        value: Menu.itemThree,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: (context),
                                builder: (context) => showDetails());
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.warning,
                                color: kPrimaryColor,
                              ),
                              Text(
                                'Complaint User',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
          ],
        ),
      ),
    );
  }

  Widget showDetails() {
    TextEditingController reason = TextEditingController();
    return AlertDialog(
      title: Text('Complaint User'),
      content: TextFormField(
        controller: reason,
        decoration: InputDecoration(
            labelText: 'Reason For Complain', hintText: 'Enter Reason'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (reason.text.isEmpty) {
                showToast('Please type reason to submit complain');
              } else {
                Apis().complaintUser(
                    chatId: widget.chatId,
                    toUsername: widget.chat.name,
                    reason: reason.text);
              }
            },
            child: Text('Submit')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'))
      ],
    );
  }
}
