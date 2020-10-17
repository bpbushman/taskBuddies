import 'package:flutter/material.dart';
import 'package:taskbuddies/app/locator.dart';
import 'package:taskbuddies/models/sheet_request.dart';
import 'package:taskbuddies/services/bottom_sheet_service.dart';
import 'package:taskbuddies/ui/widgets/helpers.dart';
import 'package:pixel_border/pixel_border.dart';

class BottomSheetManager extends StatefulWidget {
  final Widget child;
  BottomSheetManager({Key key, this.child}) : super(key: key);

  _BottomSheetManagerState createState() => _BottomSheetManagerState();
}

class _BottomSheetManagerState extends State<BottomSheetManager> {
  BottomSheetService _sheetService = locator<BottomSheetService>();
  TextEditingController myController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sheetService.registerBottomSheetListener(_showBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _showBottomSheet(SheetRequest request) {
    bool isTask = request.listTaskToggle;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: PixelBorder(
          borderRadius: BorderRadius.circular(20),
          pixelSize: 5,
          borderColor: Colors.black),
      context: context,
      builder: (context) => Container(
        height: isTask ? 400 : 440,
        child: Column(
          children: [
            isTask
                ? mediumVertSpace()
                : Container(
                    width: 160,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: titleController,
                      autofocus: true,
                      decoration: InputDecoration(labelText: request.title),
                    ),
                  ),
            mediumVertSpace(),
            Container(
              width: 320,
              child: TextFormField(
                autofocus: true,
                controller: myController,
                decoration: InputDecoration(
                  //suffixIcon: Icon(Icons.add),
                  labelText: request.description,
                  focusColor: Colors.grey[200],
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              shape: PixelBorder(
                  borderRadius: BorderRadius.circular(20), pixelSize: 5),
              color: Colors.green,
              onPressed: () {
                _sheetService.bottomSheetComplete(SheetResponse(
                  confirmed: true,
                  fieldOne: myController.text,
                  fieldTwo: titleController.text,
                ));
                myController.clear();
                titleController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                request.buttonTitle,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
