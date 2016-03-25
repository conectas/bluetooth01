//
//  ViewController.swift
//  bluetoothScanConnect
//
//  Created by Stefan Glaser on 27.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var DevNameOutlet: UILabel!
    
    @IBOutlet weak var DevUuidOutlet: UILabel!
    
    
    var bleConnectDatenAR = [BleDevices]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    //
    // ----------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        if bleConnectDatenAR.count == 1 {
            let aktuelleConnectDaten = self.bleConnectDatenAR[0]
            
            navigationItem.title = "Connecting \(aktuelleConnectDaten.devicesNamen)"
            DevNameOutlet.text = aktuelleConnectDaten.devicesNamen
            DevUuidOutlet.text = aktuelleConnectDaten.deviceUUID
            
        } else {
            navigationItem.title = ""
            DevNameOutlet.text = "-"
            DevUuidOutlet.text = "-"
        }
        
        
        
        
//        laderBTS.delegateBTService = self
//        laderBTS.startService(bleConnectDatenAR)
        
    }


}

