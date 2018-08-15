//
//  Helper.swift
//  WheatWeather
//
//  Created by vincent on 16/5/15.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit
//左右界面的背景颜色
let leftControllerAndRightControllerBGColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(37.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)

let LeftControllerTypeChangedNotification = "LeftControllerTypeChangedNotification"

let AutoLocationNotification = "AutoLocationNotification"
let ChooseLocationCityNotification = "ChooseLocationCityNotification"
let DeleteHistoryCityNotification = "DeleteHistoryCityNotification"
//如何存储历史城市记录
//文件读写
let history_city_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "history_city_path.txt"

//ShareSDK
let ShareSDK_AppKey = "13f51d950af24"

//sina 
let Sina_AppKey = "1262130187"
let Sina_AppSecret = "b621c2fa81fba409806bd1b95cbfad82"
let Sina_OAuth_Html = "http://www.baidu.com"

//QQ
let QQ_AppID = "1105477372"
let QQ_AppKey = "qJW9hgLWi6tXNzOl"

//wechat
let weixin_AppID = "wx8571a4f11404252a"
let weixin_AppSecret = "129663c38c2a9302ec7ba3b608a245c8"

class Helper: NSObject {

    class func readChaceCity()->[String] {
        
        let array = NSArray(contentsOfFile: history_city_path)
        if array == nil {
            return []
        }else {
            if array?.count == 0 {
                return []
            }else {
                var citys = [String]()
                for ele in array! {
                    citys.append(ele as! String)
                }
                return citys
            }
        }
    }
    
    class func inseartCity(city:String)->Bool {
       //判断 是否 存在
        var old_citys = Helper.readChaceCity()
        if old_citys.contains(city) {
            let index = old_citys.index(of: city)
            old_citys.remove(at: index!)
        }
        //将city插入到数据的最前面
        old_citys.insert(city, at: 0)
        let array = NSMutableArray()
        for ele in old_citys {
            array.add(ele)
        }
        
        return array.write(toFile: history_city_path, atomically: true)
    }
    
    class func deleteCity(city:String)->Bool {
        //判断 是否 存在
        var old_citys = Helper.readChaceCity()
        if old_citys.contains(city) {
            let index = old_citys.index(of: city)
            old_citys.remove(at: index!)
        }
        let array = NSMutableArray()
        for ele in old_citys {
            array.add(ele)
        }
        
        return array.write(toFile: history_city_path, atomically: true)
    }
    
    
    
    
}
