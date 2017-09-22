//
//  InternetRechability.swift
//  DemoTodayWidget
//
//  Created by mehulmac on 20/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import Foundation
import Reachability

// MARK: Reachability class
func isNetworkAvailable() -> Bool {
    let reachability: Reachability = Reachability.forInternetConnection()
    let networkStatus = reachability.currentReachabilityStatus()
    var isAvailable  = false;
    
    switch networkStatus {
    case .NotReachable:
        isAvailable = false;
        break;
    case .ReachableViaWiFi:
        isAvailable = true;
        break;
    case .ReachableViaWWAN:
        isAvailable = true;
        break;
    }
    return isAvailable;
}
