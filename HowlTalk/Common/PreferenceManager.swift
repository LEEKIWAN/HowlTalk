//
//  PreferenceManager.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit

class PreferenceManager: NSObject {

    
    class var userEmail: String! {
        get{
            return UserDefaults.standard.string(forKey: "userEmail")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var userPassword: String! {
        get{
            return UserDefaults.standard.string(forKey: "userPassword")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userPassword")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    class var userID: String! {
        get{
            return UserDefaults.standard.string(forKey: "userID")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var userUID: String! {
        get{
            return UserDefaults.standard.string(forKey: "userUID")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userUID")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    class var userName: String! {
        get{
            return UserDefaults.standard.string(forKey: "userName")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var profileImageURL: String! {
        get{
            return UserDefaults.standard.string(forKey: "profileImageURL")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "profileImageURL")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var deviceToken: String! {
        get{
            return UserDefaults.standard.string(forKey: "deviceToken")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var gender: String! {
        get{
            return UserDefaults.standard.string(forKey: "gender")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "gender")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var birthDate: String! {
        get{
            return UserDefaults.standard.string(forKey: "birthDate")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "birthDate")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var loginMethod: String! {
        get{
            return UserDefaults.standard.string(forKey: "loginMethod")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "loginMethod")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var isFirstRegistration: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isFirstRegistration")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isFirstRegistration")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var isGuideClosed: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isGuideClosed")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isGuideClosed")
            UserDefaults.standard.synchronize()
        }
    }

}
