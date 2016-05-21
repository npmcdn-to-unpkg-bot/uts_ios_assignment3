# WebKit for iOS

WebKit allows developers to **display web content within their apps** without forcing the user to navigate between apps or switching to the browser. It can be considered a frameless inline version of Safari, which can be displayed at any point of the UI and renders HTML websites just like a normal browser. The framework also implements a history and exposes it to the API. It offers several ways of customising the WebView, restricting a users navigation possibilities, the content that will be displayed, the local storage amount and so on.

## Technical introduction

### Core objects

Starting with iOS 8, the `UIWebView` is being replaced by `WKWebView`. This is the core object, being a child of UIViewController and therefore able to be placed as a subview to any existing view. The change to WKWebView is especially important, because it offers significant performance boosts for  websites using WebGL, WebWorkers or other complex logic. This allows hybrid based application development using frameworks such as **cordova** or **ionic** to use more complex animations and graphics to deliver the user a native-like experience while maintaining the ability to reuse code across devices.

The `WKBackForwardList` class manages the list of webpage previously visited by the user.

The `WKNavigation` class contains information that can be used to give the user visual feedback of the loading process of the WebView during the loading process.

### Core Protocolls

The `WKNavigationDelegate` implements callback methods that hook into the navigation activities of the WebView. This can be used to track changes in the location or perform in app navigations in response to a navigation change in the WebView.

The `WKScriptMessageHandler` is used to receive messages from a running website. The website can send messages to the native code using the `webkit` object on the `window` object in JavaScript. 


### Message handlers
When a `UIWebView` is instantiated, the javascript within this view has the ability to easily send messages to the backing Objective-C code. All passed JavaScript objects are autmatically serialized and converted into native Objective-C or Swift objects. 

```javascript
window.webkit.messageHandlers.{NAME}.postMessage()
```

<!-- http://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi -->
### NSAppTransportSecurity for http 

In order to load all websites (not only https as allowed by default), one must add the following key to the info.plist

```
Dictionary NSAppTransportSecurity
//and this having an entry
boolean NSAllowsArbitraryLoads = YES
```

### Displaying a WebView 

To display a WebView, very little code is needed. Using a standard one page template in XCode, the following code can be run in the first `[UIViewControllers viewDidLoad]` method:

```objectivec
//define (empty/default) settings and size
CGRect frame = _webViewContainer.frame;
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//add message handler to be exposed to javascript
[configuration.userContentController addScriptMessageHandler:self name:@"messageQueueToNative"];
//init
_webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
//set self as delegate for the webview
_webView.navigationDelegate = self;

//configure a request URL to load
NSString *startUrl = @"http://localhost:8100"; //for demo only. links to locally hosted mobile webapp
//set navigation url and load
[self webViewTo:startUrl];
[_webViewContainer addSubview:_webView];

//local helper function for url textField
[self urlChangedTo:startUrl];

```

## Use cases and relevance to market

The WebView element is the core requirement for hybrid web applications. Without this element, a hybrid application could not run in a native environment, since there would be no way to display web content in the native app. Frameworks such as **Cordova (PhoneGap)** use this to create an app, that wrapps a website and displays it as a full screen application. The user then doesn't know, he's looking at a web based application, unless the UX makes it obvious. Frameworks such as **ionic** aim to ensuring the app experience of a user is equivalent to the experience in a truely native application. Adapters enable the use of more advanced features such as the Gyroscope, Location access, Camera access and other APIs exposed to normal iOS applications. 

Technically one could write an application purely based on Javascript, that uses a small adapter to access an Apple Watch using the WatchKit. Even more helpful would be a home automation app, that accesses the home's devices through HomeKit using native objective-c code. All the logic for displaying and managing the assets however would be written in web technologies. This way, the application can also run on an Android, where it would then use the Nest APIs, Weave or Brillo, the pendants to Apples HomeKit
