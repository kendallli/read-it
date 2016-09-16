//
//  RSSTableViewCell.swift
//  Read It
//
//  Created by Rui Li on 9/15/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import UIKit
// customized table view cell
class RSSTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
