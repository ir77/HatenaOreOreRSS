//
//  CustomCell.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(title: String, url: String) {
        self.title.text = title
        self.url.text = url
        self.url.textColor = UIColor.blueColor()
        // self.articleImage.layer.borderColor = UIColor.blackColor().CGColor
        // self.articleImage.layer.borderWidth = 0.3
        self.articleImage.layer.cornerRadius = 20
        self.articleImage.layer.masksToBounds = true
        self.articleImage.contentMode = UIViewContentMode.ScaleAspectFit
    }
}