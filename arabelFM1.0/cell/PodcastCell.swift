//
//  PodcastCell.swift
//  arabelFM1.0
//
//  Created by Admin on 19/11/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {

    @IBOutlet weak var imgPodcast: UIImageView!
    @IBOutlet weak var labelPodcast: UILabel!
    
     /// voir documentation apple
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

     ///  voir documentation apple
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
