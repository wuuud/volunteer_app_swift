//
//  VolunteerOfferTableViewCell.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/13.
//

import UIKit

class VolunteerOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var npoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var npoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
