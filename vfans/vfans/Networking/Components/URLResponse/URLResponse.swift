//
//  URLResponse.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation

class URLResponse {
    
    //MARK:----------------------------- Init Methods -------------------------------
    init(withResponseString responseString: String, requestId: Int, request: NSURLRequest, responseData: NSData, status: URLResponseStatus) {
        self.status = status
        self.contentString = responseString
        self.requestId = requestId
        self.request = request
        self.responseData = responseData
    }
    
    init(withResponseString responseString: String, requestId: Int, request: NSURLRequest, responseData: NSData, error: NSError) {
        self.contentString = responseString
        self.requestId = requestId
        self.request = request
        self.responseData = responseData
        
        if error.code == NSURLErrorTimedOut {
            self.status = URLResponseStatus.ErrorTimeout
        } else {
            self.status = URLResponseStatus.ErrorNoNetwork
        }
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    let status: URLResponseStatus
    let contentString: String
    let requestId: Int
    let request: NSURLRequest
    let responseData: NSData
}