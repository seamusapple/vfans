//
//  LaunchController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import SnapKit

class LaunchController: UIViewController {
    
    //MARK:----------------------------- Life Cycle -------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPageSubviews()
        layoutPageSubviews()
        loadNextPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: --------------------------- Controller Settings ------------------------
    func addPageSubviews() {
        self.view.addSubview(launchImage)
    }
    
    func layoutPageSubviews() {
        launchImage.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    //MARK: --------------------------- Getter and Setter --------------------------
    private var launchImage: UIImageView = {
        let launchImage = UIImageView()
        launchImage.image = UIImage(named: Image.launch)
        return launchImage
    }()
    
    //MARK: --------------------------- Private Methods ---------------------------
    func loadNextPage() {
        setupNormalRootViewController()
    }
    
    func setupNormalRootViewController() {
        let mainVC = RootController()
        let naviController = UINavigationController(rootViewController: mainVC)
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate!.window!!.rootViewController = naviController
        appDelegate!.window!!.makeKeyAndVisible()
    }

}
