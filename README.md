# HUDKit

下载后直接将HUDKit文件夹拖进项目即可

轻量级hud提示框
使用方法
# 普通用法
        view.hud.show(info: "哈哈哈哈")
        view.hud.show(error: "保存失败")
        view.hud.show(success: "保存成功")
        view.hud.show(loading: "加载当中")
        view.hud.show(progress: progress, status: "正在上传")
 
# 自定义
        let hud = view.hud
        hud.delay = 5
        hud.successImage = UIImage(named: "back-chevron")
        hud.show(success: "保存成功")
  
         
# 设置全局默认样式
        HUD.defaultLoadingImages = [UIImage(named: "dyla_img_loading_1")!,  UIImage(named: "dyla_img_loading_2")!]
        HUD.defaultAnimationDuration = 1

