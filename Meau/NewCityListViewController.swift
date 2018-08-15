//
//  NewCityListViewController.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/14.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class NewCityListViewController: UITableViewController {

    //数据源
    var defaultCitys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setmainUI()
        setmainData()
        
    }

}

extension NewCityListViewController {
    
    func setmainUI()  {
        tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    private func setmainData() {
        let path = Bundle.main.path(forResource: "default-city", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        for emel in arr! {
            self.defaultCitys.append(emel as! String)
        }
        self.tableView.reloadData()
    }
}

// MARK: - Table view data source
extension NewCityListViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.defaultCitys.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        if indexPath.row == 0{
            cell.textLabel?.text = "自动定位"
            cell.imageView?.image = UIImage(named: "city")
        }else{
            cell.textLabel?.text = self.defaultCitys[indexPath.row-1]
            cell.imageView?.image = UIImage(named: "")
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChooseLocationCityNotification), object: nil, userInfo: ["choose_city":self.defaultCitys[indexPath.row-1]])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}




