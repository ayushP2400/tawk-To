//
//  userDetailsFieldsTableViewCell.swift
//  tawkTo
//
//  Created by love on 17/03/21.
//

import UIKit

class userDetailsFieldsTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldTitleLbl: UILabel!
    @IBOutlet weak var fieldValueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
