import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:receipt_gen/interfaces/receipt_generator.dart';
import 'package:receipt_gen/models/receipt_model.dart';

class ReceiptGenerator implements IReceiptGenerator {
  @override
  Future<void> generateReceiptPdf(ChargeReceipt receipt) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: const PdfColor.fromInt(0xFF0000FF), width: 2.0),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Icon(
                  const pw.IconData(0xe865),
                  size: 40,
                  color: const PdfColor.fromInt(0xFF0000FF),
                ),
                pw.SizedBox(height: 8.0),
                pw.Text(
                  'Receipt for Charging',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16.0),
                _buildPdfReceiptRow('Station Name:', 'EVCharge'),
                _buildPdfReceiptRow('Location:', 'Varazdin'),
                _buildPdfReceiptRow('Start Date and Time:', receipt.startTime),
                _buildPdfReceiptRow('End Date and Time:', receipt.timeOfIssue),
                _buildPdfReceiptRow('Electricity Consumed (kWh):', receipt.volume.toString()),
                _buildPdfReceiptRow('Price per kWh:', receipt.pricePerKwh.toString()),
                pw.Divider(height: 20, color: const PdfColor.fromInt(0xFF0000FF)),
                _buildPdfReceiptRow('Total Charge Cost:', receipt.price.toString(), fontWeight: pw.FontWeight.bold),
                pw.SizedBox(height: 16.0),
                _buildPdfReceiptRow('Receipt ID:', receipt.id.toString()),
                pw.SizedBox(height: 24.0),
                pw.Text('Thank you for using our electric vehicle charger!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8.0),
                pw.Text('Please come back and use us again soon!'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildPdfReceiptRow(String label, String value, {pw.FontWeight fontWeight = pw.FontWeight.normal}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 8.0),
        pw.Text(value, style: pw.TextStyle(fontWeight: fontWeight)),
      ],
    );
  }
}
