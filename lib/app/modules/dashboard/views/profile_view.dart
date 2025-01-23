import 'package:getx_event/app/data/profile_response.dart';
import 'package:getx_event/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: controller.logout,
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Apakah Anda yakin ingin logout?",
                textCancel: "Cancel",
                textConfirm: "Logout",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.logout();
                  Get.back(); // Menutup dialog
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: HexColor('#feeee8'),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<ProfileResponse>(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.network(
                    'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                    repeat: true,
                    width: MediaQuery.of(context).size.width / 1,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Loading animation failed");
                    },
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Gagal memuat Profil"),
                );
              }

              final data = snapshot.data;

              if (data == null || data.email == null || data.email!.isEmpty) {
                return const Center(child: Text("No profile data available"));
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.avatar != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(data.avatar!),
                      radius: 50,
                    ),
                  Text(
                    '${data.name}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${data.email}'),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  //   child: Text(
                  //     "Hello.. My name ${data.name}. Im a backend & mobile developer near Bandung. Coding has become a perfect union of my two favourite passions and I love seeing the results of my efforts helping the users experience. I'm finding unique solutions to complex problems and I'm doing it all while making the worst puns you've never heard before.",
                  //     style: GoogleFonts.roboto(
                  //       textStyle: const TextStyle(
                  //         fontWeight: FontWeight.normal,
                  //         fontSize: 25,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }),
      )),
    );
  }
}
