//
//  ContactsStore.swift
//  iFans
//
//  Created by 潘东 on 16/9/1.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import SwiftAddressBook
import SwiftyJSON
import MBProgressHUD

class ContactsStore {

    private let kName = "userName"
    private let kPhone = "phoneNum"

    //MARK: - life cycle
    static let sharedStore = ContactsStore()
    
    private var phoneDatas: [JSON]?
    
    private var addressBook = SwiftAddressBook()
    
    private var saveResult: CFError? {
        didSet {
            
        }
    }
    
    private init() {
        phoneDatas = nil
        saveResult = nil
    }
    
    //MARK: - public method
    func setPhoneData(data: [JSON]) {
        self.phoneDatas = data
        
        switch isAuth() {
            
        case .Authorized:
            saveToAddressBook()
            
        case .NotDetermined:
            requestAuth()
            
        case .Denied:
            print("没有权限")
            requestAuth()
            
        case .Restricted:
            print("不晓得嘛")
        }
    }
    
    func isSuccess() -> Bool {
        return saveResult == nil ? true : false
    }
    
    //MARK: - private method
    private func requestAuth() {
        SwiftAddressBook.requestAccessWithCompletion { (success, error) in
            if success {
                self.saveToAddressBook()
            } else {
                print("请求权限失败")
            }
        }
    }

    private func isAuth() -> ABAuthorizationStatus {
        return SwiftAddressBook.authorizationStatus()
    }
    
    private func saveToAddressBook() {

        guard let phoneDatas = phoneDatas else {
            print("无电话信息")
            return
        }
        
        //MARK: - 存储群组
        var group: SwiftAddressBookGroup?
        var groupNameArray = [String]()
        if let existGroups = addressBook?.arrayOfAllGroups {
            for existGroup in existGroups {
                groupNameArray.append(existGroup.name!)
                if existGroup.name == "爱圈粉" {
                    group = existGroup
                }
            }
            
            if !groupNameArray.contains("爱圈粉") {
                group = SwiftAddressBookGroup.create()
                group!.name = "爱圈粉"
                addressBook!.addRecord(group!)
                addressBook!.save()
            }
        }
        
        //MARK: - 存储联系人
        if let people = addressBook?.allPeople {
            var nameArray = [String]()
            for existPeron in people {
                if let firstName = existPeron.firstName {
                    nameArray.append(firstName)     // 遍历目前通讯录的所有联系人名字
                }
            }
            
            for phoneData in phoneDatas {
                let phone = MultivalueEntry(value: phoneData[kPhone].stringValue, label: "mobile", id: 0)
                if nameArray.contains(phoneData[kName].stringValue) == false {  // 如果目前通讯录没有此次需要导入的人，则新建通讯录联系人
                    let person = SwiftAddressBookPerson.create()
                    person.firstName = phoneData[kName].stringValue
                    person.phoneNumbers = [phone]
                    addressBook?.addRecord(person)
                    addressBook?.save()
                    group!.addMember(person)
                } else {    // 如果已经有了，直接替换电话号码
                    let persons = addressBook?.peopleWithName(phoneData[kName].stringValue)
                    persons?.last?.phoneNumbers = [phone]
                }
            }
        }
        
        saveResult = addressBook?.save()
    }
}