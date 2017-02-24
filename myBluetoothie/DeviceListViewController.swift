//
//  DeviceListViewController.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/3/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceListViewController: UITableViewController, ScanResultsConsumer {
    
    // MARK: - Properties
    var adapter: BLEAdapter!
    var utils: Utils!
    var devices: NSMutableArray = [] //Where devices info is stored
    var scan_timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        adapter = BLEAdapter.sharedInstance
        print("BLEAdapter created") //DEBUG
        adapter.initBluetooth(self)
        print("CBCentralManager initialized") //DEBUG
        utils = Utils.sharedInstance
        print("Instance of I/O class created") //DEBUG
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        print("UITableview #section counted")// DEBUG
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("UITableview #number counted") // DEBUG
        // #warning Incomplete implementation, return the number of rows
        return devices.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure your customized cell here.
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as! DeviceTableViewCell
        let device = devices.object(at: indexPath.row) as! Device
        cell.deviceName.text = device.deviceName
        cell.deviceAddress.text = device.deviceAddress.uuidString
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - ScanResultsConsumer delegate
    func onDeviceDiscovered(_ peripheral: CBPeripheral) {
        // If peripheral name is not empty
        if let discoveredDeviceName = peripheral.name {
            let device = Device(peripheral: peripheral, deviceAddress: peripheral.identifier, deviceName: discoveredDeviceName)
            // Then insert this device at the beginning of the list
            // should be if deivce is not in devices then insert
            devices.insert(device, at:0)
        // Else if peripheral name is empty
        } else {
            let device = Device(peripheral: peripheral, deviceAddress: peripheral.identifier, deviceName: "<no name>")
            devices.insert(device, at:0)
        }
        
        // Original code
//        let indexPath = IndexPath(row: 0, section: 0)
//        var indexesPath:[IndexPath] = [IndexPath]()
//        indexesPath.append(indexPath)
//        self.tableView.insertRows(at: indexesPath, with: UITableViewRowAnimation.automatic)    }
        //A more efficient way
    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    
    
    // MARK: - Actions
    @IBAction func onScan(_ sender: UIBarButtonItem) {
        if (adapter.scanning == true) {
            print("Already scanning - ignoring")
            return
        }
        
        if (adapter.powered_on == false) {
            utils.info(message: "Bluetooth is not available yet - powered on?", ui: self, cbOK: {print("Ok callback -- power off")})
            return
        }
        
        if (adapter.scanning == false) {
            adapter.scanning = true
            print("Will start scanning soon")
            devices.removeAllObjects()
            self.tableView.reloadData()
            
            // Start scanning devices for 10 seconds
            let scanResult = adapter.findDevices(10, "BDSK", self)
            
//            print("scanResult: \(scanResult)") //DEBUG
            
            if (scanResult == -1) {
                utils.info(message: "Bluetooth is not available at this moment - powered on?", ui: self, cbOK: {print("Ok callback")})
            } else {
                print("Setting up timer for when scanning is finished")
                scan_timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(DeviceListViewController.scanningFinished(_:)), userInfo: nil, repeats: false)
            }
        }
    }
    
    func scanningFinished(_ timer: Timer) {
        print("Scan finished")
        adapter.scanning = false
        if (adapter.peripherals.count > 0) {
            let msg = "Finished scanning - found " + String(adapter.peripherals.count) + " devices"
            utils.info(message : msg, ui : self, cbOK: {print("OK callback")})
        }
        else {
            let msg = "No devices were found"
            utils.info(message : msg, ui : self,
                       cbOK: {
                        print("OK callback")
            })
        }
        
    }
}
