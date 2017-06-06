//
//  HUDContent.swift
//  Example
//
//  Created by zhangweiwei on 2017/4/12.
//  Copyright © 2017年 erica. All rights reserved.
//

import UIKit

enum HUDContentType : Int {
    
    case info
    case success
    case error
    case loading
    case progress
    case notification
    
}

class HUDContentView: UIView {
    
    /*内容边距*/
     var contentInset: UIEdgeInsets = HUD.defaultContentInset
    /*水平间距*/
     var horizontalMargin: CGFloat = HUD.defaultHorizontalMargin
    /*垂直间距*/
     var verticalMargin: CGFloat = HUD.defaultVerticalMargin
    /*进度环size大小*/
     var progressSize = HUD.defaultProgressSize
    /*内容布局方向*/
     var layoutDirection = HUD.defaultLayoutDirection
    
    /*成功的图片*/
    open var successImage = HUD.defaultSuccessImage
    /*失败的图片*/
    open var errorImage =  HUD.defaultErrorImage
    /*提示的图片*/
    open var infoImage =  HUD.defaultInfoImage
    /*loading的图片,旋转动画*/
    open var loadingImage =  HUD.defaultLoadingImage
    /* loadingImages 比 loadingImage 优先级更高,优先使用自定义gif动画 */
    open var loadingImages =  HUD.defaultLoadingImages
    /*动画时长*/
     var animationDuration = HUD.defaultAnimationDuration
    /*hud背景颜色,当style==.custom时生效*/
     var styleColor = HUD.defaultStyleColor
    /*hud文字颜色,当style==.custom时生效*/
     var textColor = HUD.defaultTextColor
    /*style content背景alpha值*/
     var styleAlpha = HUD.defaultStyleAlpha
    
    /*是否需要展示具体进度值*/
     var isShowProgressLabel = HUD.isDefaultShowProgressLabel {
        didSet {
            progressView.progressLabel.isHidden = !isShowProgressLabel
        }
    }
    
    var style: HUDStyle = HUD.defaultStyle {
        didSet {
            
            switch style {
            case .dark:
                
                backgroundColor = UIColor(white: 0, alpha: styleAlpha)
                
                textLabel.textColor = UIColor.white
                
            case .light:
                backgroundColor = UIColor(white: 1, alpha: styleAlpha)
                
                textLabel.textColor = UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1)
                
                
            case .custom:
                backgroundColor = styleColor?.withAlphaComponent(styleAlpha)
                
                textLabel.textColor = textColor
                
                
            }
            
            detailTextLabel.textColor = textLabel.textColor
            progressView.progressLayer.strokeColor = textLabel.textColor.cgColor
            progressView.progressLabel.textColor = textLabel.textColor
            
        }
    }

    
     lazy var progressView: HUDContentProgressView = {
        let progressView = HUDContentProgressView()
        return progressView
    }()
    
        
     lazy var textLabel: UILabel = {
        
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
     lazy var detailTextLabel: UILabel = {
        
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
     lazy var imageView: UIImageView = {
        
        let iv = UIImageView()
        return iv
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(detailTextLabel)
        addSubview(progressView)
        
        setupNotification()
        
    }
    
    func show(type: HUDContentType, msg: String? = nil, progress: Double? = nil, detailMsg: String? = nil, image: UIImage? = nil) {
        
        reset()
        
        self.type = type
        
        textLabel.text = msg
        
        
        setNeedsLayout()
        
        if let progress = progress {
            progressView.progress = progress
        }
        
        if let image = image {
            imageView.image = image
        }
        
        if let detailMsg = detailMsg {
            detailTextLabel.text = detailMsg
        }
        
        showAnimation()
        
        
    }
    
    var type: HUDContentType = .success{
        didSet{
            
            switch type {
            case .info:
                
                imageView.isHidden = false
                progressView.isHidden = true
                imageView.image = infoImage
                
                
            case .success:
                
                imageView.isHidden = false
                progressView.isHidden = true
                imageView.image = successImage
                
            case .error:
                
                imageView.isHidden = false
                progressView.isHidden = true
                imageView.image = errorImage
                
            case .loading:
                
                imageView.isHidden = false
                progressView.isHidden = true
                
                if let loadingImages = loadingImages {
                    
                    imageView.animationImages = loadingImages
                    imageView.animationDuration = animationDuration
                    imageView.startAnimating()
                    
                }else {
                    
                    imageView.image = loadingImage
                    
                    let anim = CABasicAnimation(keyPath: "transform.rotation.z")
                    anim.toValue = Double.pi * 2.0
                    anim.duration = animationDuration
                    anim.repeatCount = MAXFLOAT
                    anim.isRemovedOnCompletion = false
                    imageView.layer.add(anim, forKey: "rotation")
                }
                
                
            case .progress:
                
                imageView.isHidden = true
                progressView.isHidden = false
                
            case .notification:
                
                imageView.isHidden = false
                textLabel.isHidden = false
                detailTextLabel.isHidden = false
                progressView.isHidden = true
                
                
                
                
            }
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard let superView = superview else {
            return
        }
        
        switch type {
        case .notification:
            
            imageView.frame.size = progressSize
            imageView.frame.origin.x = horizontalMargin
            imageView.frame.origin.y = verticalMargin
            
            textLabel.sizeToFit()
            textLabel.frame.size.height = imageView.frame.height
            textLabel.frame.origin.x = imageView.frame.maxX + horizontalMargin
            textLabel.frame.origin.y = imageView.frame.origin.y
            
            detailTextLabel.frame.origin.y = imageView.frame.maxY + verticalMargin
            detailTextLabel.frame.origin.x = imageView.frame.origin.x
            
            
            frame.origin.x = 15
            frame.origin.y = 20
            frame.size.width = superView.bounds.width - 2 * frame.origin.x
            
            detailTextLabel.frame.size.width = frame.size.width - 2 * horizontalMargin
            
            
            if let detail = detailTextLabel.text as NSString? {
                
                detailTextLabel.frame.size.height = detail.boundingRect(with: CGSize(width: detailTextLabel.frame.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : detailTextLabel.font], context: nil).size.height
            }
            
            frame.size.height = detailTextLabel.frame.maxY + verticalMargin
            
            
            
            
        default:
            
            imageView.sizeToFit()
            
            if imageView.frame.size == .zero {
                
                imageView.frame.size = progressSize
            }
            
            if layoutDirection == .horizontal {
                
                let contentH = max(textLabel.frame.height, imageView.frame.size.height) + contentInset.top + contentInset.bottom
                
                
                textLabel.frame.size = textLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width * 0.75 - imageView.frame.size.width - horizontalMargin, height: 0))
                
                var contentW = contentInset.left + contentInset.right
                
                var startX = contentInset.left
                if imageView.frame.size != CGSize.zero {
                    contentW += imageView.frame.size.width
                    
                    imageView.frame.origin.x = startX
                    progressView.frame.origin.x = startX
                    
                    startX = imageView.frame.maxX + horizontalMargin
                    
                }
                
                if textLabel.frame.size != CGSize.zero {
                    contentW += textLabel.frame.size.width + horizontalMargin
                    textLabel.frame.origin.x = startX
                }
                
                frame.size = CGSize(width: contentW, height: contentH)
                
                textLabel.center.y = frame.height * 0.5
                imageView.center.y = textLabel.center.y
                
            }else {
                
                textLabel.frame.size = textLabel.sizeThatFits(CGSize(width: bounds.width * 0.75, height: 0))
                
                var contentH = contentInset.top + contentInset.bottom
                
                var startY = contentInset.top
                if imageView.frame.size != CGSize.zero {
                    contentH += imageView.frame.size.height
                    
                    imageView.frame.origin.y = startY
                    
                    startY = imageView.frame.maxY + verticalMargin
                    
                }
                
                if textLabel.frame.size != CGSize.zero {
                    contentH += textLabel.frame.size.height + verticalMargin
                    textLabel.frame.origin.y = startY
                }
                
                let contentW = max(textLabel.frame.width, imageView.frame.size.width) + contentInset.left + contentInset.right
                
                frame.size = CGSize(width: contentW, height: contentH)
                
                textLabel.center.x = frame.width * 0.5
                imageView.center.x = textLabel.center.x
            }
            
            progressView.frame = imageView.frame
            
            
            center = CGPoint(x: superView.bounds.width  * 0.5, y: superView.bounds.height * 0.5)
            
            guard let keyboardFrame = visableKeyboardFrame else {
                return
            }
            
            let duration: Double = 0.25
            
            let margin: CGFloat = verticalMargin
            
            let delta = center.y + frame.height * 0.5 - keyboardFrame.origin.y + margin
            
            if delta > 0 {
                
                UIView.animate(withDuration: duration, animations: {
                    
                    self.transform = CGAffineTransform(translationX: 0, y: -delta)
                })
                
                
            }else {
                
                UIView.animate(withDuration: duration, animations: {
                    
                    self.transform = CGAffineTransform.identity
                })
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAnimation() {
          
        UIView.animate(withDuration: 0.25) {
            
            self.alpha = 1
            
        }
        
    }
    
    
    func reset() {
        
        imageView.stopAnimating()
        imageView.animationImages = nil
        imageView.layer.removeAnimation(forKey: "rotation")
        imageView.isHidden = true
        progressView.isHidden = true
        detailTextLabel.isHidden = true
        progressView.progress = 0
        
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HUDContentView.keyboardWillChangeFrameNotification), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Avoid Window
extension HUDContentView{
    
    var visableKeyboardFrame: CGRect? {
        
        var tmp: UIWindow? = nil
        
        for window in UIApplication.shared.windows {
            
            if !window.isMember(of: UIWindow.self) {
                
                tmp = window
                break
            }
            
        }
        
        guard let keyboardWindow = tmp  else {
            return nil
        }
        
        for possibleKeyboard in keyboardWindow.subviews {
            
            if possibleKeyboard.isKind(of: NSClassFromString("UIPeripheralHostView")!) || possibleKeyboard.isKind(of: NSClassFromString("UIKeyboard")!){
                
                return possibleKeyboard.frame
            }else if possibleKeyboard.isKind(of: NSClassFromString("UIInputSetContainerView")!) {
                
                for possibleKeyboardSubview in possibleKeyboard.subviews {
                    
                    if possibleKeyboardSubview.isKind(of: NSClassFromString("UIInputSetHostView")!) {
                        return possibleKeyboardSubview.frame
                    }
                    
                }
                
            }
            
        }
        
        return nil
        
    }
    
    func keyboardWillChangeFrameNotification() {
        
        setNeedsLayout()
    }
}
