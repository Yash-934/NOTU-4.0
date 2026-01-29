
import 'package:html/parser.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:notu/models/chapter.dart';
import 'package:markdown/markdown.dart' as md;

class PdfGenerator {
  static Future<void> generate(String title, String content, ContentType contentType) async {
    final pdf = pw.Document();

    String plainTextContent;
    if (contentType == ContentType.html) {
      final document = parse(content);
      plainTextContent = document.body!.text;
    } else if (contentType == ContentType.markdown) {
      // Convert markdown to HTML, then parse to plain text
      final html = md.markdownToHtml(content);
      final document = parse(html);
      plainTextContent = document.body!.text;
    } else {
      plainTextContent = content;
    }

    final notoColorEmoji = await PdfGoogleFonts.notoColorEmoji();
    final notoSans = await PdfGoogleFonts.notoSansRegular();
    final notoSansItalic = await PdfGoogleFonts.notoSansItalic();
    final notoSansBold = await PdfGoogleFonts.notoSansBold();
    final notoSansBoldItalic = await PdfGoogleFonts.notoSansBoldItalic();
    final notoSansDevanagari = await PdfGoogleFonts.notoSansDevanagariRegular();

    final theme = pw.ThemeData.withFont(
      base: notoSans,
      italic: notoSansItalic,
      bold: notoSansBold,
      boldItalic: notoSansBoldItalic,
      fontFallback: [notoSansDevanagari, notoColorEmoji],
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 16),
            pw.Paragraph(text: plainTextContent),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
