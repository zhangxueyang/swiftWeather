//
//  MainViewController.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    //主滑动试图
    var myTabview :UITableView!
    //刷新试图
    let header = MJRefreshNormalHeader()
    //天气信息
    var cur_weather_info : NSDictionary?

    //位置管理  拿到位置的经纬度
    var locationManager : CLLocationManager?
    //根据经纬度 解析成地名
    var geocoder : CLGeocoder = CLGeocoder()
    //当前城市
    var current_city : String?
    
    //提示信息
    var hud : MBProgressHUD!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.label.text = "正在定位中....."
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.autoLocationAction(noti:)), name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseLocationCityAction(noti:)), name: NSNotification.Name(rawValue: ChooseLocationCityNotification), object: nil)
        
        //创建滑动试图
        setUPMainTableView()
        //刷新的代码
        setUPMainTableViewRefershs()
        
        //加载定位信息
        //如果用户第一次使用定位 使用自动定位
        //第二次 才从本地读取用户的位置
        //跟当前定位的比较  如果一样  不一样
        
        location()
        
        //设置导航栏 默认信息
        layoutNavigationBar(date: Tool.returnDate(date: NSDate()), weekDay: Tool.returnWeekDay(date: NSDate()), cityName: "深圳")
        //初始化的请求网络数据
        requestWeatherData(cityName: "深圳")
        //初始化当天数据
        requestCurrentMessage(cityName: "深圳")
        
    }

}

//MARK: ------ 通知方法
extension MainViewController {
    
    //自动定位
    @objc func autoLocationAction(noti:Notification)  {
        self.location()
    }
    
    //选择城市
    @objc func chooseLocationCityAction(noti:Notification)  {
        self.current_city = (noti.userInfo!["choose_city"] as! String)
        Helper.inseartCity(city: self.current_city!)
        self.initView()
    }

}



//MARK: ------ 设置定位信息
extension MainViewController : CLLocationManagerDelegate{
    
    //定位
    func location(){
        //判断定位是否打开
        if CLLocationManager.locationServicesEnabled() == false {
            print("定位未打开")
            self.hud.label.text = "定位未打开,请开启定位,获取您所在地区的天气信息!"
            self.hud.isHidden = true;
        }else {
            self.locationManager = CLLocationManager()
            //iOS8之后的定位需要用户授权
            if #available(iOS 8.0, *){
                self.locationManager!.requestAlwaysAuthorization()
            }
            //开始做定位
            self.locationManager!.delegate = self
            self.locationManager!.startUpdatingLocation()

        }
    }
    
    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.hud.label.text = "定位失败"
        self.hud.isHidden = true;
    }
    
    //定位更新中
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            //停止定位
            manager.stopUpdatingLocation()
            //获取最后的定位信息
            let locaitonInfo = locations.last
            //获取地理位置
            self.geocoder.reverseGeocodeLocation(locaitonInfo!,completionHandler:{ (placeMarks, error) -> Void in
                //位置信息
                if placeMarks == nil{
                    return
                }
                
                if (placeMarks?.count)! > 0{
                   let placeM = placeMarks![0]
                    //获取城市信息
                    self.current_city = placeM.locality!
                    //定位成功。插入本地数据
                    //刷新UI
                    DispatchQueue.main.async {
                        if (self.current_city?.contains("市"))!{
                            let range = self.current_city?.range(of: "市")
                            self.current_city?.removeSubrange(range!)
                            //定位成功之后 插入本地数据
                            let _ = Helper.inseartCity(city: self.current_city!)
                        }
                        self.initView()
                    }
                }
                
            })
        }
    }
    
    func initView() {
        //更新导航栏的信息
        layoutNavigationBar(date: Tool.returnDate(date: NSDate()), weekDay: Tool.returnWeekDay(date: NSDate()), cityName: self.current_city!)
        
        self.hud.label.text = "定位成功,正在读取天气信息....."

        //请求 定位城市信息七天信息
        self.requestWeatherData(cityName: self.current_city!)
        
        //请求 定位城市当天天气信息
        self.requestCurrentMessage(cityName: self.current_city!)
        
        //修改表格颜色等信息
        

    }
    
}


//MARK: ------ 设置主UI
extension MainViewController{
    
    //创建主滑动试图
    private func setUPMainTableView() {
        myTabview = UITableView(frame: self.view.bounds, style: .plain)
        myTabview.delegate = self
        myTabview.dataSource = self
        myTabview.separatorStyle = .none
        myTabview.rowHeight = 720
        myTabview.isHidden = true
        myTabview.showsVerticalScrollIndicator = false
        myTabview.showsHorizontalScrollIndicator = false
        myTabview.register(UINib(nibName: String(describing: MainTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MainTableViewCell.self))
        view.addSubview(myTabview)
    }
    
    //设置舒心的业务
    private func setUPMainTableViewRefershs(){
        //设置下拉刷新
        myTabview.mj_header = header
        header.refreshingBlock = { () -> Void in
            self.requestWeatherData(cityName: self.current_city ?? "深圳")
            self.requestCurrentMessage(cityName: self.current_city ?? "深圳")
        }
    }
    
    //设置导航栏
    private func layoutNavigationBar(date:String,weekDay:String,cityName:String){
        
        self.navigationController?.navigationBar.tintColor = .white
        
        //日期图片
        let catogryBarItem = UIBarButtonItem(image: UIImage(named: "category_hover"), style: .plain, target: self, action: #selector(chooseDateAction(sender:)))
        catogryBarItem.imageInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        //日期
        let dateBarItem = UIBarButtonItem(title: date + "/" + weekDay, style: .plain, target: self, action: #selector(chooseDateAction(sender:)))
        self.navigationItem.leftBarButtonItems = [catogryBarItem,dateBarItem]
        
        //分享
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share_small_hover"), style: .plain, target: self, action: #selector(shareAction(sender:)))
        let cityBarItem = UIBarButtonItem(title: cityName, style: .plain, target: nil, action: nil)
        
        //设置
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "settings_hover"), style: .plain, target: self, action: #selector(settingAction(sender:)))
        self.navigationItem.rightBarButtonItems =  [settingBarItem,cityBarItem,shareBarItem]
        
    }
    
    //选择日期
    @objc func chooseDateAction(sender:UIBarButtonItem){
        print("1234")
    }
    
    //分享
    @objc func shareAction(sender:UIBarButtonItem){
        print("5678")
    }
    
    //设置
    @objc func settingAction(sender:UIBarButtonItem){
        print("12345678")
    }
    
}


extension MainViewController :UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableViewCell.self), for: indexPath) as! MainTableViewCell
        if self.cur_weather_info != nil {
            //需要构建一个 plist 文件 逻辑代码 来完善显示 不同的图片
            //天气
            let weather = self.cur_weather_info!["weather"] as! String
            //温度
            let temp = self.cur_weather_info!["temp_curr"] as! String
            let temp_high = self.cur_weather_info!["temp_high"] as! String
            let temp_low = self.cur_weather_info!["temp_low"] as! String
            //风向 风速
            let windy = self.cur_weather_info!["wind"] as! String
            //湿度
//            let humidity = self.cur_weather_info!["humidity"] as! String
            let humi_low = self.cur_weather_info!["humi_low"] as! String
            let humi_high = self.cur_weather_info!["humi_high"] as! String
            //主图
            cell.mainIcon.image = Tool.handleMessageImage(weatherInfo: self.cur_weather_info!)
            //天气
            cell.weatherIcon.image = Tool.returnWeatherImage(weatherType: weather)
            cell.weatherLab.text = weather
            //温度
            cell.tempLab.text = temp
            cell.tempLeatureRane.text = temp_low + "~" + temp_high
            //风级
            cell.windylab.text = windy
            //湿度
            cell.himidityRangeLab.text = humi_low + "~" + humi_high
            
        }
        return cell
    }
    
}

//获取网络数据
extension MainViewController {
    
    func requestWeatherData(cityName:String) {
        //请求七天的天气情况
        let session = URLSession.shared
        //在URL中不能够出现中文等特殊的字符
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = NSURL(string: urlString!)
        //创建请求对象
        let request = URLRequest(url: url! as URL)
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error == nil{
                                                let weatherInfo = try?
                                                    JSONSerialization.jsonObject(with: data!, options: .allowFragments)as! NSDictionary
                                                
                                                if weatherInfo!["success"]as!String == "0"{
                                                    return
                                                }
                                                
                                                let array = weatherInfo!["result"] as! NSArray
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LeftControllerTypeChangedNotification), object: nil, userInfo: ["data":array])
                                            }
                                            
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
    }
    
    
    func requestCurrentMessage(cityName:String) {
        
        //请求七天的天气情况
        let au_session = URLSession.shared
        //请求当天的天气信息
        let cur_urlString = "http://api.k780.com:88/?app=weather.today&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let cur_url = NSURL(string: cur_urlString!)
        //创建请求对象
        let cur_request = URLRequest(url: cur_url! as URL)
        
        let cur_task = au_session.dataTask(with: cur_request,
                                        completionHandler: {(data, response, error) -> Void in
                                            DispatchQueue.main.async {
                                                self.hud.isHidden = true
                                            }
                                            if error == nil {
                                                let weatherInfo = try? JSONSerialization.jsonObject(with:data!, options: .allowFragments) as! NSDictionary
                                                if weatherInfo!["success"]as!String == "0"{
                                                    return
                                                }
                                                let dic = weatherInfo!["result"] as! NSDictionary
                                                self.cur_weather_info = NSDictionary(dictionary: dic)
                                                
                                                DispatchQueue.main.async {
                                                    let cur_weather_msg = self.cur_weather_info!["weather"] as! String
                                                    self.view.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                                                    self.myTabview.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                                                    self.navigationController?.navigationBar.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                                                    
                                                    let indexPath = IndexPath(row: 0, section: 0)
                                                    let cell = self.myTabview.cellForRow(at: indexPath)
                                                    cell?.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                                                    
                                                    self.myTabview.isHidden = false
                                                    self.header.endRefreshing()
                                                    self.myTabview.reloadData()
                                                }
                                            }
          }) as URLSessionTask

        cur_task.resume()
        
    }
    

    
}
