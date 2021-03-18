//
//  customLoader.swift
//  tawkTo
//
//  Created by love on 17/03/21.
//

import Foundation
import UIKit

class customLoader {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow

    static let shared = customLoader()
    /*
        Show customized activity indicator,
        actually add activity indicator to passing view
    
        @param uiView - add activity indicator to this view
    */
     func showActivityIndicator() {
        window?.isUserInteractionEnabled = false
        container.frame = window!.frame
        container.center = window!.center
        container.backgroundColor = UIColor.clear
    
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = window!.center
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        window!.addSubview(container)
        activityIndicator.startAnimating()
    }

    /*
        Hide activity indicator
        Actually remove activity indicator from its super view
    
        @param uiView - remove activity indicator from this view
    */
     func hideActivityIndicator() {
        window?.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }

}
