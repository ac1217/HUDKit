//
//  HUD.swift
//  HUD
//
//  Created by zhangweiwei on 2016/10/17.
//  Copyright © 2016年 erica. All rights reserved.
//

import UIKit

public enum HUDStyle : Int {
    
    case light
    case dark
    case custom
    
}

public enum HUDMaskType : Int {
    
    case none
    case black
    case clear
    case custom
    
}

public enum HUDLayoutDirection : Int {
    
    case vertical
    
    case horizontal
    
}

public protocol HUDtable {
    
    var hud: HUD { get }
    
}

extension UIView: HUDtable {
    
    public var hud: HUD{
        
        var hud: HUD!
        for subview in subviews {
            
            if subview is HUD {
                
                hud = subview as! HUD
                break
            }
        }
        
        if hud == nil {
            hud = HUD()
            addSubview(hud)
            hud.frame = bounds
            hud.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        hud.reset()
        
        return hud
        
    }
    
}

fileprivate enum HUDLoadingAnimation : Int {
    
    case rotation
    case gif
    case none
    
}

fileprivate enum HUDState : Int {
    
    case info
    case success
    case error
    case loading
    case progress
    
}

public extension HUD {
    
     func show(success: String?) {
        
        label.text = success
        
        state = .success
        
        
    }
    
     func show(error: String?){
        
        label.text = error
        
        state = .error
        
    }
    
     func show(loading: String? = nil){
        
        label.text = loading
        
        state = .loading
        
    }
    
     func show(info: String?) {
        
        label.text = info
        
        state = .info
        
    }
    
     func show(progress: Double, status: String? = nil) {
        
        label.text = status
        
        state = .progress
        
        progressLayer.strokeEnd = CGFloat(progress)
        
        if !isShowProgress {
            return
        }
        progressLabel.text = String(format: "%.f%%", progress * 100)
        
    }
    
    
     func dismiss(){
        
        timer?.invalidate()
        timer = nil
        
        UIView.animate(withDuration: 0.25, animations: { 
            
            self.alpha = 0
        }) { (_) in
            
            self.removeFromSuperview()
        }
        
    }
    
    
     func reset() {
        
        contentInset = HUD.defaultContentInset
        horizontalMargin = HUD.defaultHorizontalMargin
        verticalMargin = HUD.defaultVerticalMargin
        delay = HUD.defaultDelay
        maskType = HUD.defaultMaskType
        style = HUD.defaultStyle
        successImage = HUD.defaultSuccessImage
        errorImage = HUD.defaultErrorImage
        loadingImage = HUD.defaultLoadingImage
        loadingImages = HUD.defaultLoadingImages
        infoImage = HUD.defaultInfoImage
        layoutDirection = HUD.defaultLayoutDirection
        animationDuration = HUD.defaultAnimationDuration
        
    }
    
    
}



open class HUD: UIView {
    /************
     
     配置全局属性
     
     *************/
    
    open static var defaultDelay: TimeInterval = 2
    open static var defaultStyle: HUDStyle = .dark
    open static var defaultMaskType: HUDMaskType = .none
    open static var defaultSuccessImage: UIImage?
    open static var defaultErrorImage: UIImage?
    open static var defaultInfoImage: UIImage?
    open static var defaultLoadingImage: UIImage?
    open static var defaultLayoutDirection: HUDLayoutDirection = .vertical
    open static var defaultLoadingImages: [UIImage]?
    open static var defaultAnimationDuration: TimeInterval = 2
    
    open static var defaultContentInset: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    open static var defaultHorizontalMargin: CGFloat = 10
    open static var defaultVerticalMargin: CGFloat = 10
    open static var defaultProgressSize: CGSize = CGSize(width: 35, height: 35)
    
    open static var isDefaultShowProgress = true
    
    open static var defaultStyleColor: UIColor?
    open static var defaultTextColor: UIColor?
    open static var defaultStyleAlpha: CGFloat = 0.75
    
/************ 
     
可针对某实例配置对应属性,默认是使用全局属性
     
*************/
    
    /*内容边距*/
    open var contentInset: UIEdgeInsets = defaultContentInset
    /*水平间距*/
    open var horizontalMargin: CGFloat = defaultHorizontalMargin
    /*垂直间距*/
    open var verticalMargin: CGFloat = defaultVerticalMargin
    /*自动消失时间*/
    open var delay = defaultDelay
    /*进度环size大小*/
    open var progressSize = defaultProgressSize
    /*内容布局方向*/
    open var layoutDirection = defaultLayoutDirection
    /*成功的图片*/
    open var successImage = defaultSuccessImage
    /*失败的图片*/
    open var errorImage = defaultErrorImage
    /*提示的图片*/
    open var infoImage = defaultInfoImage
    /*loading的图片,旋转动画*/
    open var loadingImage = defaultLoadingImage
    /* loadingImages 比 loadingImage 优先级更高,优先使用自定义gif动画 */
    open var loadingImages = defaultLoadingImages
    /*动画时长*/
    open var animationDuration = defaultAnimationDuration
    /*是否需要展示具体进度值*/
    open var isShowProgress = isDefaultShowProgress
    /*hud背景颜色,当style==.custom时生效*/
    open var styleColor = defaultStyleColor
    /*hud文字颜色,当style==.custom时生效*/
    open var textColor = defaultTextColor
    /*style content背景alpha值*/
    open var styleAlpha = defaultStyleAlpha
    
    /*背景遮罩样式*/
    open var maskType: HUDMaskType = defaultMaskType{
        didSet{
            
            switch maskType {
            case .none:
                backgroundColor = UIColor.clear
                isUserInteractionEnabled = false
                
            case .clear:
                backgroundColor = UIColor.clear
                isUserInteractionEnabled = true
                
            case .black:
                backgroundColor = UIColor(white: 0, alpha: 0.25)
                isUserInteractionEnabled = true
                
                
            case .custom:
                break
                
            }

        }
    }
    /*内容样式*/
    open var style: HUDStyle = defaultStyle{
        didSet{
            switch style {
            case .dark:
                
                contentView.backgroundColor = UIColor(white: 0, alpha: styleAlpha)
                
                label.textColor = UIColor.white
                
                
            case .light:
                contentView.backgroundColor = UIColor(white: 1, alpha: styleAlpha)
                
                label.textColor = UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1)
                
                
            case .custom:
                contentView.backgroundColor = styleColor?.withAlphaComponent(styleAlpha)
                
                label.textColor = textColor
                
                
            }
            
            progressLayer.strokeColor = label.textColor.cgColor
            progressLabel.textColor = label.textColor

        }
    }
    
        /*lazy load*/
    fileprivate lazy var progressLayer: CAShapeLayer = {
       
        let progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 2
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = kCALineCapRound
        
        return progressLayer
        
    }()
    
    fileprivate lazy var progressLabel: UILabel = {
       
        let progressLabel = UILabel()
        progressLabel.font = UIFont.systemFont(ofSize: 10)
        progressLabel.textAlignment = .center
        
        return progressLabel
        
    }()
    
    fileprivate lazy var contentView: UIView = {
       
        let contentView = UIView()
        
        contentView.layer.cornerRadius = 10
        
        return contentView
        
    }()
    
   fileprivate lazy var label: UILabel = {
        
        let label = UILabel()
    
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    fileprivate lazy var imageView: UIImageView = {
       
        let iv = UIImageView()
        return iv
        
    }()
    /*life cycle*/
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(progressLabel)
        contentView.layer.addSublayer(progressLayer)
        
        reset()
        
    }
    
    
     override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        if state == .progress {
            
            imageView.frame.size = progressSize
            
        }else {
            
            imageView.sizeToFit()
        }
        
        if layoutDirection == .horizontal {
            
            let contentH = max(label.frame.height, imageView.frame.size.height) + contentInset.top + contentInset.bottom
            
            label.frame.size = label.sizeThatFits(CGSize(width: bounds.width * 0.75 - imageView.frame.size.width - horizontalMargin, height: 0))
            
            var contentW = contentInset.left + contentInset.right
            
            var startX = contentInset.left
            if imageView.frame.size != CGSize.zero {
                contentW += imageView.frame.size.width
                
                imageView.frame.origin.x = startX
                progressLayer.frame.origin.x = startX
                
                startX = imageView.frame.maxX + horizontalMargin
                
            }
            
            if label.frame.size != CGSize.zero {
                contentW += label.frame.size.width + horizontalMargin
                label.frame.origin.x = startX
            }

            contentView.frame.size = CGSize(width: contentW, height: contentH)
            contentView.center = center
            
            label.center.y = contentView.frame.height * 0.5
            imageView.center.y = label.center.y
            
        }else {
            
            label.frame.size = label.sizeThatFits(CGSize(width: bounds.width * 0.75, height: 0))
            
            var contentH = contentInset.top + contentInset.bottom
            
            var startY = contentInset.top
            if imageView.frame.size != CGSize.zero {
                contentH += imageView.frame.size.height
                
                imageView.frame.origin.y = startY
                
                startY = imageView.frame.maxY + verticalMargin
                
            }
            
            if label.frame.size != CGSize.zero {
                contentH += label.frame.size.height + verticalMargin
                label.frame.origin.y = startY
            }
            
            let contentW = max(label.frame.width, imageView.frame.size.width) + contentInset.left + contentInset.right
            
            contentView.frame.size = CGSize(width: contentW, height: contentH)
            contentView.center = center
            
            label.center.x = contentView.frame.width * 0.5
            imageView.center.x = label.center.x
        }
        
        progressLayer.frame = imageView.frame
        
        let path = UIBezierPath(arcCenter: CGPoint(x: progressLayer.frame.width * 0.5, y: progressLayer.frame.height * 0.5), radius: progressLayer.frame.height * 0.5, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
        progressLayer.path = path.cgPath
        
        progressLabel.frame = imageView.frame
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var state: HUDState = .success{
        didSet{
            
            removeTimer()
            
            switch state {
            case .info:
                
                imageView.isHidden = false
                
                progressLayer.isHidden = true
                progressLabel.isHidden = true
                
                imageView.image = infoImage ?? UIImage.bundleImage(named: "info")?.render(color: label.textColor)
                loadingAnimation = .none
                
                addTimer()
                
            case .success:
                
                imageView.isHidden = false
                
                progressLayer.isHidden = true
                progressLabel.isHidden = true
                
                imageView.image = successImage ?? UIImage.bundleImage(named: "success")?.render(color: label.textColor)
                loadingAnimation = .none
                addTimer()
                
            case .error:
                
                imageView.isHidden = false
                
                progressLayer.isHidden = true
                progressLabel.isHidden = true
                
                imageView.image = errorImage ?? UIImage.bundleImage(named: "error")?.render(color: label.textColor)
                
                loadingAnimation = .none
                addTimer()
                
            case .loading:
                
                imageView.isHidden = false
                
                progressLayer.isHidden = true
                progressLabel.isHidden = true
                
                loadingAnimation = (loadingImages == nil) ? .rotation : .gif
                
            case .progress:
                
                loadingAnimation = .none
                imageView.isHidden = true
                progressLayer.isHidden = false
                progressLabel.isHidden = false
                
            }
            
            setNeedsLayout()
            
            if transform == .identity {
                return
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
                
                self.transform = CGAffineTransform.identity
                
            }, completion: nil)
            
        }
    }

    fileprivate var loadingAnimation: HUDLoadingAnimation = .none {
        
        didSet{
            
            switch loadingAnimation {
                
            case .none:
                
                imageView.stopAnimating()
                imageView.animationImages = nil
                imageView.layer.removeAnimation(forKey: "rotation")
                
            case .rotation:
                
                imageView.image = loadingImage ?? UIImage.bundleImage(named: "loading")?.render(color: label.textColor)
                
                let anim = CABasicAnimation(keyPath: "transform.rotation.z")
                anim.toValue = M_PI * 2.0
                anim.duration = animationDuration
                anim.repeatCount = MAXFLOAT
                imageView.layer.add(anim, forKey: "rotation")

            case .gif:
                
                imageView.animationImages = loadingImages
                imageView.animationDuration = animationDuration
                imageView.startAnimating()
            }
            
        }
        
    }
    
    
    fileprivate var timer: Timer?
    
    fileprivate func removeTimer(){
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    fileprivate func addTimer(){
        
        self.timer = Timer(timeInterval: delay, target: self, selector: #selector(HUD.dismiss), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    
    
}


fileprivate extension UIImage {
    
    class func bundleImage(named: String) -> UIImage? {
        
        return UIImage(named: "./HUD.bundle/" + named)
        
    }
    
    func render(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale);
        
        let ctx = UIGraphicsGetCurrentContext();
        
        draw(in: rect)
        
        ctx?.setFillColor(color.cgColor)
        ctx?.setAlpha(1)
        ctx?.setBlendMode(.sourceAtop)
        ctx?.fill(rect)
        
        let image = UIImage(cgImage: ctx!.makeImage()!, scale: scale, orientation: imageOrientation)
        
        UIGraphicsEndImageContext();
        
        return image;
        
    }
    
}




