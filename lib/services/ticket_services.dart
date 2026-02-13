import 'dart:typed_data';
import 'dart:html' as html;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketServices {
  Future<void> downloadTicketPDF({
    required String eventName,
    required String userName,
    required String ticketId,
    required String eventDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    eventName,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text("Name: $userName"),
                  pw.Text("Ticket ID: $ticketId"),
                  pw.Text("Date: $eventDate"),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Please show this ticket at the event entrance.",
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "event_ticket.pdf")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
