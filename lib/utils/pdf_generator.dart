
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:notu/models/chapter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:markdown/markdown.dart' as md;

class PdfGenerator {
  static Future<void> generate(String title, String content, ContentType contentType) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle the case where the user denies permission
      return;
    }

    String htmlContent;
    if (contentType == ContentType.markdown) {
      htmlContent = md.markdownToHtml(content);
    } else {
      htmlContent = content;
    }

    final fullHtml = """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Noto+Sans&family=Noto+Serif+Devanagari&display=swap');
          body {
            font-family: 'Noto Sans', sans-serif;
          }
          h1 {
            font-family: 'Noto Serif Devanagari', serif;
          }
        </style>
      </head>
      <body>
        <h1>$title</h1>
        $htmlContent
      </body>
    </html>
    """;

    final targetPath = await _getDownloadPath();
    final targetFileName = "notu_export_${DateTime.now().millisecondsSinceEpoch}";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      fullHtml,
      targetPath,
      targetFileName,
    );
    OpenFilex.open(generatedPdfFile.path);
  }

  static Future<String> _getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      // Cannot get download folder path
    }
    return directory!.path;
  }
}
