
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:notu/models/chapter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generate(String title, String content, ContentType contentType) async {
    final pdf = pw.Document();

    String htmlContent;
    if (contentType == ContentType.markdown) {
      htmlContent = md.markdownToHtml(content);
    } else {
      htmlContent = content;
    }

    // Convert HTML to a list of PDF widgets
    final List<pw.Widget> widgets = await HTMLToPdf().convert(htmlContent);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 16),
            // Add the generated widgets to the page
            ...widgets,
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
