//
//  BluetoothProcessor.swift
//  BluetoothService
//
//  Created by Carmelo Uria on 8/11/19.
//  Copyright © 2019 Carmelo Uria Corporation. All rights reserved.
//

import Foundation
import CoreBluetooth

public class BluetoothManager
{
    let centralService : CentralService = CentralService()
    
    //MARK: - Init Methods
    
    public init()
    {
        
    }
    
    //MARK: - public methods
    public func start(cbuuids: [CBUUID]? = nil, options: [String : Any]? = nil)
    {
        centralService.start(cbuuids: cbuuids, options: options)
    }
 
}
