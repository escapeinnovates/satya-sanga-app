import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:satya_sang/features/home/announcement_model.dart';

void showAnnouncementModal(BuildContext context, Announcement announcement) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.70,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              15,
              20,
              MediaQuery.of(context).viewPadding.bottom - 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                /// TITLE
                Text(
                  announcement.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                /// SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        if (announcement.bannerImage != null &&
                            announcement.bannerImage!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              announcement.bannerImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,

                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Container(
                                  height: 180,
                                  alignment: Alignment.center,
                                  child:
                                      const CircularProgressIndicator(),
                                );
                              },

                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 20),

                        /// HTML MESSAGE
                        Html(
                          data: announcement.message,
                          style: {
                            "body": Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.6),
                            ),

                            "h1": Style(display: Display.none),
                            "h2": Style(display: Display.none),
                            "h3": Style(display: Display.none),
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}