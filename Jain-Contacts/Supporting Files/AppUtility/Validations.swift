//
//  Validations.swift
//  AbayaBazar
//
//  Created by iMac-4 on 7/14/17.
//  Copyright © 2017 iMac-4. All rights reserved.
//

import Foundation

open class Validator
{
    fileprivate static let defaultValidator: Validator = Validator()
    open let dateFormatter = DateFormatter()
    
    
    
    fileprivate static let
//    ΕmailRegex: String = "[\\w._%+-|]+@{1}[\\w0-9.-]+\\.[A-Za-z]{2,6}",
//    ΕmailRegex: String = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
//        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
//        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
//        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
//        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
//        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
//    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
    
    firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?",
    serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}",
    ΕmailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,6}",

    ΑlphaRegex: String = "[a-zA-Z]+",
    NumericRegex: String = "[-+]?[0-9]+",
    FloatRegex: String = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?",
    AlphanumericRegex: String = "[\\d[A-Za-z]]+",
    AlphanumericPlusApostropheRegex: String = "^[a-zA-Z0-9' ]*$", //OK "[a-zA-Z0-9|('|\\s)]+",
    AlphanumericPlusUnderscore: String = "[a-zA-Z0-9|_]+",
//    PasswordRegex: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{3,15}$",
    PasswordRegex: String = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,25}",
    ZipCodeRegex: String = "^\\d{5}(?:[-\\s]\\d{4})?",
    WebURLRegex: String = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    
    
    /**
     checks if it is an empty string
     
     - returns: (String?)->Bool
     */
    open static var isValidString: (String?) -> Bool {
        return Validator.defaultValidator.isValidString
    }
    open static var isValidStringObj: (Any?) -> Bool {
        return Validator.defaultValidator.isValidStringObj
    }
    
    open static var isValidEmail: (String?) -> Bool {
        return Validator.defaultValidator.isValidEmail
    }
    
    open static var isValidMobile: (String?) -> Bool {
        return Validator.defaultValidator.isValidMobile
    }
    
    open var isValidString: (String?) -> Bool {
        return {
            (value: String?) in
            return value == "" || value == nil
        }
    }
    
    open var isValidStringObj: (Any?) -> Bool {
        
        return { (value: Any?) in
            
            if let strValue = (value as? String) {
                return strValue == "" ? false:true
            }
            return value == nil ? false:true
        }
    }
    
    /**
     checks if it is an email
     
     - returns: (String?)->Bool
     */
    

    
    
    open var isValidEmail: (String?) -> Bool {
        return {
            (value: String?) -> Bool in
            
            if value == "" || value == nil {
                return false
            }
            
            return self.regexValidate(Validator.ΕmailRegex, value!)
        }
    }
    
    open var  isValidMobile: (String?) -> Bool {
        return {
            (mobile: String?) -> Bool in
            let PHONE_REGEX = "^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: mobile)
            return result
        }
    }
    
    /**
     checks if the value exists in the supplied array
     
     - parameter array: An array of strings
     - returns: (String?)->Bool
     */
    open static func isIn(_ array: Array<String>) -> (String?) -> Bool {
        return Validator.defaultValidator.isIn(array)
    }
    open func isIn(_ array: Array<String>) -> (String?) -> Bool {
        return {
            (value: String?) -> Bool in
            if value == "" || value == nil {
                return false
            }
            
            if let _ = array.index(of: value!) {
                return true
            } else {
                return false
            }
        }
    }
    
    
    /**
     checks if it is numeric
     
     - returns: (String?)->Bool
     */
    open static var isNumeric: (String?) -> Bool {
        return Validator.defaultValidator.isNumeric
    }
    open var isNumeric: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.NumericRegex, value!)
        }
    }
    
    
    /**
     checks if it is Alphabetics
     
     - returns: (String?)->Bool
     */
    open static var isAlphabetic: (String?) -> Bool {
        return Validator.defaultValidator.isAlphabetic
    }
    open var isAlphabetic: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.ΑlphaRegex, value!)
        }
    }
    
    
    /**
     checks if it has valid Password String
     
     - returns: (String?)->Bool
     */
    open static var isPasswordString: (String?) -> Bool {
        return Validator.defaultValidator.isPasswordString
    }
    open var isPasswordString: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.PasswordRegex, value!)
        }
    }
    
    
    /**
     checks if it is ZipCode
     
     - returns: (String?)->Bool
     */
    open static var isZipCode: (String?) -> Bool {
        return Validator.defaultValidator.isZipCode
    }
    open var isZipCode: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.ZipCodeRegex, value!)
        }
    }
    
    
    /**
     checks if it is WebSite URL String
     
     - returns: (String?)->Bool
     */
    open static var isWebSiteURL: (String?) -> Bool {
        return Validator.defaultValidator.isWebSiteURL
    }
    open var isWebSiteURL: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.WebURLRegex, value!)
        }
    }
    
    
    //MARK:- MAIN()
    fileprivate func regexValidate(_ regex: String, _ value: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
    }
    
    
    
}
