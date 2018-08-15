//
//  LeftTableViewCell.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {
    //星期几
    @IBOutlet weak var weekDay: UILabel!
    //日期的
    @IBOutlet weak var dateDay: UILabel!
    //天气
    @IBOutlet weak var weatherLab: UILabel!
    //温度
    @IBOutlet weak var temperatureLab: UILabel!
    //背景
    @IBOutlet weak var weatherBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        //设置圆角
        weatherBackView.layer.cornerRadius = 8.0
        weatherBackView.layer.masksToBounds = true
    }

}
