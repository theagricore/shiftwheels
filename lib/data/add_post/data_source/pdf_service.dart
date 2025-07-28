import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';

class PdfService {
  Future<String> generateComparisonPdf(List<AdWithUserModel> cars) async {
    if (cars.length != 2) {
      throw Exception('Exactly two cars are required for comparison');
    }

    final pdf = pw.Document();

    // Load images for the cars
    final List<pw.ImageProvider?> carImages = [];
    for (var car in cars) {
      if (car.ad.imageUrls.isNotEmpty && car.ad.imageUrls.first.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(car.ad.imageUrls.first));
          if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
            carImages.add(pw.MemoryImage(response.bodyBytes));
          } else {
            carImages.add(null); // Placeholder for failed image
          }
        } catch (e) {
          print('Error loading image for ${car.ad.brand} ${car.ad.model}: $e');
          carImages.add(null); // Placeholder for failed image
        }
      } else {
        carImages.add(null); // Placeholder for no image
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(
              'Car Comparison',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            // Car Images and Names
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children:
                  cars.asMap().entries.map((entry) {
                    final index = entry.key;
                    final car = entry.value;
                    return pw.Container(
                      width: 180,
                      margin: const pw.EdgeInsets.only(right: 12),
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(12),
                      ),
                      child: pw.Column(
                        children: [
                          if (carImages[index] != null)
                            pw.Image(
                              carImages[index]!,
                              height: 100,
                              width: 140,
                              fit: pw.BoxFit.cover,
                            )
                          else
                            pw.Container(
                              height: 100,
                              width: 140,
                              color: PdfColors.grey200,
                              child: pw.Center(
                                child: pw.Text(
                                  'No Image',
                                  style: const pw.TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            '${car.ad.brand.isNotEmpty ? car.ad.brand : "N/A"} ${car.ad.model.isNotEmpty ? car.ad.model : "N/A"}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          pw.Text(
                            '\$${car.ad.price.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              color: PdfColors.green,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            pw.SizedBox(height: 20),
            // Specs Comparison
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FixedColumnWidth(100),
                1: pw.FixedColumnWidth(150),
                2: pw.FixedColumnWidth(150),
              },
              children: [
                // Header
                pw.TableRow(
                  children: [
                    pw.Text(
                      'Specification',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      '${cars[0].ad.brand.isNotEmpty ? cars[0].ad.brand : "N/A"} ${cars[0].ad.model.isNotEmpty ? cars[0].ad.model : "N/A"}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      '${cars[1].ad.brand.isNotEmpty ? cars[1].ad.brand : "N/A"} ${cars[1].ad.model.isNotEmpty ? cars[1].ad.model : "N/A"}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
                // Rows for specs
                ...[
                  {
                    'key': 'Brand',
                    'value1':
                        cars[0].ad.brand.isNotEmpty ? cars[0].ad.brand : 'N/A',
                    'value2':
                        cars[1].ad.brand.isNotEmpty ? cars[1].ad.brand : 'N/A',
                  },
                  {
                    'key': 'Model',
                    'value1':
                        cars[0].ad.model.isNotEmpty ? cars[0].ad.model : 'N/A',
                    'value2':
                        cars[1].ad.model.isNotEmpty ? cars[1].ad.model : 'N/A',
                  },
                  {
                    'key': 'Year',
                    'value1': cars[0].ad.year.toString(),
                    'value2': cars[1].ad.year.toString(),
                  },
                  {
                    'key': 'Fuel',
                    'value1':
                        cars[0].ad.fuelType.isNotEmpty
                            ? cars[0].ad.fuelType
                            : 'N/A',
                    'value2':
                        cars[1].ad.fuelType.isNotEmpty
                            ? cars[1].ad.fuelType
                            : 'N/A',
                  },
                  {
                    'key': 'Transmission',
                    'value1':
                        cars[0].ad.transmissionType.isNotEmpty
                            ? cars[0].ad.transmissionType
                            : 'N/A',
                    'value2':
                        cars[1].ad.transmissionType.isNotEmpty
                            ? cars[1].ad.transmissionType
                            : 'N/A',
                  },
                  {
                    'key': 'Kilometers Driven',
                    'value1': cars[0].ad.kmDriven.toString(),
                    'value2': cars[1].ad.kmDriven.toString(),
                  },
                  {
                    'key': 'No. of Owners',
                    'value1': cars[0].ad.noOfOwners.toString(),
                    'value2': cars[1].ad.noOfOwners.toString(),
                  },
                  {
                    'key': 'Price',
                    'value1': '\$${cars[0].ad.price.toStringAsFixed(2)}',
                    'value2': '\$${cars[1].ad.price.toStringAsFixed(2)}',
                  },
                  {
                    'key': 'Posted Date',
                    'value1': cars[0].ad.postedDate.toIso8601String(),
                    'value2': cars[1].ad.postedDate.toIso8601String(),
                  },
                ].map((spec) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          spec['key']!,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          spec['value1']!,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          spec['value2']!,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Generated by ShiftWheels',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              textAlign: pw.TextAlign.center,
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/car_comparison_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<void> sharePdf(String filePath) async {
    if (!await File(filePath).exists()) {
      throw Exception('PDF file does not exist at path: $filePath');
    }
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Check out this car comparison from ShiftWheels!',
      subject: 'Car Comparison PDF',
    );
  }
}
