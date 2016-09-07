//
//  vfansService.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation

class vfansService: Service, ServiceProtocol {
    //MARK: - ServiceProtocol Methods
    func onlineApiBaseUrl() -> String {
        
        return "http://appapi.heclouds.com/"
        
    }
    
    func onlineApiVersion() -> String {
        
        return "1.0"
    }
    
    func onlineApiCommonPath() -> String {
        
        return "hewu"
    }
}