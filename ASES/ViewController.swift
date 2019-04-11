//
//  ViewController.swift
//  ASES
//
//  Created by Raphaël Chauvin on 11/09/2017.
//  Copyright © 2019 UFR SANTE ROUEN. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var battery_image: UIImageView!
    
    @IBOutlet var wifi_image: UIImageView!
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    override func viewDidLoad() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        super.viewDidLoad()
    }
    
    @objc func appBecameActive() {
        check()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        check()
        clear()
    }
    
    func clear() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func check() {
        var ssidvalue: String!
        let defaults = UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed")
        var ssid_mdm: String!
        var battery_mdm: Int!
        var checkup_mdm: Int
        var batteryLevel: Float
        batteryLevel = UIDevice.current.batteryLevel
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        ssid_mdm = defaults?["ssid"] as? String ?? ""
        battery_mdm = defaults?["battery"] as? Int ?? 30
        checkup_mdm = defaults?["checkup"] as? Int ?? 0
        
        var battery_mdm_float = Float(battery_mdm)
        battery_mdm_float = battery_mdm_float / 100
        
        var flag_battery: Int
        var flag_ssid : Int
        
        if checkup_mdm == 1 {
            if batteryLevel > battery_mdm_float {
                flag_battery = 0
                if batteryLevel > 0.90 {
                    battery_image.image = UIImage(named:"battery_full_ok@2x.png")
                }
                if batteryLevel > 0.65 && batteryLevel < 0.90 {
                    battery_image.image = UIImage(named:"battery_high_ok@2x.png")
                }
                if batteryLevel > 0.35 && batteryLevel < 0.65 {
                    battery_image.image = UIImage(named:"battery_medium_ok@2x.png")
                }
                if batteryLevel > 0.0 && batteryLevel < 0.35 {
                    battery_image.image = UIImage(named:"battery_low_ok@2x.png")
                }
            }
            else {
                flag_battery = 1
                if batteryLevel > 0.65 && batteryLevel < 0.90 {
                    battery_image.image = UIImage(named:"battery_high_nok@2x.png")
                }
                if batteryLevel > 0.35 && batteryLevel < 0.65 {
                    battery_image.image = UIImage(named:"battery_medium_nok@2x.png")
                }
                if batteryLevel > 0.0 && batteryLevel < 0.35 {
                    battery_image.image = UIImage(named:"battery_low_nok@2x.png")
                }
            }
            
            ssidvalue = getWiFiSsid()
            
            if ssidvalue == ssid_mdm {
                flag_ssid = 0
                wifi_image.image = UIImage(named:"wifi_ok@2x.png")
            }
            else {
                flag_ssid = 1
                wifi_image.image = UIImage(named:"wifi_nok@2x.png")
            }
            if flag_ssid == 1 || flag_battery == 1 {
                    button.isEnabled = false
            }
            else {
                button.isEnabled = true
            }
        }
        else {
            wifi_image.image = UIImage()
            battery_image.image = UIImage()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

