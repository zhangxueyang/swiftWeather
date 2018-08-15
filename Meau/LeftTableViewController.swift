//
//  LeftTableViewController.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class LeftTableViewController: UITableViewController {

    var dataSource = [WeatherInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: String(describing: LeftTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: String(describing: LeftTableViewCell.self))
        
        tableView.rowHeight = 100;
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        
        //添加观看数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData(noti:)), name: NSNotification.Name(rawValue: LeftControllerTypeChangedNotification), object: nil)
    }
    
    @objc func refreshData(noti:Notification) {
        let info = noti.userInfo!["data"] as! NSArray
        self.dataSource.removeAll()
        for ele in info {
            let dic = ele as! NSDictionary
            let weather = WeatherInfo(dic: dic)
            self.dataSource.append(weather)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension LeftTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LeftTableViewCell.self), for: indexPath) as! LeftTableViewCell
        let dayWeather = dataSource[indexPath.row]
        cell.dateDay.text = Tool.retrunNeedDay(getDateString: dayWeather.days!)
        cell.weekDay.text = dayWeather.week
        cell.temperatureLab.text = dayWeather.temp_low! + "~" + dayWeather.temp_high!
        cell.weatherLab.text = Tool.returnWeatherType(weatherType: dayWeather.weather!)
        cell.weatherBackView.backgroundColor = Tool.returnWeatherBGColor(weatherType: dayWeather.weather!)        
        if indexPath.row == 0 {
            cell.weekDay.text = "今天"
        }else if indexPath.row == 1{
            cell.weekDay.text = "明天"
        }
        return cell
    }
}






