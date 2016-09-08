//
//  WXPayService.swift
//  vfans
//
//  Created by 潘东 on 16/9/8.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ErrorDescri: String {
    case NOTENOUGH = "余额不足"
    case ORDERPAID = "商户订单已支付"
    case ORDERCLOSED = "订单已关闭"
    case TRUEPAY = "已发起真正支付"
    case DEFAULT
}

let WXPaySuccessNotification = "WeixinPaySuccessNotification"
let partnerId = "1337011001"

struct WXPayService {
    
    //MARK: --------------------------- Public Methods ------------------------
    static func wxTruePay(prePayData: JSON) -> ErrorDescri {
        var returnDescri: ErrorDescri?
        if prePayData["result"].stringValue == "Success" {
            let wxPrePayModel = WXPrePayModel(appID: prePayData["payData"]["appId"].stringValue,
                          noncestr: prePayData["payData"]["nonceStr"].stringValue,
                          package: prePayData["payData"]["package"].stringValue,
                          partnerID: partnerId,
                          prepayID: prePayData["payData"]["prepayID"].stringValue,
                          sign: prePayData["payData"]["paySign"].stringValue,
                          timestamp: prePayData["payData"]["timeStamp"].intValue)
            let req = PayReq()
            req.openID = wxPrePayModel.appID
            req.partnerId = wxPrePayModel.partnerID
            req.prepayId = wxPrePayModel.prepayID
            req.nonceStr = wxPrePayModel.noncestr
            req.timeStamp = UInt32(wxPrePayModel.timestamp)
            req.package = wxPrePayModel.package
            req.sign = wxPrePayModel.sign
            WXApi.sendReq(req)
            returnDescri = ErrorDescri.TRUEPAY
        } else if prePayData["result"].stringValue == "Fail" {
            let errorCode = prePayData["payData"].stringValue
            switch errorCode {
            case "NOTENOUGH":
                returnDescri = ErrorDescri.NOTENOUGH
            
            case "ORDERPAID":
                returnDescri = ErrorDescri.ORDERPAID
                
            case "ORDERCLOSED":
                returnDescri = ErrorDescri.ORDERCLOSED
                
            default:
                returnDescri = ErrorDescri.DEFAULT
            }
        }
        return returnDescri!
     }
}