//
//  MainTableViewCell.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var mainIcon: UIImageView!
    
    @IBOutlet weak var heartIcon: UIImageView!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var weatherLab: UILabel!
    
    @IBOutlet weak var tempLab: UILabel!
    
    @IBOutlet weak var tempLeatureRane: UILabel!
    
    @IBOutlet weak var windyIcon: UIImageView!
    
    @IBOutlet weak var windylab: UILabel!
    
    @IBOutlet weak var humidityIcon: UIImageView!
    
    @IBOutlet weak var himidityRangeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear
        
    }

    
}
