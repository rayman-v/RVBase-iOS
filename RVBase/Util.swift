import UIKit

class Util: NSObject {
    
    static let bundleVersion = Util.bundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    static let screenWidth = Util.screen().bounds.width
    static let screenHeight = Util.screen().bounds.height
    
    static func attributes(size size: CGFloat = 16, color: UIColor = UIColor.blackColor(), underline: Bool = false) -> [String: AnyObject] {
        var attr = [String: AnyObject]()
        attr[NSFontAttributeName] = UIFont.systemFontOfSize(size)
        attr[NSForegroundColorAttributeName] = color
        if underline {
            attr[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
        }
        
        return attr
    }
    
    private static var alertWindow: UIWindow!
    
    static func alert(message message: String) {
        if alertWindow == nil {
            initAlert()
        }
        if !alertWindow.hidden {
            return
        }
        
        let alertLabel = alertWindow.viewWithTag(1) as! UILabel
        alertLabel.text = message
        let alertSize = alertLabel.sizeThatFits(CGSizeMake(Util.screenWidth * 0.7, CGFloat(FLT_MAX)))
        alertWindow.frame = CGRectMake((Util.screenWidth/2) - (alertSize.width/2) - 10, (Util.screenHeight/2) - (alertSize.height/2) - 10, alertSize.width+20, alertSize.height+20)
        alertLabel.frame = CGRectMake(10, 10, alertSize.width , alertSize.height)
        alertWindow.hidden = false
        alertWindow.alpha = 0
        
        alertWindow.makeKeyAndVisible()
        
        UIView.animateWithDuration(0.3) { () -> Void in
            alertWindow.alpha = 1
        }
        UIView.animateWithDuration(0.5, delay: 2, options: [], animations: { () -> Void in
            alertWindow.alpha = 0
        }) { (isComplt) -> Void in
            alertWindow.hidden = true
        }
        
    }
    
    private static func initAlert() {
        alertWindow = UIWindow()
        let alertLabel = UILabel()
        alertLabel.textAlignment = .Center
        alertLabel.font = UIFont.systemFontOfSize(14)
        alertLabel.textColor = UIColor(red: 252/255, green: 250/255, blue: 242/255, alpha: 1)
        alertLabel.backgroundColor = UIColor.clearColor()
        alertLabel.numberOfLines = 0
        alertLabel.tag = 1
        alertWindow.rootViewController = AlertCtr()
        alertWindow.windowLevel = 9999
        alertWindow.addSubview(alertLabel)
        alertWindow.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.9)
        alertWindow.layer.masksToBounds = true
        alertWindow.layer.cornerRadius = 5
    }

    
    static func notify() -> NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    static func screen() -> UIScreen {
        return UIScreen.mainScreen()
    }
    
    static func application() -> UIApplication {
        return UIApplication.sharedApplication()
    }
    
    static func appDelegate() -> AppDelegate {
        return self.application().delegate as! AppDelegate
    }
    
    static func userDefault() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    static func bundle() -> NSBundle {
        return NSBundle.mainBundle()
    }
    
    static func get(path: String, params: Dictionary<String, AnyObject>?, isCheckToken: Bool = true, encoding: ParameterEncoding = .URL) -> Observable<Util.Result> {
        if isCheckToken {
            
            if User.token.isEmpty {
                return Observable.just(Util.Result.Unlogin(message: "请先登录"))
            }else{
                return request_public(.GET, path: path, params: params, isCheckToken: isCheckToken, encoding: encoding)
            }
        }else{
            return request_public(.GET, path: path, params: params, isCheckToken: isCheckToken, encoding: encoding)
        }
    }
    
    static func post(path: String, params: Dictionary<String, AnyObject>?, isCheckToken: Bool = true, encoding: ParameterEncoding = .URL) -> Observable<Util.Result> {
        if isCheckToken {
            
            if User.token.isEmpty {
                return Observable.just(Util.Result.Unlogin(message: "请先登录"))
            }else{
                return request_public(.POST, path: path, params: params, isCheckToken: isCheckToken, encoding: encoding)
            }
        }else{
            return request_public(.POST, path: path, params: params, isCheckToken: isCheckToken, encoding: encoding)
        }
    }
    
    
    private static func request_public(method: Alamofire.Method, path: String, params: Dictionary<String, AnyObject>?, isCheckToken: Bool, encoding: ParameterEncoding = .URL) -> Observable<Util.Result>  {

        return Observable.create { (observer) -> Disposable in
            
            observer.onNext(Util.Result.Processing)
            let manager = Alamofire.Manager.sharedInstance
            manager.request(method, Util.appDelegate().domain + path, parameters: params, encoding: encoding, headers: ["Token": "\(User.token)", "X-Version": "seedmall-iOS/\(Util.bundleVersion)"]).responseJSON { (Resp) in
                
                if Util.appDelegate().isDebug {
                    print("========================")
                    print("response: \(Resp.response)")
                    print("request.head: \(Resp.request?.allHTTPHeaderFields)")
                    print("request.body: \(NSString(data: Resp.request?.HTTPBody ?? NSData(), encoding: NSUTF8StringEncoding))")
                    print("\(method.rawValue).url: \(Resp.request!.URLString)")
                    print("isCheckToken: \(isCheckToken).参数: \(params)")
                    print("data: \(NSString(data: Resp.data ?? NSData(), encoding: NSUTF8StringEncoding))")
                    print("result: \(Resp.result.value)")
                    print("========================")
                }
                
                if Resp.response != nil && Resp.result.isSuccess && Resp.result.value != nil {
                    let head = JSON(Resp.result.value!)["head"]
                    let body = JSON(Resp.result.value!)["body"]
                    if head["status"] == "error" && head["error_code"] == "1103" {
                        // 过期，清空
                        User.clear()
                        Util.notify().postNotificationName("changeStatus", object: nil)
                        observer.onNext(Util.Result.Failed(message: "登录超时，请重试"))

                    }else if head["status"] != "ok" {
                        let tip = head["error_msg"].string!
                        observer.onNext(Util.Result.Failed(message: tip))
                    }else{
                        observer.onNext(Util.Result.Success(json: body))
                    }
                }else{
                    observer.onNext(Util.Result.Failed(message: "网络错误，请稍后重试！"))
                }
                observer.onCompleted()
                
            }
            
            return NopDisposable.instance
        }
    }
    
    
    static func validatePhone(text: String) -> Bool {
        return evaluate(text, predication: "^1+\\d{10}")
    }
    
    static func validateCheckcode(text: String) -> Bool {
        return evaluate(text, predication: "^\\d{6}")
    }
    
    static func validateNickname(text: String) -> Bool {
        return text.characters.count > 1 && text.characters.count < 11
    }
    
    static func validatePassword(text: String) -> Bool {
        return text.characters.count > 5 && text.characters.count < 17
    }
    
    private static func evaluate(text: String, predication: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", predication)
        return predicate.evaluateWithObject(text)
    }
    
    enum Result {
        case Success(json: JSON)
        case Failed(message: String)
        case Processing
        case Unlogin(message: String)
    }
    
    enum fieldId: String {
        case Phone, Checkcode, Password, Repassword, Nickname, OldPassword
    }
}

