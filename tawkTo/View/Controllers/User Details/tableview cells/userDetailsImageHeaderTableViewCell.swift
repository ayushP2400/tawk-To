//
//  userDetailsImageHeaderTableViewCell.swift
//  tawkTo
//
//  Created by love on 17/03/21.
//

import UIKit

class userDetailsImageHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: ImageLoader!
    @IBOutlet weak var userProfileBackgroundImageView: ImageLoader!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        userProfileImageView.setCornerRadius(40.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadImage(with urlString:String){
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed){
            if let url = URL(string: urlString){
                userProfileImageView.loadImageWithUrl(url) { (image) in
                    DispatchQueue.main.async {
                        self.userProfileImageView.image = image ?? #imageLiteral(resourceName: "userPlaceholder")
                    }
                }
                userProfileBackgroundImageView.loadImageWithUrl(url) { (image) in
                    DispatchQueue.main.async {
                        self.userProfileBackgroundImageView.image = image ?? #imageLiteral(resourceName: "userPlaceholder")
                    }
                }
            }
        }
    }
}
