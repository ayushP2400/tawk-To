//
//  Functions and Extensions.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import Foundation

func isInternetConnectionAvailable()->Bool{
    if Utilities.currentReachabilityStatus == .notReachable {
        // Network Unavailable
        return false
    } else {
        // Network Available
        return true
    }
}
