//
//  BaseController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class BaseController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseConditions()
    }
    
    private func setBaseConditions() {
        view.backgroundColor = Color.white
        
        navigationController?.navigationBar.translucent = false // 关闭导航栏半透明效果
        
        edgesForExtendedLayout = UIRectEdge.None
    }
    
    // 设置当前 Navigation Bar 背景色
    func setNaviBarBackgroundColor(color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
    
    // 设置当前 Navigation Bar 标题
    func setNaviBarTitle(title: String, font: UIFont, textColor: UIColor) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .Center
        navigationItem.titleView = titleLabel
    }
    
    func setNaviBarBtnItemWithTitle(title: String, textColor: UIColor, direction: Bool,
                                    style: UIBarButtonItemStyle, action: Selector) {
        let barBtnItem = UIBarButtonItem(title: title, style: style, target: self, action: action)
        navigationController?.navigationBar.tintColor = textColor
        if direction {
            navigationItem.leftBarButtonItem = barBtnItem
        } else {
            navigationItem.rightBarButtonItem = barBtnItem
        }
    }
    
    func setNaviBarBtnItemWithImage(image: UIImage, direction: Bool,
                                    style: UIBarButtonItemStyle, action: Selector, hidden: Bool) {
        let barBtnItem = UIBarButtonItem(image: image.imageWithRenderingMode(.AlwaysOriginal),
                                         style: style, target: self, action: action)
        if hidden {
            if direction {
                navigationItem.leftBarButtonItem = barBtnItem
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        } else {
            if direction {
                navigationItem.leftBarButtonItem = barBtnItem
            } else {
                navigationItem.rightBarButtonItem = barBtnItem
            }
        }
    }
    
//    func addNaviLeftBarBtn(style: UIBarButtonItemStyle, action: Selector) {
//        let barBtnItem = UIBarButtonItem(image: UIImage(named: Icon.contentCloseBtn)!.imageWithRenderingMode(.AlwaysOriginal),
//                                         style: style, target: self, action: action)
//        navigationItem.leftBarButtonItems?.append(barBtnItem)
//    }
}
