import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  String googleuri = "https://www.google.co.in/";

  // double progressState = 0;

  List<String> bookmarks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.redAccent,
      ),
      onRefresh: () async {
        webViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Website app"),
        actions: [
          IconButton(
            onPressed: () {
              bookmarks.add(urlController.text);

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("$bookmarks".toString())],
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.bookmark_add),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(googleuri),
                    ),
                    initialOptions: options,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    pullToRefreshController: pullToRefreshController,
                    onProgressChanged: (controller, progress) {
                      pullToRefreshController.endRefreshing();
                    },
                    onLoadStart: (controller, url) {
                      urlController.text = url.toString();
                    },
                    onLoadStop: (controller, url) {
                      pullToRefreshController.endRefreshing();
                      urlController.text = url.toString();
                      googleuri = urlController.text;
                    },
                  ),
                  Positioned(
                    top: 630,
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                webViewController?.goBack();
                              },
                              icon: Icon(Icons.arrow_back)),
                          IconButton(
                              onPressed: () {
                                webViewController?.reload();
                              },
                              icon: Icon(Icons.restart_alt_sharp)),
                          IconButton(
                              onPressed: () {
                                webViewController?.goForward();
                              },
                              icon: Icon(Icons.arrow_forward)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
  );
}
