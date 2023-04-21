//
//  GeneralMethods.swift
//  AbayaBazar
//
//  Created by iMac-4 on 7/14/17.
//  Copyright © 2017 iMac-4. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import Material

//MARK:- Extension_UIFont


@IBDesignable
class DesignableView: UIView {
}

extension UIFont {
    
    public class func AppFontRegular(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "System-Regular", size: fontSize)!
    }
    
    public class func AppFontMedium(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "System-Medium", size: fontSize)!
    }
    
    public class func AppFontBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "System-Bold", size: fontSize)!
    }
}

//MARK:- For PullTo Refresh TableView
extension UITableView {
    
    func pullTorefresh(_ target: Selector, tintcolor: UIColor,_ toView: UIViewController?)
    {
        let refrshControll = UIRefreshControl()
        refrshControll.tintColor = tintcolor
        refrshControll.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        refrshControll.addTarget(toView!, action: target, for: UIControl.Event.valueChanged)
        self.refreshControl = refrshControll
    }
    
    func closeEndPullRefresh()
    {
        self.refreshControl?.endRefreshing()
    }
}

extension UIButton {
    
    func setGradientBackground(colors:[UIColor], direction: GradientDirection){
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, direction: direction)
        self.setBackgroundImage(gradientLayer.creatGradientImage(), for: UIControl.State.normal)
    }
    
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], direction: GradientDirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
      //  locations = [0.0, 0.55]
//        startPoint = CGPoint(x: 1.0, y: 0.5)
//        endPoint = CGPoint(x: 0.0, y: 0.5)
        
        switch direction {
        case .Right:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        case .Left:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
        case .TopLeftToBottomRight:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .TopRightToBottomLeft:
            startPoint = CGPoint(x: 1.0, y: 0.0)
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .BottomLeftToTopRight:
            startPoint = CGPoint(x: 0.0, y: 1.0)
            endPoint = CGPoint(x: 1.0, y: 0.0)
        default:
            startPoint = CGPoint(x: 1.0, y: 1.0)
            endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}


//MARK:- Extension_UIColor
extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    public class func AppColor(Red:Float, Green:Float, Blue:Float, Alpha:Float) -> UIColor {
        return UIColor.init(red: CGFloat(Red/255.0), green: CGFloat(Green/255.0), blue: CGFloat(Blue/255.0), alpha: CGFloat(Alpha))
    }
    
    public class func AppThemeRed() -> UIColor {
        return UIColor.init(red: 254/255, green: 46/255, blue: 46/255, alpha: 1)
    }
    
    public class func AppThemeBlue() -> UIColor {
        return UIColor.init(red: CGFloat(46/255.0), green: CGFloat(150/255.0), blue: CGFloat(254/255.0), alpha: CGFloat(1))
    }
}

//MARK:- UserDefaults
extension UserDefaults {
    
    //MARK:- UserDefault Save / Retrive Data
    static func appSetObject(_ object:Any, forKey:String){
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appObjectForKey(_ strKey:String) -> Any?{
        let strValue = UserDefaults.standard.value(forKey: strKey)
        return strValue
    }
    
    static func appRemoveObjectForKey(_ strKey:String){
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    
}





extension String {
    
    func getUserDistanceValue(distanceUnit: String) -> String{

        let strDistance = self == "" ? "20" : self
        
        if distanceUnit.lowercased() == "KM".lowercased() || self == ""{
            return String.init(format: "%.0f", CGFloat((strDistance as NSString).floatValue))
        }
        else if distanceUnit.lowercased() == "MI".lowercased(){
            let distMile = (strDistance as NSString).floatValue
            let tempst = String.init(format: "%.1f", (distMile * 0.621371))
            let tempVar = String(format: "%g", Double(tempst)!)
            return tempVar//String.init(format: "%.1f", CGFloat(distMile * 0.621371))
        }
        else if distanceUnit == "mi-km"{
            let distMile = (strDistance as NSString).floatValue
            let tempst = String.init(format: "%.1f", (distMile * 1.60934))
            let tempVar = String(format: "%g", Double(tempst)!)
            return tempVar//String.init(format: "%.1f", CGFloat(distMile * 0.621371))
        }
        return "N/A"
    }
    
    
    func isValidMobile() -> Bool {
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidString(value:String?) -> Bool {
         return value == "" || value == nil
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let PHONE_REGEX = "[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result2 = emailTest.evaluate(with: self)
        
        if result == false
        {
            return result2
        }
        return result
        
    }
    
    
    func sizeForText(font:UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size
    }
    
    func checkAcceptableValidation(AcceptedCharacters:String) -> Bool {
        let cs = NSCharacterSet(charactersIn: AcceptedCharacters).inverted
        let filtered = self.components(separatedBy: cs).joined(separator: "")
        if self != filtered{
            return false
        }
        return true
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    
    func byaddingLineHeight(linespacing:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = linespacing  // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
  /*  func smEncrypt() -> String {
        let cryptoLib = CryptLib()
        let encryptedString = cryptoLib.encryptPlainText(with: self, key: Crypto_KEY, iv: Crypto_IV)
        if encryptedString != "" &&  encryptedString != nil {
            return encryptedString!
        }
        return encryptedString ?? self
    }
    
    func smDecrypt() -> String {
        let cryptoLib = CryptLib()
        let decryptedString = cryptoLib.decryptCipherText(with: self, key: Crypto_KEY, iv: Crypto_IV)
        if decryptedString != "" &&  decryptedString != nil {
            return decryptedString!
        }
        return self
    }*/
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

//MARK:- Textfield Devider setup




extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    
    func ToolbarPikerteast(mySelect : Selector, delegate:UIViewController) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: delegate, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}



//MARK:- Label FOnt scaling

extension UITextField {
    
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                
                if screenWidthScale > CGFloat(1){
                    //let ratio: CGFloat = self.frame.size.height/self.frame.size.width
                    
                    self.font = UIFont.init(name: (self.font?.fontName)!, size: ((self.font?.pointSize)! * screenWidthScale))
                    
                    
                    //                        self.adjustsFontSizeToFitWidth = true
                    //                        self.adjustsFontForContentSizeCategory = true
                }
            }
        }
    }
    
}

//MARK:- Label FOnt scaling

extension UILabel {
    
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                
                    if screenWidthScale > CGFloat(1){
                        //let ratio: CGFloat = self.frame.size.height/self.frame.size.width
                        
                        self.font = UIFont.init(name: self.font.fontName, size: (self.font.pointSize * screenWidthScale))
                        
//                        self.adjustsFontSizeToFitWidth = true
//                        self.adjustsFontForContentSizeCategory = true
                    }
            }
        }
    }
    
}

//MARK:- Label FOnt scaling

extension UIButton {
    
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                
                    if screenWidthScale > CGFloat(1){
                       // let ratio: CGFloat = self.frame.size.height/self.frame.size.width
                        
                        self.titleLabel?.font = UIFont.init(name: (self.titleLabel?.font.fontName)!, size: ((self.titleLabel?.font.pointSize)! * screenWidthScale))
                    
                    }
            }
        }
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
//    @IBInspectable var DynamicRound:Bool {
//        get{
//            return false
//        }
//        set{
//            if newValue == true {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                    self.layer.cornerRadius = self.frame.bounds.height / 2
//                    self.layer.masksToBounds = true;
//                })
//            }
//        }
//        
//    }
    
    @IBInspectable var RoundWithShadow: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    
                   // func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.bounds.height/2
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor
                  //  }
                    
//                    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height/2).cgPath
//                    self.layer.shouldRasterize = true
//                    self.layer.rasterizationScale = UIScreen.main.scale
                })
            }
        }
    }
    
    @IBInspectable var cornerradiusWithShadow: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    
                    // func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.cornerRadius
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor
                    //  }
                    
                    //                    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height/2).cgPath
                    //                    self.layer.shouldRasterize = true
                    //                    self.layer.rasterizationScale = UIScreen.main.scale
                })
            }
        }
    }
}

extension UITextField {
    
    func addDoneToolbar()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        doneToolbar.tintColor = #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1)
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}

extension UITextView {
    func addDoneToolbar()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        let gradientLayer = CAGradientLayer(frame: self.frame, colors: [#colorLiteral(red: 0.9725490196, green: 0.09019607843, blue: 0.4039215686, alpha: 1),#colorLiteral(red: 0.9411764706, green: 0.2666666667, blue: 0.2666666667, alpha: 1)], direction: .Right)
        
        let image = gradientLayer.creatGradientImage()
        if let finalImage = image {
            doneToolbar.tintColor = UIColor.init(patternImage:finalImage)
        }else{
            doneToolbar.tintColor = #colorLiteral(red: 0.9725490196, green: 0.09019607843, blue: 0.4039215686, alpha: 1)
        }
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}
extension UINavigationController {
    func addCrossDesolveAnimation(time:CFTimeInterval) {
        let transition = CATransition()
        transition.duration = time
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
    }
    
    
}

public extension UIView {
    public class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: self, options: nil)!.first as! UIView
    }
}

extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a!
            a = b!
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}






extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}



extension UIImage {
    /**
     Creates a new image with the passed in color.
     - Parameter color: The UIColor to create the image from.
     - Returns: A UIImage that is the color passed in.
     */
    open func tint(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        color.setFill()
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }
}


extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
                textField.backgroundColor = UIColor.clear
            }
        }
    }
    
    
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
    
    func setMagnifyingGlassColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
    func ClearButtonWhiteColor() {
        // Clear Button Customization
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        //clearButton.setImage(UIImage.init(named: "close_textfield")?.tint(with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)), for: .normal)
    }
    
    func RemoveClearButton() {
        // Clear Button Customization
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.isHidden = true
        //clearButton.setImage(UIImage.init(named: "close_textfield")?.tint(with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)), for: .normal)
    }
}



//MARK:- Textfield Devider setup

extension TextField {
    
    func setDevider() {
        
        self.dividerActiveColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.placeholderActiveColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.placeholderVerticalOffset = 12
        self.fontScaling = true
        self.placeholderNormalColor = #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        
        if self.fontScaling == true {
            self.placeholderActiveScale = ((self.font?.pointSize)! * 0.33)
        }
    }
    
}
