import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:promise/features/notification/models/notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({ super.key });

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<InstagramNotification> notifications = [];

  Future<void> readJson() async {

    setState(() {
      notifications.addAll([
        InstagramNotification(
          "Test", 
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "Test content",
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "",
          true
        ),
        InstagramNotification(
          "Test", 
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "Test content",
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "",
          true
        ),
        InstagramNotification(
          "Test", 
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "Test content",
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "",
          true
        ),
        InstagramNotification(
          "Test", 
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "Test content",
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "",
          true
        ),
        InstagramNotification(
          "Test", 
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "Test content",
          "https://scontent-hkg1-2.xx.fbcdn.net/v/t1.6435-1/148803788_2787444671507334_7409042650870772197_n.jpg?stp=dst-jpg_s480x480&_nc_cat=104&ccb=1-7&_nc_sid=e4545e&_nc_eui2=AeFc8Pp8ptfDOk-fuawOcCE5iMOyzBWf1kGIw7LMFZ_WQXRzVn29cZoxFazf18scykTvbBFI6IFnybSIs0-IL6rh&_nc_ohc=MIuNCDL8ZXQQ7kNvgHdsCj-&_nc_ht=scontent-hkg1-2.xx&oh=00_AYCWoy2vkq0W6MCxrec2pUqpD_BaeJ-yQ_lPw52GGFRjdg&oe=6722D2E8",
          "",
          true
        ),
      ]);
      // notifications = data['notifications']
      //   .map((data) => InstagramNotification.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }
  Function(BuildContext) doNothing =(p0) => {

  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Activity", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),
            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: const ListTile(title: Text('Slide me'))
          );
  })
    );
  }

  notificationItem(InstagramNotification notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                notification.hasStory ?
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.orangeAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft
                    ),
                    // border: Border.all(color: Colors.red),
                    shape: BoxShape.circle
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(notification.profilePic)
                    ),
                  ),
                ) : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(notification.profilePic)
                  ),
                ),
                const SizedBox(width: 10,),
                Flexible(
                  child: RichText(text: TextSpan(
                    children: [
                      TextSpan(text: notification.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      TextSpan(text: notification.content, style: const TextStyle(color: Colors.black)),
                      TextSpan(text: notification.timeAgo, style: TextStyle(color: Colors.grey.shade500),)
                    ]
                  )),
                )
              ],
            ),
          ),
          notification.postImage != '' ?
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                child: Image.network(notification.postImage)
              ),
            )
          : Container(
              height: 35,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text('Follow', style: TextStyle(color: Colors.white))
              )
            ),
        ],
      ),
    );
  }
}