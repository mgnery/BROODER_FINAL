import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/models.dart';

class PdfGenerator {
  /// Generates a PDF and opens the system Print/Preview dialog.
  /// From there, the user can select "Save as PDF" or "Print".
  static Future<void> generateAndShowReport({
    required List<WeekData> history,
    required String dateStarted,
    required String sessionDuration,
  }) async {
    final pdf = pw.Document();

    // Add content to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Brooder System Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Session Info
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Session Details', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(color: PdfColors.grey300),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Brooder Started: $dateStarted'),
                      pw.Text('Duration: $sessionDuration'),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text('Total Records: ${history.length} weeks'),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Data Table
            pw.Text('History Data', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            
            if (history.isEmpty)
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(20),
                child: pw.Text('No data recorded for this session.'),
              )
            else
              pw.TableHelper.fromTextArray(
                headers: ['Week', 'Avg Temp', 'Avg Humidity', 'Target Temp'],
                data: history.map((data) => [
                  data.week,
                  '${data.avgTemp.toStringAsFixed(1)} °C',
                  '${data.avgHumidity.toStringAsFixed(1)} %',
                  '${data.targetTemp.toStringAsFixed(0)} °C',
                ]).toList(),
                border: pw.TableBorder.all(color: PdfColors.grey400),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.orange500),
                cellAlignment: pw.Alignment.center,
              ),
              
            pw.Footer(
              margin: const pw.EdgeInsets.only(top: 20),
              leading: pw.Text('Brooder Monitor App'),
            ),
          ];
        },
      ),
    );

    // Open Print Preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Brooder_Report_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}