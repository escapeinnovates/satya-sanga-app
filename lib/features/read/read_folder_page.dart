// import 'package:flutter/material.dart';
// import '../../app_layout.dart';
// import 'read_service.dart';
// import 'PDFViewerPage.dart';

// class ReadFolderPage extends StatefulWidget {
//   final String folderId;
//   final String folderName;

//   const ReadFolderPage({
//     super.key,
//     required this.folderId,
//     required this.folderName,
//   });

//   @override
//   State<ReadFolderPage> createState() => _ReadFolderPageState();
// }

// class _ReadFolderPageState extends State<ReadFolderPage> {
//   late Future<List<dynamic>> _folderItemsFuture;

//   @override
//   void initState() {
//     super.initState();

//     // ✅ Backend call happens ONCE when page opens
//     // _folderItemsFuture = ReadService.fetchReadItems(widget.folderId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.folderName)),
//       body: FutureBuilder<List<dynamic>>(
//         future: _folderItemsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No files found"));
//           }

//           final items = snapshot.data!;

//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               final isFolder =
//                   item['mimeType'] == 'application/vnd.google-apps.folder';

//               return ListTile(
//                 leading: Icon(
//                   isFolder ? Icons.folder : Icons.picture_as_pdf,
//                   color: isFolder ? Colors.blue : Colors.red,
//                 ),
//                 title: Text(item['name']),
//                 trailing: Icon(
//                   isFolder ? Icons.arrow_forward_ios : Icons.picture_as_pdf,
//                 ),
//                 onTap: () {
//                   if (isFolder) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ReadFolderPage(
//                           folderId: item['id'],
//                           folderName: item['name'],
//                         ),
//                       ),
//                     );
//                   } else {
//                     final String url =
//                         "https://drive.google.com/uc?export=download&id=${item['id']}";

//                     final String title = item['name']
//                         .toString()
//                         .replaceAll('.pdf', '')
//                         .replaceAll('.PDF', '');

//                     // ✅ Use Navigator, NOT AppLayout
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => PDFViewerPage(url: url, title: title),
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
