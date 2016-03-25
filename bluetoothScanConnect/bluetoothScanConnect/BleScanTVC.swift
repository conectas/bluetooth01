//
//  BleScanTVC.swift
//  bluetoothScanConnect
//
//  Created by Stefan Glaser on 27.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import UIKit

class BleScanTVC: UITableViewController, BTDiscoveryDelegate {
    
    // ------------------------------------------------------
    let laderBTD = BTDiscovery()
    
    // ------------------------------------------------------
    var bleDevicesDatenAR = [BleDevices]()
    var bleConnectDatenAR = [BleDevices]()
    
    
    // ----------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // ----------------------------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool) {
        
        // Initialize central manager on load
        laderBTD.delegateBTDiscovery = self
        laderBTD.startBteScan()
        
//
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = refreshControl
        
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ANFANG: BTDiscoveryDelegate
    // ----------------------------------------------------------------------------------------------------
    
	func bteScanFertig(lader: BTDiscovery, bleDevicesDaten: [BleDevices]) {
        
        print("BleScanTVC: tableView.reloadData")
        bleDevicesDatenAR = bleDevicesDaten
        
        let navTitleTxt = "Scan Daten"
        if let _ = navigationController {
            self.navigationItem.title = navTitleTxt
            
            print("BleScanTVC: devNamenCount: \(bleDevicesDatenAR.count)")
            print("BleScanTVC: devicesNamen: \(bleDevicesDatenAR[0])")
            
            self.tableView.reloadData()
        }
    }
    
    
    func bteConnectSET(lader: BTDiscovery) {
        
        // Now that we are setup, return to main view.
        if let navigationController = navigationController {
            _ = navigationController
            // navTitle = navTitleTxt
            
            let mainVC = self.navigationController!.viewControllers.first as! ViewController
            mainVC.bleConnectDatenAR = bleConnectDatenAR
            navigationController.popViewControllerAnimated(true)
            // self.navigationController!.popToRootViewControllerAnimated(true)
            
        }
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ENDE: BTDiscoveryDelegate
    // ----------------------------------------------------------------------------------------------------

   
    
    
    
    // MARK: - Table view data source
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bleDevicesDatenAR.count ?? 0
    }
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        print("BleScanTVC: cellForRowAtIndexPath")
        
        let aktuelleDevicesDaten = self.bleDevicesDatenAR[indexPath.row]
        
        if aktuelleDevicesDaten.devicesNamen != "nil" {
            
            print("BleScanTVC: devicesNamen: \(bleDevicesDatenAR.count) | \(indexPath.row)")
            
            cell.textLabel?.text = ("\(aktuelleDevicesDaten.devicesNamen) [\(aktuelleDevicesDaten.devicesRSSI.stringValue)]")
            cell.detailTextLabel?.text = aktuelleDevicesDaten.deviceUUID
        }
        
        return cell
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        bleConnectDatenAR.removeAll()
        let aktuelleConnectDaten = self.bleDevicesDatenAR[indexPath.row]
        let connectDevice = BleDevices(
            activeCentralManager : aktuelleConnectDaten.activeCentralManager,
            peripheral : aktuelleConnectDaten.peripheral,
            devicesNamen : aktuelleConnectDaten.devicesNamen,
            deviceUUID : aktuelleConnectDaten.deviceUUID,
            devicesRSSI : aktuelleConnectDaten.devicesRSSI
        )
        self.bleConnectDatenAR.append(connectDevice)
        
        laderBTD.delegateBTDiscovery = self
        laderBTD.startBteConnect(bleConnectDatenAR)
        
        
        if let _ = navigationController {
            navigationItem.title = "Connecting \(aktuelleConnectDaten.devicesNamen)"
        }
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
