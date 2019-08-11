//
//  CentralService.swift
//  BluetoothService
//
//  Created by Carmelo Uria on 8/11/19.
//  Copyright © 2019 Carmelo Uria Corporation. All rights reserved.
//

import Foundation
import CoreBluetooth

import os.log

struct BTConstants {
    // These are sample GATT service strings. Your accessory will need to include these services/characteristics in its GATT database
    static let sampleServiceUUID = CBUUID(string: "AAAA")
    static let sampleCharacteristicUUID = CBUUID(string: "BBBB")
}

internal class CentralService : NSObject
{
    fileprivate let bluetoothDispatchQueue : DispatchQueue = DispatchQueue(label: "com.carmelouria.services.bluetooth", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    fileprivate var centralManager : CBCentralManager? = nil

    //MARK: - Init Methods
    
    override init()
    {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: bluetoothDispatchQueue)
    }
    
    open func start(cbuuids: [CBUUID]? = nil, options: [String : Any]? = nil)
    {
        centralManager?.scanForPeripherals(withServices: cbuuids, options: options)
    }
}

extension CentralService : CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
       switch central.state {
       case .resetting:
           os_log("Connection with the system service was momentarily lost. Update imminent")
       case .unsupported:
           os_log("Platform does not support the Bluetooth Low Energy Central/Client role")
       case .unauthorized:
           switch central.authorization {
           case .restricted:
               os_log("Bluetooth is restricted on this device")
           case .denied:
               os_log("The application is not authorized to use the Bluetooth Low Energy role")
           default:
               os_log("Something went wrong. Cleaning up cbManager")
           }
       case .poweredOff:
           os_log("Bluetooth is currently powered off")
       case .poweredOn:
           os_log("Starting central Manager")
           let matchingOptions = [CBConnectionEventMatchingOption.serviceUUIDs: [BTConstants.sampleServiceUUID]]
           central.registerForConnectionEvents(options: matchingOptions)
       default:
           os_log("Cleaning up cbManager")
       }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        if let name : String = peripheral.name
        {
            debugPrint("[\(#function):\(#line)] peripheral: \(name)")
        }
        else
        {
            debugPrint("[\(#function):\(#line)] peripheral: \(peripheral.debugDescription)")
        }
    }
}
