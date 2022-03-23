import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:iwdweb/helpers/utils.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TextEditingService()
        ),
        ChangeNotifierProvider(
          create: (_) => BackgroundEditingService()
        ),
        ChangeNotifierProvider(
          create: (_) => CustomImageService()
        )
      ],
      child: const IWDApp()
    )
  );
}

class IWDApp extends StatelessWidget {

  const IWDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Product Sans'
      ),
      home: const IWDSplash()
    );
  }
}

class IWDSplash extends StatefulWidget {
  const IWDSplash({Key? key}) : super(key: key);

  @override
  State<IWDSplash> createState() => _IWDSplashState();
}

class _IWDSplashState extends State<IWDSplash> with TickerProviderStateMixin {

  AnimationController? anim;

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
  }
  @override 
  Widget build(BuildContext context) {

    anim!.forward();

    Future.delayed(const Duration(seconds: 3), () {
      anim!.reverse().whenComplete(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IWDHome())
        );
      });
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A84E5),
              Color(0xFF0FD5CC)
            ]
          )
        ),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: anim!, curve: Curves.easeInOut)),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.25),
                  end: const Offset(0.0, 0.0))
                .animate(CurvedAnimation(parent: anim!, curve: Curves.easeInOut)),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.5)),
                          strokeWidth: 10,
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset('assets/imgs/wtm_white.png',
                          width: 50, height: 50, fit: BoxFit.contain
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}

class IWDHome extends StatefulWidget {
  const IWDHome({Key? key}) : super(key: key);

  @override
  State<IWDHome> createState() => _IWDHomeState();
}

class _IWDHomeState extends State<IWDHome> {

  GlobalKey imgGlobalKey = GlobalKey();
  TextEditingController? textController;
  TextEditingController? nameController;

  @override 
  void initState() {
    super.initState();

    textController = TextEditingController();
    nameController = TextEditingController();
  }

  void _capturePng() async {
    try {
      RenderRepaintBoundary boundary = imgGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      final _base64 = base64Encode(pngBytes);
      final anchor =
          html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
            ..download = "nft-image-gdg-ne-iwd.png"
            ..target = 'blank';
    
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Utils.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/imgs/nftimagetitle.png', width: 350),
                    const SizedBox(height: 10),
                    Image.asset('assets/imgs/gdg_ne.png', width: 250),
                  ]
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Utils.launchUrl('https://developers.google.com/community-guidelines');
                    },
                    child: Image.asset('assets/imgs/codeconduct.png', width: 200)
                  ),
                )
              ],
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text('Enter your IWD Quote:',
                                        style: TextStyle(color: Utils.blue)
                                      ),
                                      TextField(
                                        controller: textController,
                                        onChanged: (value) {
                                          var teService = Provider.of<TextEditingService>(context, listen: false);
                                          var ciService = Provider.of<CustomImageService>(context, listen: false);
                                          ciService.resetUploadedImage();

                                          teService.iwdQuote = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text('Enter an author name for your quote:',
                                        style: TextStyle(color: Utils.blue)
                                      ),
                                      TextField(
                                        controller: nameController,
                                        onChanged: (value) {
                                          var teService = Provider.of<TextEditingService>(context, listen: false);
                                          var ciService = Provider.of<CustomImageService>(context, listen: false);
                                          ciService.resetUploadedImage();
                                          
                                          teService.iwdAuthor = value;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: Consumer<BackgroundEditingService>(
                                  builder: (context, bgService, child) {
                                    return Column(
                                      children: [
                                        ...List.generate(bgService.templateList.length, 
                                        (index) {
                                                
                                          var tmpl = bgService.templateList[index];
                                                
                                          return MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                var ciService = Provider.of<CustomImageService>(context, listen: false);
                                                ciService.resetUploadedImage();

                                                var bgService = Provider.of<BackgroundEditingService>(context, listen: false);
                                                bgService.template = tmpl;
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(10),
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      blurRadius: 15,
                                                      offset: Offset.zero
                                                    )
                                                  ],
                                                  border: Border.all(
                                                    width: 5,
                                                    color: tmpl.isSelected! ? Utils.purple : Colors.transparent,
                                                  ),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/imgs/${tmpl.thumbName!}.png'),
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                              onTap: () async {
                                                var picked = await FilePicker.platform.pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: ['jpg', 'png']
                                                );

                                                if (picked != null) {
                                                  Uint8List fileBytes = picked.files.first.bytes!;

                                                  var customImageService = Provider.of<CustomImageService>(context, listen: false);
                                                  customImageService.setUploadedImage(fileBytes);
                                                }
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.all(10),
                                                    width: 60,
                                                    height: 60,
                                                    child: const Icon(Icons.image, color: Colors.grey),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(15),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.2),
                                                              blurRadius: 15,
                                                              offset: Offset.zero
                                                            )
                                                          ],
                                                          border: Border.all(
                                                            width: 5,
                                                            color: Colors.grey,
                                                      ),
                                                      
                                                    ),
                                                  ),
                                                  const Text('Add Image', textAlign: TextAlign.center)
                                                ],
                                              ),
                                            ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Column(
                                children: [
                                  RepaintBoundary(
                                  key: imgGlobalKey,
                                    child: Container(
                                      padding: const EdgeInsets.all(40),
                                      width: 450,
                                      height: 450,
                                      child: Stack(
                                        children: [
                                          Consumer<BackgroundEditingService>(
                                            builder: (context, beService, child) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 20,
                                                        offset: Offset.zero
                                                      )
                                                    ],
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/imgs/${beService.template.imgName}.png')
                                                    )
                                                  ),
                                                );
                                            }
                                          ),
                                          Consumer<BackgroundEditingService>(
                                            builder: (context, beService, child) {
                                              return Consumer<TextEditingService>(
                                                builder: (context, teService, child) {
                                                
                                                  String quoteText = '';
                                                  String authorText = '';
                                                
                                                  if (teService.isCustomQuote) {
                                                    quoteText = teService.iwdQuote;
                                                    authorText = teService.iwdAuthor;
                                                  }
                                                  else {
                                                    quoteText = teService.selectedCustomQuote!.phrase!;
                                                    authorText = teService.selectedCustomQuote!.author!;
                                                  }
                                                
                                                  return Padding(
                                                      padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0, top: 100.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            quoteText,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 6,
                                                            style: TextStyle(
                                                              color: beService.template.color!,
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.bold
                                                            )
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            authorText,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: beService.template.color!,
                                                                fontSize: 20,
                                                                fontStyle: FontStyle.italic
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                }
                                              );
                                            },
                                          ),
                                          Consumer<CustomImageService>(
                                            builder: (context, ciService, child) {
                                              return LayoutBuilder(
                                                builder: ((context, constraints) {
                                                  return ciService.uploadedImg == null ?
                                                    const SizedBox() :
                                                    Container(
                                                      color: Colors.white,
                                                      width: constraints.maxWidth,
                                                      height: constraints.maxHeight,
                                                      child: DraggableImageRegion(
                                                        img: ciService.uploadedImg,
                                                        width: constraints.maxWidth,
                                                        height: constraints.maxHeight
                                                      )
                                                    );
                                                  }
                                                )
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(20),
                                    clipBehavior: Clip.antiAlias,
                                    color: Utils.blue,
                                    child: InkWell(
                                      highlightColor: Colors.white.withOpacity(0.1),
                                      splashColor: Colors.white.withOpacity(0.1),
                                      onTap: () {
                                        _capturePng();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.download_rounded, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text('Download Image', 
                                              style: TextStyle(fontSize: 20, color: Colors.white)
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  )
                                ],
                              ),
                              const Expanded(child: QuotesList())
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Utils.launchUrl('https://flutter.dev/');
                    },
                    child: Image.asset('assets/imgs/builtwithflutter.png', width: 200)
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}

class TextEditingService extends ChangeNotifier {

  String defaultQuote = 'Progress Not Perfection';
  String defaultAuthor = 'IWD';
  String _iwdQuote = '';
  String _iwdAuthor = '';

  String get iwdQuote => _iwdQuote;
  String get iwdAuthor => _iwdAuthor;

  bool isCustomQuote = true;
  DefaultQuote? selectedCustomQuote;

  TextEditingService() {
    iwdQuote = defaultQuote;
  }

  set iwdQuote(String value) {
    isCustomQuote = true;
    _iwdQuote = value.isEmpty ? defaultQuote : value;
    notifyListeners();
  }

  set iwdAuthor(String value) {
    isCustomQuote = true;
    _iwdAuthor = value;
    notifyListeners();
  }

  setCustomQuote(DefaultQuote quote) {
    isCustomQuote = false;
    selectedCustomQuote = quote;
    notifyListeners();
  }
}

class BackgroundEditingService extends ChangeNotifier {

  List<BackgroundTemplate> templateList = Utils.getTemplateList();

  BackgroundTemplate defaultTemplate = BackgroundTemplate(
    thumbName: 'thumb1', imgName: 'template1', color: Utils.darkColor, isSelected: true
  );

  BackgroundTemplate? _tmpl;
  BackgroundTemplate get template => _tmpl!;

  BackgroundEditingService() {
    _tmpl = defaultTemplate;
  }

  set template(BackgroundTemplate value) {
    _tmpl = value;
    setTemplateSelection(value);
    notifyListeners();
  }

  void setTemplateSelection(BackgroundTemplate tmp) {
    for(var t in templateList) {
      t.isSelected = tmp == t;
    }
  }
}

class DraggableImageRegion extends StatefulWidget {

  final double? width;
  final double? height;
  final Uint8List? img;

  const DraggableImageRegion({ this.width, this.height, this.img });

  @override
  State<DraggableImageRegion> createState() => _DraggableImageRegionState();
}

class _DraggableImageRegionState extends State<DraggableImageRegion> {

  Offset? position;
  final GlobalKey stackKey = GlobalKey();
  double scale = 1.0;
  bool showControls = false;
  double wWidth = 0;
  double wHeight = 0;
  double sizeIncrements = 20;

  @override
  void initState() {
    super.initState();

    wWidth = widget.width!;
    wHeight = widget.height!;

    position = Offset(20.0, wHeight - (wHeight / 2) - 20);
  }

  @override
  Widget build(BuildContext context) {

    var imgWidth = wWidth / 2;
    var imgHeight = wHeight / 2;

    var img = Image.memory(widget.img!,
      width: imgWidth,
      height: imgHeight,
      fit: BoxFit.contain
    );

    var sizableImg = MouseRegion(
      onEnter: (event) {
        setState(() {
          showControls = true;
        });
      },
      onExit: (event) {
        setState(() {
          showControls = false;
        });
      },
      child: SizedBox(
        child: Stack(
          children: [
            img,
            Align(
              alignment: Alignment.bottomLeft,
              child: Visibility(
                visible: showControls,
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          var customImageService = Provider.of<CustomImageService>(context, listen: false);
                          customImageService.resetUploadedImage();
                        },
                        child: ClipOval(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            color: Utils.blue,
                            child: const Icon(Icons.delete_forever, color: Colors.white)
                          )),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            wWidth += sizeIncrements;
                            wHeight += sizeIncrements;
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            color: Utils.blue,
                            child: const Icon(Icons.zoom_in, color: Colors.white)
                          )),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            wWidth -= sizeIncrements;
                            wHeight -= sizeIncrements;
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            color: Utils.blue,
                            child: const Icon(Icons.zoom_out, color: Colors.white)
                          )),
                      ),
                    )
                  ],
                ),
              )
            )
          ]
        ),
      )
    );

    return SizedBox(
      width: wWidth,
      height: wHeight,
      child: Stack(
        key: stackKey,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: position!.dy, 
            left: position!.dx,
            child: Draggable(
              feedback: Opacity(
                opacity: 0.5,
                child: sizableImg,
              ),
              child: sizableImg,
              onDragEnd: (DraggableDetails details) {

                final parentPos = stackKey.globalPaintBounds;

                if ((details.offset.dx < parentPos!.left || details.offset.dy < parentPos.top)
                || (details.offset.dx > parentPos.left + imgWidth || details.offset.dy > parentPos.top + imgHeight)) {
                  return;
                }

                setState(() {
                  
                  var newPos = Offset(
                    details.offset.dx - parentPos.left,
                    details.offset.dy - parentPos.top
                  );

                  position = newPos;
                });
              }
            )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Image.asset('assets/imgs/wtm_logo_circle.png',
                width: 60, height: 60, fit: BoxFit.contain
              ),
            )
          )
        ]
      ),
    );
  }
}

class CustomImageService extends ChangeNotifier {

  Uint8List? uploadedImg;

  void setUploadedImage(Uint8List img) {
    uploadedImg = img;
    notifyListeners();
  }

  void resetUploadedImage() {
    uploadedImg = null;
    notifyListeners();
  }
}

class QuotesList extends StatefulWidget {
  const QuotesList({Key? key}) : super(key: key);

  @override 
  QuotesListState createState() => QuotesListState();
}

class QuotesListState extends State<QuotesList> {

  List<DefaultQuote> quotesList = [];
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    quotesList = Utils.getDefaultQuotes();
    scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override 
  Widget build(BuildContext context) {

    return Consumer<TextEditingService>(
      builder: (context, teService, child) {

        if (teService.isCustomQuote) {
          for (var element in quotesList) {
            element.isSelected = false;
          }
        }

        return LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
          height: 400,
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Or select from the quotes below: (${quotesList.length})'),
              const SizedBox(height: 10),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(right: 20),
                    itemCount: quotesList.length,
                    itemBuilder: (context, index) {
                
                    var quote = quotesList[index];
                
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          for (var element in quotesList) {
                            element.isSelected = element == quote;
                          }
                
                          var teService = Provider.of<TextEditingService>(context, listen: false);
                          teService.setCustomQuote(quote);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: quote.isSelected! ? Utils.purple : Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quote.phrase!, style: TextStyle(
                              color: quote.isSelected! ? Colors.white : Colors.black
                            )),
                            const SizedBox(height: 5),
                            Text(quote.author!, style: TextStyle(
                              color: quote.isSelected! ? Colors.white : Utils.blue,
                              fontStyle: ui.FontStyle.italic))
                          ],
                        ),
                      ),
                    );
                  }
                 ),
                ),
              )
            ],
          ),
        );
        } 
        );
      },
    );
  }
}

// A useful extention for getting absolute coordinates of a widget 
// (found somewhere in SO)
extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
