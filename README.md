# iFans

## 项目中使用的第三方库
### 管理工具
* 第三方库管理工具：[CocoaPods](http://www.tuicool.com/articles/7VvuAr3)

### 网络相关

* 网络：[Alamofire](https://github.com/Alamofire/Alamofire)
* JSON解析：[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

### UI相关

* 自动布局：[SnapKit](https://github.com/SnapKit/SnapKit)

### 工具相关
* 下拉／上拉刷新：[MJRefresh](https://github.com/CoderMJLee/MJRefresh)
* 菊花加载：[MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* 图片异步加载：[Kingfisher](https://github.com/onevcat/Kingfisher)


### Hybrid相关

* JSBridge：[WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)

## 项目结构
![项目结构](/Users/pandong/GitHub/iFans/项目目录.png)


* 遵循 `M-V-C` 架构，分别对应 `Models` `Views` `Controllers` 三个文件夹
* `Stores` 为本地化存储（包括 `NSUserDefaults` `DataBase` 等）、网络（可视为远程存储）、缓存等操作所需文件
* `Helpers` 为工具类，多为全局操作
* `Configs` 中放一切全局常量相关（字体、颜色、尺寸、URL等，分文件放）
* `Libs` 放第三方库