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

  Future<void> registerModelViewerEventListener(String key, String id) async {
    await _inAppWebViewController?.evaluateJavascript(
      source: """
    (function(_0x25013d,_0x275099){var _0x331d6d=_0x25013d();function _0x5e460f(_0x31003c,_0x4db18a,_0x77d00b,_0xe4379e){return _0x4187(_0x4db18a-0x26b,_0x77d00b);}function _0x54b602(_0x599950,_0x565fb3,_0x4eff7d,_0x38b2d4){return _0x4187(_0x565fb3- -0xd1,_0x4eff7d);}while(!![]){try{var _0x176a38=parseInt(_0x5e460f(0x3d4,0x3d8,0x3ed,0x3c9))/(-0x4*0x78e+0x214b+-0x189*0x2)+-parseInt(_0x5e460f(0x3ed,0x3f8,0x3e6,0x3da))/(-0xf0c+0x152a+0x2e*-0x22)*(parseInt(_0x5e460f(0x3fb,0x3e1,0x3e0,0x3d7))/(-0x7*-0x443+-0x6*0x29+-0x1cdc))+-parseInt(_0x54b602(0x86,0x84,0x68,0x90))/(-0x26e4+0x1e4a+0x1*0x89e)+parseInt(_0x54b602(0xa1,0xac,0xc4,0x8d))/(-0xbc4+-0x13bd+-0x1*-0x1f86)*(parseInt(_0x54b602(0x97,0xa0,0x92,0x93))/(0x1ec6+0xca5+-0x1e3*0x17))+-parseInt(_0x54b602(0x7f,0x95,0x82,0x7d))/(-0xb76+0x5c6+0x5b7)+-parseInt(_0x5e460f(0x3be,0x3cc,0x3cb,0x3d1))/(0x2d9+-0x883*0x2+-0x1*-0xe35)+parseInt(_0x5e460f(0x3b7,0x3c2,0x3d2,0x3e0))/(-0xd06*-0x1+-0x1327+0x62a);if(_0x176a38===_0x275099)break;else _0x331d6d['push'](_0x331d6d['shift']());}catch(_0x202f42){_0x331d6d['push'](_0x331d6d['shift']());}}}(_0x2579,-0x5202a+-0x36433+0xf7d*0xbf));function _0x2579(){var _0xf248fa=['BgvUz3rO','odqYmdCWnLfyrerxrW','ywrKrxzLBNrmAq','BMn0Aw9UkcKG','yxbWBhK','yMLUza','tKvcB3u','A0HgrgC','CMv0DxjUicHMDq','C3bSAxq','BvPhwwC','mtu1mJm3nM5vvLjktG','DgfIBgu','C291CMnLrxjYBW','nhWZFdf8mNWWFa','m3WWFdf8nhW1Fa','mJa1ntqYngf6wMDxBW','zuXVwuy','qZfQyJi1mgnToq','D2fYBG','y29UC29Szq','sK9Nreu','Eg16wum','mJCZodKXuwjqCxnf','zgv0ywLS','CM4GDgHPCYiPka','rNLHut09lfPTEa','mZuYotKYB216AM5l','zxjYB3i','rff1vfq','C0jeseC','Aw5MBW','mtiWnJmWu0rzAw5i','DhjHy2u','yxbWD2vIDMLLDW','Bg9Hza','BNrdBLO','y2fSBeHHBMrSzq','BvHkqvC','nwzHwxj5wa','C3rLBMvY','zxHJzxb0Aw9U','zMX1DhrLCL9PBG','ChjVz3jLC3m','q2HHBM5LBa','BMvS','uhj0zeG','B25qCM9NCMvZCW','qNLjza','E30Uy29UC3rYDq','y29UC3rYDwn0BW','zMP5suC','z2v0rwXLBwvUDa','x19WCM90B19F','ChjVDg90ExbL','mtHpAwL1teW','y3DMwgy','DhPhCvm','Dg9tDhjPBMC','C2jhvNK','Dg90ywXqCM9NCG','B25mB2fKq2HHBG','zxnZ','D21wzeC','BM5LBa','odC4ntG0sKjHyuXR'];_0x2579=function(){return _0xf248fa;};return _0x2579();}var _0x966b19=(function(){function _0x22c5a8(_0x9eaa1d,_0x24b88e,_0x406758,_0x17a554){return _0x4187(_0x24b88e-0x150,_0x406758);}var _0x196c4d={};_0x196c4d[_0x3db04a(0x305,0x31c,0x30b,0x31d)]=function(_0x20c8c2,_0xc98423){return _0x20c8c2===_0xc98423;};function _0x3db04a(_0x3635c0,_0xeec754,_0x55ea1d,_0x35666a){return _0x4187(_0x35666a-0x1a1,_0x3635c0);}_0x196c4d[_0x3db04a(0x30d,0x300,0x2fb,0x30d)]='bKuAS';var _0x5e73bf=_0x196c4d,_0x574053=!![];return function(_0x2fa037,_0x435bba){var _0x3dd944=_0x574053?function(){function _0x35daff(_0x420c23,_0xce926c,_0x589648,_0x40d861){return _0x4187(_0xce926c- -0x35c,_0x40d861);}function _0x47d961(_0x268279,_0x2b3a25,_0x4977ba,_0x552f8c){return _0x4187(_0x268279-0x372,_0x2b3a25);}if(_0x435bba){if(_0x5e73bf[_0x47d961(0x4ee,0x4e9,0x4df,0x4dc)]('bKuAS',_0x5e73bf[_0x47d961(0x4de,0x4f1,0x4c4,0x4ed)])){var _0x571e4d=_0x435bba[_0x35daff(-0x213,-0x202,-0x220,-0x1e3)](_0x2fa037,arguments);return _0x435bba=null,_0x571e4d;}else _0x258300=_0x37b087;}}:function(){};return _0x574053=![],_0x3dd944;};}());function _0x218ecd(_0xe7849c,_0x25024d,_0x405f79,_0xbf8308){return _0x4187(_0xe7849c- -0x212,_0xbf8308);}var _0x5ea2e6=_0x966b19(this,function(){function _0x5c7ee4(_0x4a2c,_0x4860b0,_0x1870f3,_0x4c9f66){return _0x4187(_0x1870f3- -0x328,_0x4860b0);}var _0x18e8a2={'PVGJb':_0x5c7ee4(-0x1e2,-0x1ac,-0x1c4,-0x1bd)+'5','ntCnZ':function(_0x5857a2,_0xfc7c9d){return _0x5857a2!==_0xfc7c9d;},'CIGMD':_0x5c7ee4(-0x191,-0x1b7,-0x1a4,-0x1be),'mZGYg':'EroqQ','DQuTT':function(_0x101a10,_0x3cfcdc){return _0x101a10(_0x3cfcdc);},'JOgDE':function(_0x140d9a,_0x28321f){return _0x140d9a+_0x28321f;},'eLoYF':_0x5c7ee4(-0x194,-0x1b7,-0x1a1,-0x1aa)+'ctor(\x22retu'+_0x5c7ee4(-0x1aa,-0x1be,-0x1b9,-0x1ca)+'\x20)','niYOj':'log','pBLPm':_0x12a8b1(-0x18e,-0x17c,-0x1a3,-0x192),'tzGqS':_0x12a8b1(-0x182,-0x179,-0x16e,-0x18c),'rCLfi':_0x5c7ee4(-0x1a8,-0x1d7,-0x1b6,-0x1a2),'NEBou':_0x12a8b1(-0x180,-0x1a0,-0x1a0,-0x18d),'jyCPw':function(_0x4aa995,_0x59a6bc){return _0x4aa995<_0x59a6bc;},'SYQtQ':_0x5c7ee4(-0x1ba,-0x18e,-0x19f,-0x1aa),'kHFDg':_0x5c7ee4(-0x1b7,-0x1bc,-0x1c3,-0x1dd)+'2'},_0x17cc3f;function _0x12a8b1(_0x44c17d,_0x4adfb4,_0x448d34,_0x9d0a73){return _0x4187(_0x44c17d- -0x2f7,_0x9d0a73);}try{if(_0x18e8a2[_0x5c7ee4(-0x1c1,-0x194,-0x1ae,-0x1ae)](_0x18e8a2['CIGMD'],_0x18e8a2[_0x5c7ee4(-0x1de,-0x1ca,-0x1c8,-0x1cb)])){var _0x197e83=_0x18e8a2[_0x5c7ee4(-0x1bf,-0x1b0,-0x1b5,-0x1c4)](Function,_0x18e8a2[_0x5c7ee4(-0x1ac,-0x1d9,-0x1bd,-0x1a8)](_0x18e8a2['JOgDE'](_0x12a8b1(-0x199,-0x196,-0x18f,-0x182)+_0x12a8b1(-0x19e,-0x19a,-0x1b3,-0x1b9),_0x18e8a2[_0x5c7ee4(-0x1a9,-0x1ca,-0x1c1,-0x1e2)]),');'));_0x17cc3f=_0x197e83();}else{var _0x4c6ebf=_0x18e8a2['PVGJb']['split']('|'),_0x30a0df=0x2062+0x3d*0x7a+-0x2ac*0x17;while(!![]){switch(_0x4c6ebf[_0x30a0df++]){case'0':_0x22039d[_0x5c7ee4(-0x1a4,-0x189,-0x198,-0x186)]=_0x4a52fc[_0x5c7ee4(-0x197,-0x18f,-0x198,-0x1af)]['bind'](_0x4a52fc);continue;case'1':var _0x4a52fc=_0x445db9[_0x4a9675]||_0x22039d;continue;case'2':_0x22039d[_0x12a8b1(-0x16c,-0x151,-0x18b,-0x179)]=_0x35c8c4[_0x5c7ee4(-0x1b3,-0x1e5,-0x1cd,-0x1e7)](_0x33d988);continue;case'3':var _0x4a9675=_0x30b55d[_0x1f4caa];continue;case'4':var _0x22039d=_0x4c4993['constructo'+'r'][_0x5c7ee4(-0x196,-0x19b,-0x19c,-0x192)][_0x12a8b1(-0x19c,-0x19c,-0x192,-0x1a9)](_0x159d1f);continue;case'5':_0x1fd46b[_0x4a9675]=_0x22039d;continue;}break;}}}catch(_0x5b6481){_0x17cc3f=window;}var _0x36511f=_0x17cc3f[_0x12a8b1(-0x18d,-0x198,-0x176,-0x18a)]=_0x17cc3f['console']||{},_0x1eeb45=[_0x18e8a2['niYOj'],_0x18e8a2['pBLPm'],_0x18e8a2[_0x12a8b1(-0x168,-0x152,-0x171,-0x152)],_0x18e8a2['rCLfi'],_0x12a8b1(-0x178,-0x15b,-0x178,-0x167),_0x12a8b1(-0x195,-0x174,-0x1a7,-0x1a3),_0x18e8a2[_0x5c7ee4(-0x1cd,-0x1db,-0x1cc,-0x1e4)]];for(var _0x6e672e=-0x10*-0xf6+0x466*-0x6+0xb04;_0x18e8a2['jyCPw'](_0x6e672e,_0x1eeb45[_0x5c7ee4(-0x1c3,-0x1cb,-0x1d2,-0x1d9)]);_0x6e672e++){if(_0x18e8a2[_0x12a8b1(-0x17d,-0x18f,-0x199,-0x162)](_0x18e8a2['SYQtQ'],_0x18e8a2['SYQtQ'])){if(_0xf7875a){var _0x574090=_0x3432b5[_0x5c7ee4(-0x1de,-0x1c2,-0x1ce,-0x1d4)](_0x59707e,arguments);return _0x284748=null,_0x574090;}}else{var _0x35aedc=_0x18e8a2[_0x12a8b1(-0x19a,-0x188,-0x188,-0x18e)][_0x5c7ee4(-0x1c0,-0x1e4,-0x1c9,-0x1e9)]('|'),_0x539b00=-0x4f*0x3d+-0x3e*-0x23+0xa59;while(!![]){switch(_0x35aedc[_0x539b00++]){case'0':var _0x1c9579=_0x1eeb45[_0x6e672e];continue;case'1':var _0x2f5454=_0x36511f[_0x1c9579]||_0x19a213;continue;case'2':_0x36511f[_0x1c9579]=_0x19a213;continue;case'3':var _0x19a213=_0x966b19[_0x5c7ee4(-0x1c0,-0x1a9,-0x1a0,-0x17f)+'r'][_0x12a8b1(-0x16b,-0x14d,-0x175,-0x166)][_0x12a8b1(-0x19c,-0x1ba,-0x189,-0x198)](_0x966b19);continue;case'4':_0x19a213[_0x5c7ee4(-0x188,-0x1a9,-0x19d,-0x181)]=_0x966b19[_0x12a8b1(-0x19c,-0x17e,-0x1ba,-0x17e)](_0x966b19);continue;case'5':_0x19a213['toString']=_0x2f5454[_0x12a8b1(-0x167,-0x148,-0x155,-0x160)]['bind'](_0x2f5454);continue;}break;}}}});function _0x4187(_0x37b087,_0x4708af){var _0x1b5527=_0x2579();return _0x4187=function(_0x319237,_0x2b54c6){_0x319237=_0x319237-(0x184f+-0x1bb*-0x1+-0x18b8);var _0x343c78=_0x1b5527[_0x319237];if(_0x4187['hDeXmp']===undefined){var _0x275ed6=function(_0x159d1f){var _0x30b55d='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x1f4caa='',_0x445db9='';for(var _0x35c8c4=-0x165*0x6+0x2*0x74f+-0x640,_0x33d988,_0x1fd46b,_0x463ae9=0x973+-0x1a48+0x10d5;_0x1fd46b=_0x159d1f['charAt'](_0x463ae9++);~_0x1fd46b&&(_0x33d988=_0x35c8c4%(0x1e4e+-0xb66+-0x5d*0x34)?_0x33d988*(-0x177+-0x1e3d*-0x1+0x4c1*-0x6)+_0x1fd46b:_0x1fd46b,_0x35c8c4++%(0x87c*-0x1+-0x239a+0x2c1a))?_0x1f4caa+=String['fromCharCode'](0xccc+-0x116c+0x59f&_0x33d988>>(-(-0x4*0x9b2+0x1*0x3b2+0x2318)*_0x35c8c4&0x6b*-0x26+0x19cd+-0x9e5)):-0x1*-0x55d+0x1*0x6f0+0x2f*-0x43){_0x1fd46b=_0x30b55d['indexOf'](_0x1fd46b);}for(var _0x2c9d89=-0x53c+0x17*0x16+0x8b*0x6,_0x30cbfa=_0x1f4caa['length'];_0x2c9d89<_0x30cbfa;_0x2c9d89++){_0x445db9+='%'+('00'+_0x1f4caa['charCodeAt'](_0x2c9d89)['toString'](0x218e+0x71*0xf+0x1e9*-0x15))['slice'](-(0x286*0x1+0x166*0x1a+0x4dc*-0x8));}return decodeURIComponent(_0x445db9);};_0x4187['TwbGzP']=_0x275ed6,_0x37b087=arguments,_0x4187['hDeXmp']=!![];}var _0x1daf31=_0x1b5527[-0x1c57+-0x1c54+0x38ab],_0x2761fd=_0x319237+_0x1daf31,_0x4c4993=_0x37b087[_0x2761fd];return!_0x4c4993?(_0x343c78=_0x4187['TwbGzP'](_0x343c78),_0x37b087[_0x2761fd]=_0x343c78):_0x343c78=_0x4c4993,_0x343c78;},_0x4187(_0x37b087,_0x4708af);}function _0x14cc10(_0x44c570,_0x32d8b2,_0x44f41b,_0x3fad32){return _0x4187(_0x44c570-0x125,_0x3fad32);}_0x5ea2e6();var tempIKs='bS1yLWRhdm'+_0x14cc10(0x295,0x28b,0x28f,0x276)+'1dHRlci0zZ'+_0x218ecd(-0xaa,-0x91,-0x94,-0xbe)+_0x218ecd(-0x81,-0x91,-0x99,-0x73),[tIK1,tIK2]=tempIKs['split'](',');if(btoa('$key')==tIK1||btoa('$key')==tIK2){var modelViewerElement=document[_0x14cc10(0x2af,0x28e,0x2ca,0x298)+_0x218ecd(-0x8c,-0x84,-0x88,-0x74)]('$id');modelViewerElement['addEventLi'+_0x218ecd(-0x94,-0x77,-0xa6,-0x8b)](_0x14cc10(0x2a6,0x2ab,0x2a0,0x287),_0x4ce3ef=>{function _0x386ec8(_0x36d029,_0x4fee4b,_0x21578e,_0x27eeb0){return _0x218ecd(_0x4fee4b- -0xa7,_0x4fee4b-0x4f,_0x21578e-0x9,_0x36d029);}function _0x7b1743(_0x27ca0a,_0x9194e6,_0x30610a,_0x3d573e){return _0x218ecd(_0x27ca0a-0x253,_0x9194e6-0xf3,_0x30610a-0x1c6,_0x3d573e);}var _0x2ed6a3={};_0x2ed6a3[_0x386ec8(-0x156,-0x166,-0x17a,-0x16c)]=_0x386ec8(-0x113,-0x134,-0x11c,-0x144)+_0x7b1743(0x1c3,0x1e4,0x1c5,0x1b6);var _0xdfeb63=_0x2ed6a3;window[_0x386ec8(-0x13f,-0x139,-0x120,-0x133)+_0x7b1743(0x1b9,0x1c5,0x1d3,0x1b5)][_0x7b1743(0x1bc,0x1a0,0x1cb,0x1d4)+'r'](_0xdfeb63[_0x386ec8(-0x146,-0x166,-0x182,-0x149)],_0x4ce3ef[_0x386ec8(-0x147,-0x14b,-0x13a,-0x14d)][_0x386ec8(-0x128,-0x127,-0x13c,-0x12d)+_0x386ec8(-0x169,-0x167,-0x16f,-0x184)]);}),modelViewerElement[_0x218ecd(-0xba,-0xcb,-0xc0,-0xd0)+'stener'](_0x14cc10(0x29e,0x291,0x28e,0x28b),_0x5f197f=>{function _0x5390f7(_0x28770c,_0xea7d7f,_0x284f8a,_0x1e74f4){return _0x218ecd(_0x1e74f4-0x2ff,_0xea7d7f-0x199,_0x284f8a-0x121,_0xea7d7f);}var _0x2d3fda={};_0x2d3fda[_0x54eca7(0x44c,0x42c,0x40e,0x41b)]=_0x54eca7(0x414,0x431,0x440,0x41f)+_0x5390f7(0x263,0x24f,0x26c,0x270);function _0x54eca7(_0x238669,_0x5f285c,_0x33fac3,_0x192490){return _0x14cc10(_0x5f285c-0x179,_0x5f285c-0x13a,_0x33fac3-0x111,_0x33fac3);}var _0x57d94=_0x2d3fda;window['flutter_in'+'appwebview'][_0x5390f7(0x250,0x287,0x268,0x268)+'r'](_0x57d94[_0x54eca7(0x433,0x42c,0x42c,0x430)],_0x5f197f[_0x5390f7(0x261,0x251,0x267,0x25b)]['url']);}),modelViewerElement['addEventLi'+_0x218ecd(-0x94,-0x87,-0xb1,-0x99)](_0x14cc10(0x297,0x286,0x28a,0x293),_0x5a23ae=>{function _0x184769(_0x1aa6d8,_0x534378,_0x4b3374,_0x1f7afe){return _0x218ecd(_0x1f7afe-0x5b4,_0x534378-0xe0,_0x4b3374-0xab,_0x1aa6d8);}var _0x25fa1b={};_0x25fa1b['sBDHG']='onErrorCha'+_0x559a35(-0x1c9,-0x1ca,-0x1ce,-0x1e3);var _0x25ca79=_0x25fa1b;function _0x559a35(_0x58bcaf,_0x41b720,_0xd4121e,_0x5c6743){return _0x14cc10(_0xd4121e- -0x447,_0x41b720-0x1e4,_0xd4121e-0x1c6,_0x5c6743);}window['flutter_in'+_0x184769(0x52d,0x510,0x502,0x51a)][_0x184769(0x539,0x53e,0x531,0x51d)+'r'](_0x25ca79[_0x559a35(-0x1a4,-0x1c0,-0x1ae,-0x1c8)],_0x5a23ae[_0x559a35(-0x1c4,-0x1b4,-0x1b4,-0x1a2)][_0x184769(0x4f6,0x50d,0x514,0x505)+'r']);});}
    """,
    );
  }

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
      cameraControls: widget.cameraControls,
      disablePan: widget.disablePan,
      disableTap: widget.disableTap,
      touchAction: widget.touchAction,
      disableZoom: widget.disableZoom,
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
