import 'dart:io';

import 'package:budgetme/converter_functions/functions.dart';
import 'package:budgetme/model/expenses.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as tp; //tp = ToPdf

class ToPdf{
  final String tableName;
  final List<Expenses> expenseList;

  ToPdf({
    required this.tableName,
    required this.expenseList
  });

  Future<void> saveToPdf() async{
    final pdf = tp.Document();

    pdf.addPage(
      tp.MultiPage(
        build: (context) => [
          _header(context),
          tp.SizedBox(height: 50),
          _tableContent(context),
          tp.SizedBox(height: 5),
          _footNote(context)
        ]
      )
    );

    final dir = await getExternalStorageDirectory();
    final file = File("${dir?.path}/$tableName.pdf");

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes.toList());

    DocumentFileSavePlus().saveMultipleFiles(
      dataList: [pdfBytes],
      fileNameList: ["$tableName.pdf"], 
      mimeTypeList: ["$tableName/pdf"]
    );
  } 

  tp.Widget _header(tp.Context context){
    return tp.Center(
      child: tp.Column(
        mainAxisAlignment: tp.MainAxisAlignment.center,
        crossAxisAlignment: tp.CrossAxisAlignment.center,
        children: [
          tp.Text(
            "Expenses for: $tableName",
            style: tp.TextStyle(
              fontWeight: tp.FontWeight.bold,
              fontSize: 18
            )
          ),
          tp.Text(
            "Type: Cash/Debit/Credit",
            style: tp.TextStyle(
              fontWeight: tp.FontWeight.bold,
              fontSize: 12
            )
          )
        ]
      )
    );
  }

  tp.Widget _tableContent(tp.Context context){
    const headers = [
      'Expenditure Date',
      'Expenses Name',
      'Amount'
    ];

    return tp.Center(
      child: tp.Table(
        border: tp.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          tp.TableRow(
            children: [
              ...headers.map((e) => 
                tp.Column(
                  mainAxisAlignment: tp.MainAxisAlignment.center,
                  children: [
                    tp.Text(
                      e,
                      style: tp.TextStyle(
                        fontWeight: tp.FontWeight.bold,
                        fontSize: 12
                      )
                    )
                  ]
                )
              )
            ]
          ),
          ...expenseList.map((e) => 
            tp.TableRow(
              children: [
                tp.Column(
                  children: [
                    tp.Text(dateFormat(e.date))
                  ]
                ),
                tp.Column(
                  children: [
                    tp.Text(
                      e.name
                    )
                  ]
                ),
                tp.Column(
                  children: [
                    tp.Text(
                      e.amount.toString()
                    )
                  ]
                ),
              ]
            )
          )
        ]
      )
    );
  }

  tp.Widget _footNote(tp.Context context){
    return tp.Text(
      "*Note: The arrangement you are seeing is based on the display on your app.*",
      style: tp.TextStyle(
        fontStyle: tp.FontStyle.italic,
        fontSize: 8,
        fontWeight: tp.FontWeight.bold
      )
    );
  }
}