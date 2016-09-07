//
//  RequestGenerator.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import Alamofire

class RequestGenerator {
    //MARK: --------------------------- Life Cycle --------------------------
    private init() {}
    
    //MARK:----------------------------- Public Methods -------------------------------
    func generateGETRequestWithServiceIdentifier(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + service.apiVersion + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = ".GET"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        //TODO: 如果有header，token，则在这部分写上
//        let appContext = AppContext.sharedInstance
//        let iotext = [
//            "app_version": appContext.appVersion,
//            "os": appContext.os,
//            "model": appContext.devModel,
//            "uuid": appContext.uuid
//        ]
//        
//        do {
//            let iotextData = try NSJSONSerialization.dataWithJSONObject(iotext, options: NSJSONWritingOptions(rawValue: 0))
//            let iotextString = String(data: iotextData, encoding: NSUTF8StringEncoding)
//            request.setValue(iotextString, forHTTPHeaderField: "iotext")
//        } catch { }
//        
//        if let auth = AuthManager.sharedInstance.getAuthData() {
//            request.setValue(auth.token, forHTTPHeaderField: "token")
//        }
        
        return request
    }
    
    func generatePOSTRequestWithServiceIdentifier(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + service.apiVersion + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = ".POST"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        //TODO: 如果有header，token，则在这部分写上
//        let appContext = AppContext.sharedInstance
//        let iotext = [
//            "app_version": appContext.appVersion,
//            "os": appContext.os,
//            "model": appContext.devModel,
//            "uuid": appContext.uuid
//        ]
//
//        do {
//            let iotextData = try NSJSONSerialization.dataWithJSONObject(iotext, options: NSJSONWritingOptions(rawValue: 0))
//            let iotextString = String(data: iotextData, encoding: NSUTF8StringEncoding)
//            request.setValue(iotextString, forHTTPHeaderField: "iotext")
//        } catch { }
//
//        if let auth = AuthManager.sharedInstance.getAuthData() {
//            request.setValue(auth.token, forHTTPHeaderField: "token")
        //        }
        
        return request
    }
    
    func generatePUTRequestWithServiceIdentifier(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + service.apiVersion + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = ".PUT"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        //TODO: 如果有header，token，则在这部分写上
//        let appContext = AppContext.sharedInstance
//        let iotext = [
//            "app_version": appContext.appVersion,
//            "os": appContext.os,
//            "model": appContext.devModel,
//            "uuid": appContext.uuid
//        ]
//
//        do {
//            let iotextData = try NSJSONSerialization.dataWithJSONObject(iotext, options: NSJSONWritingOptions(rawValue: 0))
//            let iotextString = String(data: iotextData, encoding: NSUTF8StringEncoding)
//            request.setValue(iotextString, forHTTPHeaderField: "iotext")
//        } catch { }
//
//        if let auth = AuthManager.sharedInstance.getAuthData() {
//            request.setValue(auth.token, forHTTPHeaderField: "token")
//        }
        
        return request
    }
    
    func generateDELETERequestWithServiceIdentifier(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + service.apiVersion + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = ".DELETE"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        //TODO: 如果有header，token，则在这部分写上
//        let appContext = AppContext.sharedInstance
//        let iotext = [
//            "app_version": appContext.appVersion,
//            "os": appContext.os,
//            "model": appContext.devModel,
//            "uuid": appContext.uuid
//        ]
//
//        do {
//            let iotextData = try NSJSONSerialization.dataWithJSONObject(iotext, options: NSJSONWritingOptions(rawValue: 0))
//            let iotextString = String(data: iotextData, encoding: NSUTF8StringEncoding)
//            request.setValue(iotextString, forHTTPHeaderField: "iotext")
//        } catch { }
//
//        if let auth = AuthManager.sharedInstance.getAuthData() {
//            request.setValue(auth.token, forHTTPHeaderField: "token")
//        }
        
        return request
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    static let sharedInstance = RequestGenerator()
}