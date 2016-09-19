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
    case NOTINSTALLED = "未安装微信"
    case DEFAULT
}

let WXPaySuccessNotification = "WeixinPaySuccessNotification"
let WXPayFailNotification = "WeixinPayFailNotification"
let partnerId = "1390233302"

struct WXPayService{
    
    //MARK: --------------------------- Public Methods ------------------------
    static func wxTruePay(prePayData: JSON) -> ErrorDescri {
        var returnDescri: ErrorDescri?
        if WXApi.isWXAppInstalled() {   // 判断是否安装了微信
            if prePayData["result"].stringValue == "Success" {
                let wxPrePayModel = WXPrePayModel(appID: prePayData["payData"]["appid"].stringValue,
                                                  noncestr: prePayData["payData"]["noncestr"].stringValue,
                                                  package: prePayData["payData"]["package"].stringValue,
                                                  partnerID: prePayData["payData"]["partnerid"].stringValue,
                                                  prepayID: prePayData["payData"]["prepayid"].stringValue,
                                                  sign: prePayData["payData"]["sign"].stringValue,
                                                  timestamp: prePayData["payData"]["timestamp"].intValue)
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
                print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)")
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
        } else {
           returnDescri = ErrorDescri.NOTINSTALLED
        }
        return returnDescri!
     }
}
