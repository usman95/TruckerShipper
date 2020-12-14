//
//  WebView.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import WebKit

class WebView: BaseController {

    @IBOutlet weak var webView: WKWebView!
    var fileURLString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.loadURL()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension WebView{
    private func loadURL(){
        if let url = URL(string: self.fileURLString ?? "") {
            let urlRequest:URLRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }
}
//MARK:- WKNavigationDelegate
extension WebView: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utility.showLoader()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.hideLoader()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utility.hideLoader()
    }
}
