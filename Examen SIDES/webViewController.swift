//
//  webViewController.swift
//  Examen SIDES
//
//  Created by Raphaël Chauvin on 11/09/2017.
//  Copyright © 2017 UFR SANTE ROUEN. All rights reserved.
//

import WebKit

class webViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var webViewContainer: UIView!
    @IBOutlet var webView: WKWebView!
    var mode = 1

    func load() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        let urlString:String = "https://www.google.fr"
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func rotationButton(_ sender: Any) {
        if mode == 1 {
            appDelegate.deviceOrientation = .landscapeLeft
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            mode = 2
            //webView.reload()
        }
        else if mode == 2 {
            appDelegate.deviceOrientation = .portrait
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            mode = 1
            //webView.reload()
        }
    }
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }

    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
