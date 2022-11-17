//
//  ApplicationTableViewCell.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

import UIKit

class ApplicationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var volunteerLabel: UILabel!
    @IBOutlet weak var careerTextView: UITextView!
    @IBOutlet weak var volunteerImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
