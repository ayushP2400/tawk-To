//
//  userImageContainerView.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import UIKit

class userImageContainerView: UIView {

    var imageView = ImageLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func initViews(){
        
        self.setCornerRadius(25.0)
        self.setBorder(with: 1.0, color: .black)
        
        
        /// supposing height 40
        imageView.setCornerRadius(20)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "userPlaceholder")
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 40.0),
            imageView.heightAnchor.constraint(equalToConstant: 40.0),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    

}
