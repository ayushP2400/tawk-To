//
//  ImageLoader.swift
//  tawkTo
//
//  Created by love on 16/03/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL,completion:@escaping((UIImage?)->())) {
        
        // setup activityIndicator...
        activityIndicator.color = .darkGray
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageURL = url
        
        image = nil
        activityIndicator.startAnimating()
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            completion(imageFromCache)
            activityIndicator.stopAnimating()
            return
        }else{
//             image does not available in cache.. so retrieving it from url...
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                    })
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        
                        if self.imageURL == url {
                            completion(imageToCache)
                        }
                        
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    }else{
                        completion(nil)
                    }
                    self.activityIndicator.stopAnimating()
                    return
                })
            }).resume()
        }
        
        
    }
}
