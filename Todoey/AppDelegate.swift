//
//  AppDelegate.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/3.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
//        do {
//            let realm = try Realm()
//        } catch {
//            fatalError("Error when init realm, \(error)")
//        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        return true
    }




}

