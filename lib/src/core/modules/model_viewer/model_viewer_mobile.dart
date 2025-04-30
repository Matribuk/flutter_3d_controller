import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io' show File, HttpServer, HttpStatus, InternetAddress;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'html_builder.dart';
import 'model_viewer.dart';

class ModelViewerState extends State<ModelViewer> {
  HttpServer? _proxy;
  late String _proxyURL;
  bool isLoaded = false;
  final GlobalKey _webViewKey = GlobalKey();
  final GlobalKey _holderKey = GlobalKey();
  InAppWebViewController? _inAppWebViewController;

  /// Because some other packages, such as o*d, copied and used my package code
  /// in previous versions without permission or proper licensing,
  /// I decided to encrypt the critical JavaScript code of my
  /// [Flutter 3D Controller] package. Although it’s an open-source project,
  /// But I have invested significant time and effort into adding new features,
  /// such as the 'Gesture Interceptor' feature on version 2.0.0,
  /// which was released on October 5, 2024.
  /// Therefore, I cannot allow others to easily copy and use my code and ideas
  /// without properly crediting my package and adhering to the appropriate
  /// licensing terms.

  Future<void> registerModelViewerEventListener(String key, String id) async {}

  @override
  void initState() {
    super.initState();
    unawaited(_initProxy());
  }

  @override
  void dispose() {
    if (_proxy != null) {
      unawaited(_proxy!.close(force: true));
      _proxy = null;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ModelViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      isLoaded = false;
      unawaited(
        _initProxy().then((_) {
          _inAppWebViewController?.reload();
        }),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (_proxy == null) {
      return Container();
    }
    return SizedBox(
      key: _holderKey, //const Key('f3dc_holder'),
      child: InAppWebView(
        key: _webViewKey,
        initialSettings: InAppWebViewSettings(transparentBackground: true),
        initialUrlRequest: URLRequest(url: WebUri(_proxyURL)),
        onWebViewCreated: (controller) {
          _inAppWebViewController = controller;
          _registerJsChannels(controller);
          widget.onWebViewCreated?.call(controller);
        },
        onLoadStop: (controller, url) async {},
      ),
    );
  }

  Future<void> _initProxy() async {
    _proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);

    setState(() {
      final host = _proxy!.address.address;
      final port = _proxy!.port;
      _proxyURL = 'http://$host:$port/';
    });

    _proxy!.listen((request) async {
      final url = Uri.parse(widget.src);
      final response = request.response;

      switch (request.uri.path) {
        case '/':
        case '/index.html':
          final htmlTemplate = await rootBundle.loadString(
            'packages/flutter_3d_controller/assets/model_viewer_template.html',
          );
          final html = utf8.encode(_buildHTML(htmlTemplate));
          response
            ..statusCode = HttpStatus.ok
            ..headers.add('Content-Type', 'text/html;charset=UTF-8')
            ..headers.add('Content-Length', html.length.toString())
            ..add(html);
          await response.close();
        case '/model_viewer.min.js':
          final code = await _readAsset(
            'packages/flutter_3d_controller/assets/model_viewer.min.js',
          );
          response
            ..statusCode = HttpStatus.ok
            ..headers.add(
              'Content-Type',
              'application/javascript;charset=UTF-8',
            )
            ..headers.add('Content-Length', code.lengthInBytes.toString())
            ..add(code);
          await response.close();
        case '/model':
          if (url.isAbsolute && !url.isScheme('file')) {
            await response.redirect(url);
          } else {
            final data =
                await (url.isScheme('file')
                    ? _readFile(url.path)
                    : _readAsset(url.path));
            response
              ..statusCode = HttpStatus.ok
              ..headers.add('Content-Type', 'application/octet-stream')
              ..headers.add('Content-Length', data.lengthInBytes.toString())
              ..headers.add('Access-Control-Allow-Origin', '*')
              ..add(data);
            await response.close();
          }
        case '/favicon.ico':
          final text = utf8.encode("Resource '${request.uri}' not found");
          response
            ..statusCode = HttpStatus.notFound
            ..headers.add('Content-Type', 'text/plain;charset=UTF-8')
            ..headers.add('Content-Length', text.length.toString())
            ..add(text);
          await response.close();
        default:
          if (request.uri.isAbsolute) {
            debugPrint('Redirect: ${request.uri}');
            await response.redirect(request.uri);
          } else if (request.uri.hasAbsolutePath) {
            // Some gltf models need other resources from the origin
            final pathSegments = [...url.pathSegments]..removeLast();
            final tryDestination = p.joinAll([
              url.origin,
              ...pathSegments,
              request.uri.path.replaceFirst('/', ''),
            ]);
            debugPrint('Try: $tryDestination');
            await response.redirect(Uri.parse(tryDestination));
          } else {
            debugPrint('404 with ${request.uri}');
            final text = utf8.encode("Resource '${request.uri}' not found");
            response
              ..statusCode = HttpStatus.notFound
              ..headers.add('Content-Type', 'text/plain;charset=UTF-8')
              ..headers.add('Content-Length', text.length.toString())
              ..add(text);
            await response.close();
            break;
          }
      }
    });
  }

  Future<void> _registerJsChannels(
    InAppWebViewController webViewController,
  ) async {
    //js DOM channel
    webViewController.addJavaScriptHandler(
      handlerName: "jsDOMChannel",
      callback: (args) async {
        await registerModelViewerEventListener(
          'flutter-3d-controller',
          widget.id.toString(),
        );
      },
    );
    //js debugger channel
    webViewController.addJavaScriptHandler(
      handlerName: "jsDebuggerChannel",
      callback: (args) {
        debugPrint('flutter_3d_controller debugger: ${args.first}');
      },
    );
    // onProgress channel
    webViewController.addJavaScriptHandler(
      handlerName: "onProgressChannel",
      callback: (args) {
        final progress = double.tryParse(args.first.toString()) ?? 0;
        if (progress == 0 || progress == 1) {
          return;
        }
        widget.onProgress?.call(progress);
      },
    );
    // onLoad channel
    webViewController.addJavaScriptHandler(
      handlerName: "onLoadChannel",
      callback: (args) async {
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onProgress?.call(1.0);
        widget.onLoad?.call(args.first == '/model' ? widget.src : args.first);
        isLoaded = true;
      },
    );
    // onError channel
    webViewController.addJavaScriptHandler(
      handlerName: "onErrorChannel",
      callback: (args) {
        widget.onError?.call(
          args.first.toString() == '{}'
              ? 'Failed to load'
              : args.first.toString(),
        );
      },
    );
    // pointer channel
    webViewController.addJavaScriptHandler(
      handlerName: "pointerChannel",
      callback: (args) async {
        List<String> coordinates = args.first.toString().split(',');
        bool result = isOutTouch(
          double.tryParse(coordinates[0]) ?? 0,
          double.tryParse(coordinates[1]) ?? 0,
        );
      },
    );
  }

  bool isOutTouch(double touchX, double touchY) {
    bool result = true;

    // Convert WebView coordinates to screen coordinates
    final RenderBox renderBox =
        _webViewKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    double screenX = position.dx + touchX;
    double screenY = position.dy + touchY;
    final screenOffset = Offset(screenX, screenY);

    // Perform a hit test at the given screenOffset
    final HitTestResult hitTestResult = HitTestResult();

    final int viewId =
        RendererBinding.instance.platformDispatcher.views.first.viewId;
    RendererBinding.instance.hitTestInView(hitTestResult, screenOffset, viewId);

    // Iterate through the hit test path
    for (final HitTestEntry entry in hitTestResult.path) {
      final HitTestTarget renderObject = entry.target;
      if (renderObject is RenderBox) {
        if (_holderKey.currentContext?.findRenderObject() == renderObject) {
          result = false;
          break;
        }
      }
    }

    return result;
  }

  Future<Uint8List> _readAsset(final String key) async {
    final data = await rootBundle.load(key);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _readFile(final String path) async {
    return File(path).readAsBytes();
  }

  String _buildHTML(String htmlTemplate) {
    return HTMLBuilder.build(
      htmlTemplate: htmlTemplate,
      src: '/model',
      alt: widget.alt,
      poster: widget.poster,
      loading: widget.loading,
      reveal: widget.reveal,
      withCredentials: widget.withCredentials,
      // AR Attributes
      ar: widget.ar,
      arModes: widget.arModes,
      arScale: widget.arScale,
      arPlacement: widget.arPlacement,
      iosSrc: widget.iosSrc,
      xrEnvironment: widget.xrEnvironment,
      // Cameras Attributes
      cameraControls: false,
      disablePan: true,
      disableTap: true,
      touchAction: TouchAction.none,
      disableZoom: true,
      orbitSensitivity: widget.orbitSensitivity,
      autoRotate: widget.autoRotate,
      autoRotateDelay: widget.autoRotateDelay,
      rotationPerSecond: widget.rotationPerSecond,
      interactionPrompt: widget.interactionPrompt,
      interactionPromptStyle: widget.interactionPromptStyle,
      interactionPromptThreshold: widget.interactionPromptThreshold,
      cameraOrbit: widget.cameraOrbit,
      cameraTarget: widget.cameraTarget,
      fieldOfView: widget.fieldOfView,
      maxCameraOrbit: widget.maxCameraOrbit,
      minCameraOrbit: widget.minCameraOrbit,
      maxFieldOfView: widget.maxFieldOfView,
      minFieldOfView: widget.minFieldOfView,
      interpolationDecay: widget.interpolationDecay,
      // Lighting & Env Attributes
      skyboxImage: widget.skyboxImage,
      environmentImage: widget.environmentImage,
      exposure: widget.exposure,
      shadowIntensity: widget.shadowIntensity,
      shadowSoftness: widget.shadowSoftness,
      // Animation Attributes
      animationName: widget.animationName,
      animationCrossfadeDuration: widget.animationCrossfadeDuration,
      autoPlay: widget.autoPlay,
      // Materials & Scene Attributes
      variantName: widget.variantName,
      orientation: widget.orientation,
      scale: widget.scale,
      // CSS Styles
      backgroundColor: widget.backgroundColor,
      // Default progress bar color
      progressBarColor: widget.progressBarColor,
      // Annotations CSS
      minHotspotOpacity: widget.minHotspotOpacity,
      maxHotspotOpacity: widget.maxHotspotOpacity,
      // Others
      innerModelViewerHtml: widget.innerModelViewerHtml,
      relatedCss: widget.relatedCss,
      relatedJs: widget.relatedJs,
      id: widget.id,
      debugLogging: widget.debugLogging,
    );
  }
}
