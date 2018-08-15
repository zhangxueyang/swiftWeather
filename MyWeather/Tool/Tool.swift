//
//  Tool.swift
//  WheatWeather
//
//  Created by vincent on 16/5/23.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class Tool {
    
    class func returnDate(date:NSDate)->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch") as Locale?
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: date as Date)
    }
    
    enum WeekDays:String {
        case Monday = "周一"
        case Tuesday = "周二"
        case Wednesday = "周三"
        case Thursday = "周四"
        case Friday = "周五"
        case Saturday = "周六"
        case Sunday = "周日"
    }
    
    class func returnWeekDay(date:NSDate)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch") as Locale?
        dateFormatter.dateFormat = "EEEE"
        let dateStr = dateFormatter.string(from: date as Date)
        switch dateStr {
            case "Monday":
            return WeekDays.Monday.rawValue
        case "Tuesday":
            return WeekDays.Tuesday.rawValue
        case "Wednesday":
            return WeekDays.Wednesday.rawValue
        case "Thursday":
            return WeekDays.Thursday.rawValue
        case "Friday":
            return WeekDays.Friday.rawValue
        case "Saturday":
            return WeekDays.Saturday.rawValue
        default:
            return WeekDays.Sunday.rawValue
        }
        
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return .gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1)) 
    }
    
    class func returnWeatherBGColor(weatherType:String)->UIColor {
        let weatherTypePath = Bundle.main.path(forResource: "weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if element as! String == weatherType || weatherType.hasPrefix(element as! String) {
                    let key = element as! String
                    let value = json![key] as! String
                    return Tool.colorWithHexString(hex: value)
                }
            }
        }
        
        return .gray
        
    }
    class func returnWeatherType(weatherType:String)->String {
        let weatherTypePath = Bundle.main.path(forResource: "weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weatherType.hasPrefix(element as! String) {
                    
                    return element as! String
                }
            }
        }
        
        return weatherType
        
    }
    
    class func returnWeatherImage(weatherType:String)->UIImage? {
        let weatherTypePath = Bundle.main.path(forResource: "weatherImage", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weatherType.hasPrefix(element as! String) {
                    
                    let value = json![element as! String] as! String
                    return UIImage(named: value)
                    
                }
            }
        }
        
        return nil
        
    }
    
    class func retrunNeedDay(getDateString:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch") as Locale?
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: getDateString)
        let newFormatter = DateFormatter()
        newFormatter.locale = NSLocale(localeIdentifier: "ch") as Locale?
        newFormatter.dateFormat = "MM/dd"
        let dateStr = newFormatter.string(from: date!)
        return dateStr
    }
    class func returnWeekDay(getWeekDayString:String)->String {
        if getWeekDayString == "星期一" {
            return "周一"
        }else if getWeekDayString == "星期二" {
            return "周二"
        }else if getWeekDayString == "星期三" {
            return "周三"
        }else if getWeekDayString == "星期四" {
            return "周四"
        }else if getWeekDayString == "星期五" {
            return "周五"
        }else if getWeekDayString == "星期六" {
            return "周六"
        }else {
            return "周日"
        }
    }
    
    class func handleMessageImage(weatherInfo:NSDictionary)->UIImage? {
        let temp_curr = weatherInfo["temp_curr"] as! String
        let temp_curr_number = NumberFormatter().number(from: temp_curr)
        if Int(truncating: temp_curr_number!) > 30 {
            return UIImage(named: "jrgw_normal")
        }
        
        var winp = weatherInfo["winp"] as! String
        winp.removeSubrange(winp.range(of: "级")!)
        let winp_number = Int(truncating: NumberFormatter().number(from: winp)!)
        if winp_number > 7 {
            return UIImage(named: "dflx_normal")
        }
        
        let weather = weatherInfo["weather"] as! String
        let weatherTypePath = Bundle.main.path(forResource: "weatherMessage", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weather.hasPrefix(element as! String) {
                    
                    let value = json![element as! String] as! String
                    return UIImage(named: value)
                    
                }
            }
        }
        
        
        return nil
    }
    
    
    //将某个view 转成 UIImage
    class func getImageFromView(view:UIView)->UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }

    
    
}
