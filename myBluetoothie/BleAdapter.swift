//
//  BleAdapter.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/1/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

import UIKit
import CoreBluetooth


class BLEAdapter: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    
    var central_manager: CBCentralManager?
    var selected_peripheral: CBPeripheral?
    var peripherals: NSMutableArray = []
    var power_on: Bool?
    var scanning: Bool?
    var connected: Bool?
    
    static let sharedInstance = BLEAdapter()
    
    func centralManagerStateToString(_ state:CBManagerState) ->[CChar]? {
        
        var returnVal:String
        
        if state == CBManagerState.unknown {
            returnVal = "State unknown \(CBManagerState.unknown)"
        } else if (state == CBManagerState.resetting) {
            returnVal = "State resetting \(CBManagerState.resetting)"
        } else if (state == CBManagerState.unsupported) {
            returnVal = "State BLE unsupported \(CBManagerState.unsupported)"
        } else if (state == CBManagerState.unauthorized) {
            returnVal = "State unauthorized \(CBManagerState.unauthorized)"
        } else if (state == CBManagerState.poweredOff) {
            returnVal = "State BLE power off \(CBManagerState.poweredOff)"
        } else if (state == CBManagerState.poweredOn) {
            returnVal = "State BLE power on and ready \(CBManagerState.poweredOn)"
        } else {
            returnVal = "Unknown state"
        }
        
        
        return (returnVal.cString(using: String.Encoding.utf8))
    }
    
    func printKnownPeripherals() {
        print("List of found devices: ")
        let count = self.peripherals.count
        if (count > 0 ) {
            for i in 0...count - 1 {
                let p = self.peripherals.object(at: i) as! CBPeripheral
                self.printDeviceDetails(p)
            }
            
        }
    }
    
    func printDeviceDetails(_ peripheral: CBPeripheral) {
        print("Peripheral info: ")
        print("Name: \(peripheral.name)")
        print("ID: + \(peripheral.identifier)")
    }
    
    // CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        self.peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as! NSMutableArray
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
}
