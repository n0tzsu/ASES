//
//  webViewController.swift
//  Examen SIDES
//
//  Created by Raphaël Chauvin on 11/09/2017.
//  Copyright © 2019 UFR SANTE ROUEN. All rights reserved.
//

import WebKit

class webViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    var mode = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString:String = "https://side-sante.fr/learning/exam/index"
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
        }
        else if mode == 2 {
            appDelegate.deviceOrientation = .portrait
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            mode = 1
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
