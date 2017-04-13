//
//  ViewController.swift
//  HUD
//
//  Created by zhangweiwei on 2016/10/17.
//  Copyright © 2016年 erica. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置全局样式
        
        //        HUD.defaultLoadingImages = [UIImage(named: "dyla_img_loading_1")!,  UIImage(named: "dyla_img_loading_2")!]
        
        HUD.defaultAnimationDuration = 1
        //        HUD.defaultStyle = .custom
        //        HUD.defaultStyleColor = UIColor.blue
        //        HUD.defaultTextColor = UIColor.white
        //        HUD.defaultStyleAlpha = 0.2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        view.hud.dismiss()
    }
    @IBAction func info(_ sender: Any) {
        view.hud.showInfo("哈哈哈哈")
    }
    
    @IBAction func success(_ sender: Any) {
        
        let hud = view.hud
        hud.delay = 5
        //        hud.successImage = UIImage(named: "back-chevron")
        view.hud.showSuccess("保存成功")
        
    }
    
    @IBAction func error(_ sender: Any) {
        
        view.hud.showError("保存失败")
        
    }
    
    
    @IBAction func loading(_ sender: Any) {
        
        view.hud.showLoading("加载中")
        
    }
    
    @IBAction func layout(_ sender: UIButton) {
        
        if HUD.defaultLayoutDirection == .horizontal {
            HUD.defaultLayoutDirection = .vertical
            
            sender.setTitle("vertical", for: .normal)
            
        }else {
            
            HUD.defaultLayoutDirection = .horizontal
            sender.setTitle("horizontal", for: .normal)
        }
        
        
    }
    @IBAction func notification() {
        
        view.hud.showNotification(UIImage(named: "Shape"), msg: "1232131", detailMsg: "sadadb nkcxzkndkan asn kajsd nsdjk上岛咖啡的所肩负的看附近的时刻富家大室积分的时刻附近的看法独守空房的首付款绝对是开发打瞌睡附近反倒是开发绝对是开发就代收款复健科")
        
    }
    @IBAction func progress(_ sender: Any) {
        
        var progress: Double = 0
        
        let timer = Timer(timeInterval: 0.5, repeats: true, block: {[unowned self] timer in
            
            progress += 0.1
            
            self.view.hud.showProgress(progress, msg: "正在上传")
            //            self.view.hud.show(progress: progress)
            if progress >= 1 {
                timer.invalidate()
                self.view.hud.showSuccess("上传成功")
            }
            
        })
        
        RunLoop.current.add(timer, forMode: .commonModes)
        
    }
    
}

