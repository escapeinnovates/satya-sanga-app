import 'package:flutter/material.dart';




class SectionDetailPage extends StatefulWidget {
  final String title;

  const SectionDetailPage({super.key, required this.title});

  @override
  State<SectionDetailPage> createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {
  dynamic section;
  String content = 'Loading...';
  double _fontSize = 18;

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange.shade800,
      ),
      body: section == null
          ? Center(child: Text(content))
          : section.containsKey('subsections')
              ? ListView.builder(
                  itemCount: section['subsections'].length,
                  itemBuilder: (context, index) {
                    var subsection = section['subsections'][index];
                    return ListTile(
                      title: Text(subsection['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SectionDetailPage(title: subsection['title']),
                          ),
                        );
                      },
                    );
                  },
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: Colors.orange.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.zoom_out),
                          Expanded(
                            child: Slider(
                              min: 14,
                              max: 36,
                              divisions: 22,
                              value: _fontSize,
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.zoom_in),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          content,
                          style: TextStyle(
                            fontSize: _fontSize,
                            height: 1.8,
                            fontFamily: 'NotoSansDevanagari',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
