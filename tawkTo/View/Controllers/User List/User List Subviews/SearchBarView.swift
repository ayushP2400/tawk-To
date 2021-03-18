//
//  SearchBarView.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import UIKit

class SearchBarView: UIView {
    
    var searchBarContainerView = UIView()
    var searchBarImageView = UIImageView()
    var searchBarTextField = UITextField()
    var seperatorView = UIView()
    var cancelSearchBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initViews(){
        
        ///suppose height 45, margin 16 total 61
        searchBarContainerView.setCornerRadius(22.5)
        searchBarContainerView.setBorder(with: 1.0, color: UIColor.lightGray)
        self.addSubview(searchBarContainerView)
        searchBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBarContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            searchBarContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16),
            searchBarContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16),
            searchBarContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
        
        searchBarImageView.image = #imageLiteral(resourceName: "search")
        searchBarImageView.contentMode = .scaleAspectFit
        searchBarContainerView.addSubview(searchBarImageView)
        searchBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBarImageView.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor,constant: 16),
            searchBarImageView.widthAnchor.constraint(equalToConstant: 22),
            searchBarImageView.heightAnchor.constraint(equalToConstant: 22),
            searchBarImageView.centerYAnchor.constraint(equalTo: searchBarContainerView.centerYAnchor)
        ])
        
        cancelSearchBtn.backgroundColor = .white
        cancelSearchBtn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        cancelSearchBtn.imageEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        cancelSearchBtn.translatesAutoresizingMaskIntoConstraints = false
        self.searchBarContainerView.addSubview(cancelSearchBtn)
        
        NSLayoutConstraint.activate([
            cancelSearchBtn.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor, constant: -16),
            cancelSearchBtn.centerYAnchor.constraint(equalTo: searchBarContainerView.centerYAnchor),
            cancelSearchBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 0.0),
            cancelSearchBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        searchBarTextField.placeholder = "search"
        searchBarTextField.borderStyle = .none
        searchBarContainerView.addSubview(searchBarTextField)
        searchBarTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBarTextField.leadingAnchor.constraint(equalTo: searchBarImageView.trailingAnchor,constant: 12),
            searchBarTextField.trailingAnchor.constraint(equalTo: cancelSearchBtn.leadingAnchor,constant: -16),
            searchBarTextField.centerYAnchor.constraint(equalTo: searchBarContainerView.centerYAnchor),
            searchBarTextField.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        seperatorView.backgroundColor = UIColor.black
        self.addSubview(seperatorView)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        self.cancelSearchBtn.alpha = 0.0
        
    }
}
