import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
late Size mq = MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          title: "Your Profile",
          //onClickSearchNavigateTo: const MySearchScreen()
          ),
      body: ui.ProfileScreen(
        avatar: Center(
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                  radius: 75,
                  child: user.imageUrl == null || user.imageUrl == ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnWaCAfSN08VMtSjYBj0QKSfHk4-fjJZCOxgHLPuBSAw&s",
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover),
                        )
                      : ClipOval(
                          child: Image.network(user.imageUrl!,
                              width: 150, height: 150, fit: BoxFit.cover))),
              InkWell(
                onTap: () {
                  // _showBottomSheet();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  padding: EdgeInsets.all(mq.height * .003),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        showUnlinkConfirmationDialog: true,
        providers: ui.FirebaseUIAuth.providersFor(
          auth.FirebaseAuth.instance.app,
        ),
        actions: [
          ui.SignedOutAction((context) {
            AuthService().logOut(context);
          }),
        ],
      ),
    );
  }
}
