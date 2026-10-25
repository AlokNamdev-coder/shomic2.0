import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Components/duration_picker_bottom_sheet.dart';
import 'package:shomic_2/Screens/SecondaryScreens/audiowaveform.dart';

class TestUploadScreen extends StatefulWidget {
  const TestUploadScreen({super.key});

  @override
  State<TestUploadScreen> createState() => _TestUploadScreenState();
}

class _TestUploadScreenState extends State<TestUploadScreen> {
  String? path;

  Future<String?> getAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      final filepath = result!.files.single.path;
      return filepath;
    } catch (e) {
      customSnackBar(context, text: "Failed to open file");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () async {
                    setState(() async {

                      path = await getAudio();


                    });
                  },
                  child: Container(
                    height: 100,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.add, size: 50),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(path ?? "", style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (path != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => audioWaveform(filepath: path!,initialPixelsPerSecond: 2,),
                      ),
                    );
                  }
                },
                child: Text("Next"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
