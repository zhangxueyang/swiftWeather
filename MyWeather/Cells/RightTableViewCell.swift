//
//  RightTableViewCell.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    @IBOutlet weak var cityIcon: UIImageView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var cityLab: UILabel!
    
    var controller : UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        deleteIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.deleteIconClicked))
        deleteIcon.addGestureRecognizer(tap)
    }
    
    @objc func deleteIconClicked() {
        
        print("123")
        
        let alert = UIAlertController(title: "提示", message: "您是否要删除 \" \(self.cityLab.text!) \"", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancleAction)
        
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) -> Void in
            let _ = Helper.deleteCity(city: self.cityLab.text!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:DeleteHistoryCityNotification), object: nil)
        }
        
        alert.addAction(okAction)
        
        self.controller?.present(alert, animated: true, completion: nil)
        
    }
    
}
