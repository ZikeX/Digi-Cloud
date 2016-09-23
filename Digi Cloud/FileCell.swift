//
//  FileCell.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 19/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {

    @IBOutlet var fileNameLabel: UILabel!
    
    @IBOutlet var fileSizeLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func action(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = UIColor(colorLiteralRed: 37/255, green: 116/255, blue: 255/255, alpha: 1.0)
            self.fileNameLabel.textColor = UIColor.white
            self.fileSizeLabel.textColor = UIColor(colorLiteralRed: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            self.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.actionButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            self.contentView.backgroundColor = nil
            self.fileNameLabel.textColor = UIColor.black
            self.fileSizeLabel.textColor = UIColor.darkGray
            self.separatorInset = UIEdgeInsets(top: 0.0, left: 53.0, bottom: 0.0, right: 0.0)
            self.actionButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
    }
}