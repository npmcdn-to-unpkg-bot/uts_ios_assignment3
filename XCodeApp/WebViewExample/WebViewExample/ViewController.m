//
//  ViewController.m
//  WebViewExample
//
//  Created by Brokmeier, Pascal on 5/21/16.
//  Copyright © 2016 uts. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = _webViewContainer.frame;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"messageQueueToNative"];
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];

    _webView.navigationDelegate = self;

    //configure a request URL to load
    NSString *startUrl = @"http://www.google.com";
    [self webViewTo:startUrl];
    [self urlChangedTo:startUrl];
    [_webViewContainer addSubview:_webView];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)webViewTo:(NSString *)url {
    NSURL *nsurl= [NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [_webView setBounds:_webViewContainer.bounds];
    [_webView setFrame:CGRectMake(0,0,_webView.bounds.size.width, _webView.bounds.size.height)];
    [_webView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//call to change the textField URL
- (void) urlChangedTo:(NSString *)newUrl{
    [_urlField setText:newUrl];
}

- (IBAction)urlFieldEditingDidEnd:(id)sender {
    UITextField *textField = sender;
    [self navigateToUrl:textField.text];
}

- (IBAction)navigateToUrl:(id)sender {
    [self webViewTo:_urlField.text];
}




- (IBAction)navigateBack:(id)sender {
    [_webView goBack];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

/**
 * takes messages from the webview
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSString * msgString = [NSString stringWithFormat:@"%@", message.body];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message received from WebKit"
                                                    message:msgString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *url = _webView.URL.absoluteString;
    [_urlField setText:url];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}


@end
