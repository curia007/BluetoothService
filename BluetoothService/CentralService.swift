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
    
    internal func start(cbuuids: [CBUUID]? = nil, options: [String : Any]? = nil)
    {
        if let centralManager : CBCentralManager = self.centralManager
        {
            centralManager.scanForPeripherals(withServices: cbuuids, options: options)
        }
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
               os_log("Something went wrong. Cleaning up Central Manager")
           }
       case .poweredOff:
            os_log("Bluetooth is currently powered off")
       case .poweredOn:
            os_log("CBCentralManager state .poweredOn")
            central.registerForConnectionEvents(options: nil)
            NotificationCenter.default.post(name: .bluetoothPoweredOn, object: nil)
       default:
            os_log("Cleaning up Cenral Manager")
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
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        debugPrint("[\(#function):\(#line)] peripheral: \(peripheral.debugDescription) did connect")

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        debugPrint("[\(#function):\(#line)] peripheral: \(peripheral.debugDescription) did discover")

        let userInfo : [AnyHashable : Any] = ["peripheral" : peripheral]
        NotificationCenter.default.post(name: .bluetoothDiscoveredDevice, object: nil, userInfo: userInfo)

    }
}

public extension Notification.Name
{
    static let bluetoothPoweredOn = Notification.Name("bluetoothPoweredOnNotification")
    static let bluetoothDiscoveredDevice = Notification.Name("bluetoothDiscoveredDevice")
}
