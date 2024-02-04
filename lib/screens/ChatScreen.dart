import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/CourseModel.dart';
import '../providers/ChatProvider.dart';
import '../services/auth_services.dart';

class ChatScreen extends StatelessWidget {
  final Course course;
  ChatScreen({super.key, required this.course});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthServiceProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        toolbarHeight: 100.h,
        title: Column(
          children: [
            Text(
              'Community Chat:',
              style: TextStyle(fontFamily: 'Kameron', fontSize: 36.sp),
            ),
            Text(
              course.name,
              style: TextStyle(fontFamily: 'Kameron', fontSize: 36.sp),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatProvider.getMessages(course.courseID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<ChatMessage> messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isCurrentUser = message.senderId == currentUser?.uid;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        isCurrentUser ? 64.0.w : 16.0.w,
                        11.h,
                        isCurrentUser ? 16.0.w : 64.0.w,
                        11.h,
                      ),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? const Color(0xFF2A9D8F)
                                    : primaryColor,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isCurrentUser)
                                      Text(
                                        message.senderName,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    Text(
                                      message.message,
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                DateFormat('hh:mm a').format(message.timestamp
                                    .toDate()), // Assuming timestamp is a DateTime
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      cursorColor: primaryColor,
                      minLines: 1,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Type your message here...',
                        hintStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color(0xffF5F5F5),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0.h),
                    child: InkWell(
                      onTap: () {
                        if (_messageController.text.isNotEmpty) {
                          chatProvider.sendMessage(
                              course.courseID,
                              currentUser!.uid,
                              currentUser.email!,
                              _messageController.text);
                          _messageController.clear();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        maxRadius: 20.r,
                        child: Icon(
                          Icons.send,
                          size: 15.r,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
