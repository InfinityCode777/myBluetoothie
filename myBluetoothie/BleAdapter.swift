//
//  BleAdapter.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/1/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol ScanResultsConsumer {
    func onDeviceDiscovered(_ device: CBPeripheral)
}




class BLEAdapter: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    
    
    
    // MARK: -Properties
    var central_manager: CBCentralManager?
    var selected_peripheral: CBPeripheral?
    var peripherals: NSMutableArray = []
    var powered_on: Bool?
    var scanning: Bool?
    var connected: Bool?
    var scanResultsConsumer: ScanResultsConsumer?
    var requiredName:String?
    
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
//        print("ID: + \(peripheral.identifier.uuidString)")
    }
    
    
    func initBluetooth(_ device_list: DeviceListViewController) -> Int {
        powered_on = false
        scanning = false
        connected = false
        // Initialize CBCentralManager
        self.central_manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey:"BDSK"])
        //Kinda connect BLEAdapter to DeviceListViewController
        self.scanResultsConsumer = device_list
        return 0
    }
    
    
    func findDevices(_ timeout: Int, _ name:String, _ consumer: ScanResultsConsumer) -> Int {
        if(self.central_manager?.state != CBManagerState.poweredOn) {
            print("Bluetooth is not powered on!")
            return -1
        }
        
        peripherals.removeAllObjects()
        
        // 2/12/17 Didn't quite get it
        requiredName = name
        
        // IMHO, timer object is 'created' and triggerd, scan will stop in 10s,
        // The same time, in the next next line, scan starts
        Timer.scheduledTimer(timeInterval: Double(timeout), target: self, selector: #selector(BLEAdapter.stopScanning(_ :)), userInfo: nil, repeats: false)
        scanning = true
        self.central_manager?.scanForPeripherals(withServices: nil, options: nil)
        return 0
        
    }
    
    func stopScanning(_ timer: Timer) {
        if (scanning == true) {
            self.central_manager?.stopScan()
            scanning = false
        }
        
    }
    
    func stopScanning() {
        if (scanning == true) {
            self.central_manager?.stopScan()
            scanning = false
        }
    }
    
    // Whenever the central manager found a new device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //Will print out all the device info, including duplicates
        printDeviceDetails(peripheral);
        
        var idxDevice = 0
        var isDeviceDuplicate = false
        while idxDevice < peripherals.count {
            let thisDevice = self.peripherals.object(at: idxDevice)
            if(thisDevice as AnyObject).identifier == peripheral.identifier {
                self.peripherals.replaceObject(at: idxDevice, with: peripheral)
                print("duplicate device +1")
                isDeviceDuplicate = true
            }
            idxDevice = idxDevice + 1
        }
        
        if (isDeviceDuplicate == false) {
            // did not find device in our array so it must be a new device
            self.peripherals.add(peripheral)
            scanResultsConsumer?.onDeviceDiscovered(peripheral)
        }
        
        // Name filtering
        if let localName = advertisementData["kCBAdvDataLocalName"] {
            print(localName as! String)
            if ((localName as! String) != requiredName) {
                return
            }
        } else {
            return
        }
    }
    
    
    
    // MARK: - CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        self.peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as! NSMutableArray
    }
    
    // CBCentralManagerDelegate required method
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == CBManagerState.poweredOn) {
            powered_on = true
            return
        }
        if (central.state == CBManagerState.poweredOff) {
            powered_on = false
            return
        }
        
    }
    // CBPeripheralManagerDelegate required method
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    
}


