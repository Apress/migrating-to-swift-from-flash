//
//  RoundedImageView.swift
//  iOSProject
//
//  Created by Hristo Lesev on 3/12/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.greenColor()
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = true;
    }
}
