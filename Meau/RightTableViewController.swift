//
//  RightTableViewController.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class RightTableViewController: UITableViewController {
    //需要从本地做存储
    var historyCity = Helper.readChaceCity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置主UI
        setupMainUI()
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteHistoryCity(noti:)), name: NSNotification.Name(rawValue: DeleteHistoryCityNotification), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyCity = Helper.readChaceCity()
        tableView.reloadData()
    }
}

//MARK:--------- 设置主UI
extension RightTableViewController {
    
    @objc func deleteHistoryCity(noti:Notification) {
        historyCity = Helper.readChaceCity()
        tableView.reloadData()
    }
    
    private func setupMainUI() {
        let nib = UINib(nibName: String(describing: RightTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: String(describing: RightTableViewCell.self))
        self.tableView.rowHeight = 70;
        self.tableView.separatorStyle = .none
    }
    
}

//MARK:---------UITableViewDelegate  UITableViewDataSource
extension RightTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + historyCity.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 80.0, y: 0.0, width: self.view.frame.size.width, height: 40.0))
        label.text = "城市管理"
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RightTableViewCell.self), for: indexPath) as! RightTableViewCell
        cell.cityLab.textColor = .white
        if indexPath.row == 0 {
            cell.cityLab.text = "添加"
            cell.cityIcon.image = UIImage(named: "addcity")
            cell.deleteIcon.isHidden = true
        }
        else if indexPath.row == 1 {
            cell.cityLab.text = "定位"
            cell.cityIcon.image = UIImage(named: "city")
            cell.deleteIcon.isHidden = true
        }
        else {
            cell.cityIcon.image = UIImage(named: "city")
            cell.deleteIcon.isHidden = false
            cell.cityLab.text = historyCity[indexPath.row - 2]
            cell.controller = self
        }
        return cell
    }
    
    @objc func deleteIconClicked(indexPath:IndexPath){
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //添加信息
            let city = NewCityListViewController()
            self.present(city, animated: true, completion: nil)
        }else if indexPath.row == 1{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChooseLocationCityNotification), object: nil, userInfo: ["choose_city":historyCity[indexPath.row - 2]])
        }
     }
    
}






