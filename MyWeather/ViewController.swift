//
//  ViewController.swift
//  MyWeather
//
//  Created by 张学阳 on 2018/8/13.
//  Copyright © 2018年 张学阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mainVC : UIViewController?
    
    var leftViewController : LeftTableViewController?
    
    var rightViewController : RightTableViewController?
    
    //手指滑动速率
    var speed_f :CGFloat?
    
    //条件 什么时候显示中间的 左边  右边 view
    var condition_f :CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.autoLocationAction(noti:)), name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseLocationCityAction(noti:)), name: NSNotification.Name(rawValue: ChooseLocationCityNotification), object: nil)
        
        //滑动速率
        speed_f = 0.5
        condition_f = 0
        
        let rootController = MainViewController()
        mainVC = UINavigationController(rootViewController: rootController)
        
        leftViewController = LeftTableViewController()
        view.addSubview((leftViewController?.view)!)
        
        rightViewController = RightTableViewController()
        view.addSubview((rightViewController?.view)!)
        
        view.addSubview((mainVC?.view)!)
        
        leftViewController?.view.isHidden = true
        rightViewController?.view.isHidden = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:)))
        mainVC?.view.addGestureRecognizer(pan)
        
    }
    
    //MARK: ------ 通知方法
    //自动定位
    @objc func autoLocationAction(noti:Notification)  {
        showMainView()
    }
    
    //选择城市
    @objc func chooseLocationCityAction(noti:Notification)  {
        showMainView()
    }

    @objc func panAction(sender:UIPanGestureRecognizer){
        //获取手指的位置
        let point = sender.translation(in: sender.view)
        //滑动位置
        condition_f = point.x * speed_f! + condition_f!
        
        if (sender.view?.frame.origin.x)! >= CGFloat(0) {
            //往左滑动
            sender.view?.center = CGPoint(x: (sender.view?.center.x)! + point.x*speed_f!, y: (sender.view?.center.y)!)
            //矫正手指的位置
            sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
            rightViewController?.view.isHidden = true
            leftViewController?.view.isHidden = false
        }else{
            sender.view?.center = CGPoint(x: (sender.view?.center.x)! + point.x*speed_f!, y: (sender.view?.center.y)!)
            //矫正手指的位置
            sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
            rightViewController?.view.isHidden = false
            leftViewController?.view.isHidden = true
        }
        
        if sender.state == .ended {
            //当手指离开屏幕时
            if condition_f! > UIScreen.main.bounds.size.width*CGFloat(0.5)*speed_f!{
                //显示左边
                showLeftView()
            }else if condition_f! < UIScreen.main.bounds.size.width*CGFloat(-0.5)*speed_f!{
                showRightView()
            }else{
                showMainView()
            }
        }
    }
    
    
    func showMainView() {
        UIView.beginAnimations(nil, context: nil)
        mainVC?.view.center = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.height*0.5)
        UIView.commitAnimations()
    }
    
    func showLeftView() {
        UIView.beginAnimations(nil, context: nil)
        mainVC?.view.center = CGPoint(x: UIScreen.main.bounds.size.width*CGFloat(1.5)-CGFloat(60), y: UIScreen.main.bounds.height*0.5)
        UIView.commitAnimations()
    }
    
    func showRightView() {
        UIView.beginAnimations(nil, context: nil)
        mainVC?.view.center = CGPoint(x: CGFloat(60) - UIScreen.main.bounds.size.width*CGFloat(0.5), y: UIScreen.main.bounds.height*0.5)
        UIView.commitAnimations()
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

