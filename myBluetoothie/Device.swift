//
//  Device.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/2/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

import UIKit
import CoreBluetooth

class Device {
    // MARK: Properties
    var peripheral: CBPeripheral
    var deviceAddress: UUID
    var deviceName: String
    // MARK: Initialization
    
    init(peripheral: CBPeripheral, deviceAddress: UUID, deviceName: String?) {
        self.peripheral = peripheral
        self.deviceAddress = deviceAddress
        if let tmpDeviceName = deviceName {
            self.deviceName = tmpDeviceName
        } else {
            self.deviceName = "no name"
        }
    }
}
