//
//  SizeConst.swift
//  vfans
//
//  Created by 潘东 on 16/9/2.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import UIKit

/**
 *
 *  用于放置所有尺寸相关的常量
 *
 */

struct Size {
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
    static let statusBarHeight: CGFloat = 20
    static let naviBarHeight: CGFloat = 44
    static let tarBarHeight: CGFloat = 49
}