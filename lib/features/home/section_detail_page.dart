// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/announcement_provider.dart';
// import '../pages/announcement_page.dart';

// class DashboardAnnouncements extends StatelessWidget {
//   const DashboardAnnouncements({super.key});

//   @override
//   Widget build(BuildContext context) {

//     final provider = Provider.of<AnnouncementProvider>(context);

//     final announcements = provider.announcements.take(5).toList();

//     if (announcements.isEmpty) return const SizedBox();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [

//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Announcements",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const AnnouncementPage(),
//                     ),
//                   );
//                 },
//                 child: const Text("View All"),
//               )
//             ],
//           ),
//         ),

//         const SizedBox(height: 10),

//         SizedBox(
//           height: 140,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: announcements.length,
//             itemBuilder: (context, index) {

//               final ann = announcements[index];

//               return Container(
//                 width: 280,
//                 margin: const EdgeInsets.only(left: 16),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       if (ann.bannerImage != null)
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(16),
//                           ),
//                           child: Image.network(
//                             ann.bannerImage!,
//                             height: 70,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),

//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Text(
//                           ann.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }
// }