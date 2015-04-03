//
//  FIOCron.swift
//  Fillio
//
//  Created by Kévin MACHADO on 03/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public class FIOCron {
    
    private class var DEFAULT_CRONTAB_ID: String {
        return "-the-default-cron-tab-1991"
    }
    
    private var cronList = [String:FIOCronTab]()
    
    private init() {
        cronList[FIOCron.DEFAULT_CRONTAB_ID] = FIOCronTab()
    }
    
    private class var instance: FIOCron {
        struct Singleton {
            static var instance = FIOCron()
        }
        return Singleton.instance
    }
    
    /// This method create/get a crontab instance
    public class func crontTabWithID(id: NSString) -> FIOCronTab {
        if let cron = FIOCron.instance.cronList[id] {
            return cron
        } else {
            FIOCron.instance.cronList[id] = FIOCronTab()
            return FIOCron.instance.cronList[id]!
        }
    }
    
    /// The method that return the default crontab instance
    public func defaultCronTab() -> FIOCronTab {
        return cronList[FIOCron.DEFAULT_CRONTAB_ID]!
    }
    
}