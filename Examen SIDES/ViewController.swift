//
//  ViewController.swift
//  Examen SIDES
//
//  Created by Raphaël Chauvin on 11/09/2017.
//  Copyright © 2017 UFR SANTE ROUEN. All rights reserved.
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
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        /*HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        //print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                //print("[WebCacheCleaner] Record \(record) deleted"
            }
        }*/
        
        var ssidvalue: String!
        let defaults = UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed")
        var ssid_mdm: String!
        var battery_mdm: Float!
        var checkup_mdm: Int
        var batteryLevel: Float
        batteryLevel = UIDevice.current.batteryLevel
        

        ssid_mdm = defaults?["ssid"] as? String ?? "SIDES"
        battery_mdm = defaults?["battery"] as? Float ?? 0.3
        checkup_mdm = defaults?["checkup"] as? Int ?? 1
        
        if checkup_mdm == 1 {
            if batteryLevel > battery_mdm {
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
                if batteryLevel > 0.65 && batteryLevel < 0.90 {
                    battery_image.image = UIImage(named:"battery_high_nok@2x.png")
                }
                if batteryLevel > 0.35 && batteryLevel < 0.65 {
                    battery_image.image = UIImage(named:"battery_medium_nok@2x.png")
                }
                if batteryLevel > 0.0 && batteryLevel < 0.35 {
                    battery_image.image = UIImage(named:"battery_low_nok@2x.png")
                }
                button.isEnabled = false
            }
            
            ssidvalue = getWiFiSsid()
            
            if ssidvalue == ssid_mdm {
                wifi_image.image = UIImage(named:"wifi_ok@2x.png")
                
            }
            else {
                wifi_image.image = UIImage(named:"wifi_nok@2x.png")
                button.isEnabled = false
                
            }
        }
        else {
            //don't show pictures
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

