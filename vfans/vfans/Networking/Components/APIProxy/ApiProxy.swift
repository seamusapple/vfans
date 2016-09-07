//
//  ApiProxy.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import Alamofire

typealias ApiCallback = (URLResponse) -> ()

class ApiProxy {
    
    //MARK: --------------------------- Life Cycle --------------------------
    private init() {}
    
    //MARK:----------------------------- Public Methods -------------------------------
    func callGETWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generateGETRequestWithServiceIdentifier(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func callPOSTWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generatePOSTRequestWithServiceIdentifier(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func callPUTWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generatePUTRequestWithServiceIdentifier(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func callDELETEWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generateDELETERequestWithServiceIdentifier(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func cancelRequestWithRequestId(requestId: Int) {
        let requestOperation = dispatchTable[requestId]
        requestOperation?.cancel()
        dispatchTable.removeValueForKey(requestId)
    }
    
    func cancelRequestWithRequestIdList(requestIdList: [Int]) {
        for requestId in requestIdList {
            cancelRequestWithRequestId(requestId)
        }
    }
    
    //MARK:----------------------------- Public Methods -------------------------------
    func callApiWithRequest(request: NSURLRequest, success: ApiCallback, fail: ApiCallback) -> Int {
        var task: NSURLSessionTask? = nil
        task = Alamofire.request(request).responseJSON { response in
            let id = task!.taskIdentifier
            self.dispatchTable.removeValueForKey(id)
            let responseData = response.data
            let responseString = String(data: responseData!, encoding: NSUTF8StringEncoding)
            
            switch response.result {
            case .Success:
                let urlResponse = URLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, status: URLResponseStatus.Success)
                success(urlResponse)
                
            case .Failure(let error):
                let urlResponse = URLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, error: error)
                fail(urlResponse)
            }
            }.task
        
        let requestId = task!.taskIdentifier
        
        return requestId
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    static let sharedInstance = ApiProxy()

    private lazy var dispatchTable: [Int: NSURLSessionTask] = {
        let dispatchTable = [Int: NSURLSessionTask]()
        return dispatchTable
    }()
}
