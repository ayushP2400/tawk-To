//
//  userListTableViewCell.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import UIKit

class userListTableViewCell: UITableViewCell {
    
    var containerView = UIView()
    var imageContainerView = userImageContainerView()
    var userNameLbl = UILabel()
    var detailBtn = UIButton.init(type: .custom)
    var userNameAndDetailsStackView = UIStackView()

    var model: regularElement!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }

    
    func initViews(){
        containerView.setBorder(with: 1, color: UIColor.black)
        containerView.setCornerRadius(8)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
        
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageContainerView)
        
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageContainerView.widthAnchor.constraint(equalToConstant: 50.0),
            imageContainerView.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        userNameLbl.font = .systemFont(ofSize: 17, weight: .medium)
        userNameLbl.text = "Test Name"
        userNameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        detailBtn.setTitle("details", for: .normal)
        detailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        detailBtn.translatesAutoresizingMaskIntoConstraints = false
        detailBtn.contentHorizontalAlignment = .left
        detailBtn.setTitleColor(.black, for: .normal)

        userNameAndDetailsStackView.alignment = .fill
        userNameAndDetailsStackView.distribution = .fillEqually
        userNameAndDetailsStackView.axis = .vertical
        userNameAndDetailsStackView.spacing = 5
        userNameAndDetailsStackView.addArrangedSubview(userNameLbl)
        userNameAndDetailsStackView.addArrangedSubview(detailBtn)
        userNameAndDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(userNameAndDetailsStackView)

        NSLayoutConstraint.activate([
            userNameAndDetailsStackView.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 16),
            userNameAndDetailsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            userNameAndDetailsStackView.heightAnchor.constraint(equalToConstant: 45),
            userNameAndDetailsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    
        
    }
    
}


extension userListTableViewCell:CustomElementCell{
    func configure(withModel: CustomElementModel,indexPath:IndexPath) {
        guard let model = withModel as? regularElement else {
            print("Unable to cast model as ProfileElement: \(withModel)")
            return
        }
        
        self.model = model
        self.userNameLbl.text = self.model.userDetails.login
        self.backgroundColor = !model.userDetails.isVisited ? UIColor.white : UIColor.gray.withAlphaComponent(0.3)
        if let urlString = (self.model.userDetails.avatar_url ?? "").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed){
            if let url = URL(string: urlString){
                imageContainerView.imageView.loadImageWithUrl(url) { (image) in
                    DispatchQueue.main.async {
                        self.imageContainerView.imageView.image = image ?? #imageLiteral(resourceName: "userPlaceholder")
                    }
                }
            }
        }
    }
}
