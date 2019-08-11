//
//  CentralService.swift
//  BluetoothService
//
//  Created by Carmelo Uria on 8/11/19.
//  Copyright © 2019 Carmelo Uria Corporation. All rights reserved.
//

import Foundation
import CoreBluetooth

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
