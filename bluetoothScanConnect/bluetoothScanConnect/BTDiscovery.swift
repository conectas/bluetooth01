//
//  BTDiscovery.swift
//  bluetoothScanConnect
//
//  Created by Stefan Glaser on 27.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import Foundation
import CoreBluetooth


// ----------------------------------------------------------------------------------------------------
protocol BTDiscoveryDelegate {
    
    func bteScanFertig(lader: BTDiscovery, bleDevicesDaten: [BleDevices])
    func bteConnectSET(lader: BTDiscovery)
}


class BTDiscovery: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // ------------------------------------------------------
    var delegateBTDiscovery: BTDiscoveryDelegate?
    
    // ------------------------------------------------------
    var activeCentralManager : CBCentralManager?
    
    var peripheral : CBPeripheral?
    var peripheralDevice: CBPeripheral?
    
    // ------------------------------------------------------
    var bleDevicesDaten = [BleDevices]()
    var bleConnectDatenAR = [BleDevices]()
    
    
    
    //
    // ----------------------------------------------------------------------------------------------------
    // Starte das scannen
    // ----------------------------------------------------------------------------------------------------
    func startBteScan() {
        if activeCentralManager == nil {
            activeCentralManager = CBCentralManager(delegate: self, queue: nil)
        }
        
    }
    //
    // ----------------------------------------------------------------------------------------------------
    // Starte den connect
    // ----------------------------------------------------------------------------------------------------
    func startBteConnect(bleConnectDatenAR: [BleDevices]) {
        print("BTDiscovery: startBteConnect")
        
        
        if bleConnectDatenAR.count == 1 {
            
            print("BTDiscovery: bleConnectDatenAR")
            
            self.peripheralDevice = bleConnectDatenAR[0].peripheral
            self.peripheralDevice?.delegate = self
            
            if let activeCM = activeCentralManager {
                
                print("BTDiscovery: activeCM \(peripheralDevice!)")
                
                activeCM.connectPeripheral(peripheralDevice!, options: nil)
                
                print("BTDiscovery: ------------------------")
                
            } else {
                print("Connecting activeCentralManager fehlgeschlagen..")
            }
        } else {
            print("Fehler in den BTE Connect Daten..")
        }
    }
    
    
    
    //
    // ----------------------------------------------------------------------------------------------------
    // (1) wird immer aufgerufen wenn sich an Bluetooth was ändert
    // ----------------------------------------------------------------------------------------------------
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("BTDiscovery: centralManagerDidUpdateState")
        
        var msg = ""
        switch (central.state) {
            
        case .PoweredOff:
            msg = "Bluetooth leider ausgeschaltet"
        case .PoweredOn:
            msg = "Bluetooth ist eingeschaltet"
            central.scanForPeripheralsWithServices(nil, options: nil)
        
        
        case .Resetting:
            msg = "Resetting"
        
        
        case .Unauthorized:
            msg = "Unauthorized"
            
        
        case .Unknown:
            msg = "Unknown"
            
        
        case .Unsupported:
            msg = "Unsupported"
        
        // default: break
        
        }
        print("BTDiscovery: STAT MSG: \(msg)")
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // (2) wird zum Scan aufgerufen => kommt von scanForPeripheralsWithServices
    // ----------------------------------------------------------------------------------------------------
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("BTDiscovery: didDiscoverPeripheral")
        
        if let deviceNamen = peripheral.name {
            
            if deviceNamen != "nil" {
                print("BTDiscovery: PName: \(peripheral.name!)")
                
                let neueDevice = BleDevices(
                    activeCentralManager : central,
                    peripheral : peripheral,
                    devicesNamen : deviceNamen,
                    deviceUUID : peripheral.identifier.UUIDString,
                    devicesRSSI : RSSI
                )
                self.bleDevicesDaten.append(neueDevice)
                
                dispatch_async(dispatch_get_main_queue()) {
                    print("BTDiscovery: Update TVC")
                    self.delegateBTDiscovery?.bteScanFertig(self, bleDevicesDaten: self.bleDevicesDaten)
                }
            }
        }
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // (3) wird zum Connect aufgerufen => connectPeripheral(peripheralDevice!, options: nil)
    // ----------------------------------------------------------------------------------------------------
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("BTDiscovery: didConnectPeripheral \(peripheral)")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        if let activeCM = activeCentralManager {
            activeCM.stopScan()
            dispatch_async(dispatch_get_main_queue()) {
                self.delegateBTDiscovery?.bteConnectSET(self)
            }
        }
        
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("BTDiscovery: didFailToConnectPeripheral \(peripheral)")
    }
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("BTDiscovery: didDisconnectPeripheral \(peripheral)")
    }
    
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("BTDiscovery: willRestoreState \(peripheral)")
    }
    
    
    func centralManager(central:CBCentralManager, didRetrievePeripherals peripherals:[AnyObject]!) {
    	print("BTDiscovery: didRetrievePeripherals \(peripheral)")
    
    }
    
    
    /*

    @seealso            CBConnectPeripheralOptionNotifyOnConnectionKey
    *  @seealso            CBConnectPeripheralOptionNotifyOnDisconnectionKey
    *  @seealso            CBConnectPeripheralOptionNotifyOnNotificationKey

*/
    
}



// ----------------------------------------------------------------------------------------------------
// MARK: - struct BleDevices
struct BleDevices {
    var activeCentralManager : CBCentralManager
    var peripheral : CBPeripheral
    var devicesNamen : String
    var deviceUUID : String
    var devicesRSSI : NSNumber
    
}



