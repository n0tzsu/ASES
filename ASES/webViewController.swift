//
//  webViewController.swift
//  ASES
//
//  Created by Raphaël Chauvin on 11/09/2017.
//  Copyright © 2019 UFR SANTE ROUEN. All rights reserved.
//

import WebKit

class webViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBAction func brightnessControl(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
        lastBrightnessvalue = UIScreen.main.brightness
    }
    @IBOutlet var brightnessSlider: UISlider!
    
    @IBAction func confirmDisconnection(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Êtes-vous sûr de vous déconnecter ?", message:"Vous perdrez toute progression non sauvegardée.", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Oui", style: .destructive, handler: { (action) -> Void in
            self.goHome()
        })
        
        let cancel = UIAlertAction(title: "Annuler", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(yes)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    var lastBrightnessvalue: CGFloat = UIScreen.main.brightness
    var mode = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
    }
    
    @objc func appBecameActiveWC() {
        lastBrightnessvalue = lastBrightnessvalue - 0.0001
        UIScreen.main.brightness = lastBrightnessvalue
        let zoom = self.webView.bounds.size.width / self.webView.scrollView.contentSize.width
        self.webView.scrollView.setZoomScale(zoom, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActiveWC), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if ViewController.choices.examChoice == 1 {
            let urlString:String = "https://side-sante.fr/learning/exam/index"
            let url:URL = URL(string: urlString)!
            let urlRequest:URLRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        if ViewController.choices.examChoice == 2 {
            let urlString:String = "https://sides.uness.fr/evaluations"
            let url:URL = URL(string: urlString)!
            let urlRequest:URLRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func goHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(balanceViewController, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            let zoom = self.webView.bounds.size.width / self.webView.scrollView.contentSize.width
            self.webView.scrollView.setZoomScale(zoom, animated: true)
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}
