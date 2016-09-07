//
//  APIBaseManager.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation

/*
 总述：
 这个base manager是用于给外部访问API的时候做的一个基类。任何继承这个基类的manager都要实现方法：
 
 func methodName() -> String {
    return "user/login"
 }
 
 func serviceType() -> String {
    return ServiceNameList.vfans
 }
 
 func requestType() -> APIManagerRequestType {
    return APIManagerRequestType.Post
 }

 
 外界在使用manager的时候，如果需要调api，只要调用loadData即可。manager会去找paramSource来获得调用api的参数。调用成功或失败，则会调用delegate的回调函数。
 
 */

class APIBaseManager {
    //MARK: ------------------------ Life Cycle --------------------------
    // 由负责调用API接口的业务Controller实现
    weak var delegate: APIManagerCallBackDelegate?
    weak var paramSource: APIManagerParamSource?
    
    // 由SubAPIManager来实现
    weak var validator: APIManagerValidator?
    private weak var child: APIManager?
    
    var errorMessage: String?
    var errorType: APIManagerErrorType
    var response: URLResponse?
    
    var isLoading: Bool
    
    private var fetchedRawData: NSData?
    private var _requestIdList: [Int]?
    
    init() {
        delegate = nil
        paramSource = nil
        validator = nil
        
        isLoading = false
        
        errorMessage = nil
        errorType = .Default
        
        if let aChild = self as? APIManager {
            child = aChild
        } else {
            fatalError("未遵守APIManager的协议")
        }
    }
    
    deinit {
        cancelAllRequests()
        _requestIdList = nil
        
    }
    
    //MARK:----------------------- Public Methods ------------------------
    func cancelAllRequests() {
        ApiProxy.sharedInstance.cancelRequestWithRequestIdList(requestIdList)
        requestIdList.removeAll()
    }
    
    func cancelRequestWithRequestId(requestId: Int) {
        if removeRequestIdWithRequestId(requestId) {
            ApiProxy.sharedInstance.cancelRequestWithRequestId(requestId)
        }
    }
    
    func fetchDataWithReformer(reformer: APIManagerDataReformer?) -> AnyObject {
        var resultData: AnyObject
        
        if let myReformer = reformer {
            resultData = myReformer.manager(self, reformData: fetchedRawData!)
        } else {
            resultData = fetchedRawData!
        }
        
        return resultData
    }
    
    //MARK: - calling api
    func loadData() -> Int {
        let params = paramSource?.paramsForApi(self)
        let requestId = loadDataWithParams(params!)
        
        return requestId
    }
    
    private func loadDataWithParams(params: ParamData) -> Int {
        var requestId = 0
        if validator!.manager(self, isCorrectWithParamsData: params) {
            if isReachable {
                isLoading = true
                switch child!.requestType() {
                case .Get:
                    requestId = callAPI(.Get, withParam: params)
                    
                case .Post:
                    requestId = callAPI(.Post, withParam: params)
                    
                case .Put:
                    requestId = callAPI(.Put, withParam: params)
                    
                case .Delete:
                    requestId = callAPI(.Delete, withParam: params)
                }
                
                return requestId
            } else {
                failedOnCallingApi(nil, withErrorType: .NoNetWork)
                
                return requestId
            }
        } else {
            failedOnCallingApi(nil, withErrorType: .ParamsError)
            
            return requestId
        }
    }
    
    //MARK: - api callbacks
    private func successedOnCallingApi(response: URLResponse) {
        isLoading = false
        self.response = response
        fetchedRawData = response.responseData
        
        removeRequestIdWithRequestId(response.requestId)
        if validator!.manager(self, isCorrectWithCallBackData: response.responseData) {
            delegate!.managerCallAPIDidSuccess(self)
        } else {
            failedOnCallingApi(response, withErrorType: APIManagerErrorType.NoContent)
        }
    }
    
    //TODO: 处理多种错误类型
    private func failedOnCallingApi(response: URLResponse?, withErrorType errorType: APIManagerErrorType) {
        isLoading = false
        self.response = response
        self.errorType = errorType
        if let hasResponse = response {
            removeRequestIdWithRequestId(hasResponse.requestId)
        }
        delegate?.managerCallAPIDidFailed(self)
    }
    
    //MARK:----------------------- Private Methods -----------------------
    private func removeRequestIdWithRequestId(requestId: Int) -> Bool {
        var isRemoved = false
        
        var indexToRemove: Int?
        for index in 0 ..< requestIdList.count  {
            if requestIdList[index] == requestId {
                indexToRemove = index
            }
        }
        if let rmIndex = indexToRemove {
            requestIdList.removeAtIndex(rmIndex)
            isRemoved = true
        }
        
        return isRemoved
    }
    
    private func callAPI(requeseType: APIManagerRequestType, withParam param: ParamData) -> Int {
        var requestId = 0
        switch requeseType {
        case .Get:
            requestId = ApiProxy.sharedInstance.callGETWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self]
                    response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
                })
            
        case .Post:
            requestId = ApiProxy.sharedInstance.callPOSTWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self]
                    response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
                })
            
        case .Put:
            requestId = ApiProxy.sharedInstance.callPUTWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self] response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
            })
            
        case .Delete:
            requestId = ApiProxy.sharedInstance.callPUTWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self] response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
                })
        }
        requestIdList.append(requestId)
        
        return requestId
    }
    
    //MARK: -------------------- Getter and Setter ------------------------
    var requestIdList: [Int] {
        get {
            if _requestIdList == nil {
                _requestIdList = [Int]()
            }
            
            return _requestIdList!
        }
        
        set {}
    }
    
    var isReachable: Bool {
        get {
            let isReachability = AppContext.sharedInstance.isReachable
            if !isReachability {
                errorType = APIManagerErrorType.NoNetWork
            }
            return isReachability
        }
    }
}