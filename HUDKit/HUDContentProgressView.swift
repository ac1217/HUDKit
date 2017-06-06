//
//  HUDContentProgress.swift
//  Example
//
//  Created by zhangweiwei on 2017/4/12.
//  Copyright © 2017年 erica. All rights reserved.
//

import UIKit

class HUDContentProgressView: UIView {
    
    /*lazy load*/
     lazy var progressLayer: CAShapeLayer = {
        
        let progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 2
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = kCALineCapRound
        
        return progressLayer
        
    }()
    
     lazy var progressLabel: UILabel = {
        
        let progressLabel = UILabel()
        progressLabel.font = UIFont.systemFont(ofSize: 10)
        progressLabel.textAlignment = .center
        
        return progressLabel
        
    }()
    
    var progress: Double = 0 {
        didSet {
            progressLayer.strokeEnd = CGFloat(progress)
            
            progressLabel.text = String(format: "%.f%%", progress * 100)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(progressLabel)
        layer.addSublayer(progressLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressLabel.frame = bounds
        progressLayer.frame = layer.bounds
        
        let path = UIBezierPath(arcCenter: CGPoint(x: progressLayer.frame.width * 0.5, y: progressLayer.frame.height * 0.5), radius: progressLayer.frame.height * 0.5, startAngle: CGFloat(-Double.pi * 0.5), endAngle: CGFloat(Double.pi * 3 / 2), clockwise: true)
        progressLayer.path = path.cgPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 关闭隐式动画
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        
        return NSNull()
    }

}
