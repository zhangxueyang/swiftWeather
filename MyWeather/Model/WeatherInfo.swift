//
//  WeatherInfo.swift
//  WheatWeather
//
//  Created by vincent on 16/5/23.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class WeatherInfo: NSObject {
/*
    {
    cityid = 101280601;
    citynm = "\U6df1\U5733";
    cityno = shenzhen;
    days = "2016-05-23";
    "humi_high" = 0;
    "humi_low" = 0;
    humidity = "0\U2109/0\U2109";
    "temp_high" = 30;
    "temp_low" = 25;
    temperature = "30\U2103/25\U2103";
    weaid = 169;
    weather = "\U591a\U4e91";
    "weather_icon" = "http://api.k780.com:88/upload/weather/d/1.gif";
    "weather_icon1" = "http://api.k780.com:88/upload/weather/n/1.gif";
    weatid = 2;
    weatid1 = 2;
    week = "\U661f\U671f\U4e00";
    wind = "\U65e0\U6301\U7eed\U98ce\U5411";
    windid = 124;
    winp = "\U5fae\U98ce";
    winpid = 125;
    },
    */
    
    @objc var cityid:String?
    @objc var citynm:String?
    @objc var cityno:String?
    @objc var days:String?
    @objc var humi_high:String?
    
    @objc var humi_low:String?
    @objc var humidity:String?
    @objc var temp_high:String?
    @objc var temp_low:String?
    @objc var temperature:String?

    @objc var weaid:String?
    @objc var weather:String?
    @objc var weather_icon:String?
    @objc var weather_icon1:String?
    @objc var weather_iconid:String?
    
    @objc var weather_iconid1:String?
    @objc var week:String?
    @objc var wind:String?
    @objc var winp:String?
    @objc var weatid:String?
    
    @objc var weatid1:String?
    @objc var windid:String?
    @objc var winpid:String?
    
    init(dic:NSDictionary) {
        super.init()
        self.setValuesForKeys(dic as! [String : AnyObject])
    }
}
