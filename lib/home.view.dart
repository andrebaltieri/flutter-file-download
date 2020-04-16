import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String fileToDownload = "SEUAQRUIVO.mp4";

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double percent = 0;
  String path = "";
  var cancelToken = CancelToken();

  download() async {
    percent = 0;

    path = join(
      (await getTemporaryDirectory()).path,
      'video.mp4',
    );

    await Dio().download(
      fileToDownload,
      path,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            percent = (received / total * 100);
          });
        }
      },
    );
  }

  cancel() {
    cancelToken.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("File Downloader"),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 260,
          ),
          Text((percent).toStringAsFixed(0) + "%"),
          SizedBox(
            height: 10,
          ),
          CupertinoButton.filled(
            child: Text("Download"),
            onPressed: download,
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoButton.filled(
            child: Text("Cancelar"),
            onPressed: cancel,
          ),
          SizedBox(
            height: 20,
          ),
          percent >= 100 ? Text(path) : Text("Carregando...")
        ],
      ),
    );
  }
}
