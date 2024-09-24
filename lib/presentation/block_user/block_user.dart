// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class SearchPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final SearchController controller = Get.find();

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: 60,
//         flexibleSpace: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     onChanged: (value) => controller.searchText.value = value,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search),
//                       hintText: 'Search',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => controller.cancelSearch(),
//                   child: Text("Cancel", style: TextStyle(color: Colors.black)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundImage: AssetImage(controller.user.value.profileImage),
//                   ),
//                   SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             controller.user.value.name,
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           if (controller.user.value.isVerified)
//                             SizedBox(width: 4),
//                           if (controller.user.value.isVerified)
//                             Icon(Icons.verified, size: 16, color: Colors.blue),
//                         ],
//                       ),
//                       Text(
//                         controller.user.value.profession,
//                         style: TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   ElevatedButton(
//                     onPressed: controller.blockUser,
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.white,
//                       side: BorderSide(color: Colors.grey),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: Text(
//                       'Block',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
