//
//  Globle.swift
//  RedButton
//
//  Created by Zignuts Technolab on 26/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}


//MARK:- VARIABLES DECLARATION

var viewShowLoad: UIView?
var viewShowTost: UIView?
var loadingGroup: STLoadingGroup?

let Story_Main = UIStoryboard.init(name:"Main", bundle: nil)

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let screenWidth = UIScreen.main.bounds.size.width

let screenHeight = UIScreen.main.bounds.size.height

let screenScale = screenWidth/320

let screenHeightScale = screenHeight/568

let screenWidthScale = screenWidth/320

let k_DeviceType = "IOS"
let k_DeviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""

var glbDeviceToken:String?

var glbLatitude = 0.0

var glbLongitude = 0.0

var glbUserID = ""

var glbCurrentAddress = (city:"",state:"", Address:"", Country:"")

var loginType:String = UserLoginType.none.rawValue

var isInternet = false
var isActiveRegister = false
let _userDefault : UserDefaults = UserDefaults.standard


let MAX_PHONE = 15
let MAX_PASSWORD = 25
let MAX_NICKNAME = 128
let MAX_PROFESSION = 50 //250
let MAX_QUALIFICATION = 50 //250

//Font
let FontQuicksand_Regular = "Quicksand-Regular"
let FontQuicksand_Light = "Quicksand-Light"
let FontQuicksand_BoldItalic = "Quicksand-BoldItalic"
let FontQuicksand_DashRegular = "QuicksandDash-Regular"
let FontQuicksand_LightItalic = "Quicksand-LightItalic"
let FontQuicksand_Bold = "Quicksand-Bold"
let FontQuicksand_Italic = "Quicksand-Italic"

//Dictinar Keys
var t_age = "age"
var t_url = "url"
var t_name = "name"
var t_died = "died"
var t_symbol = "symbol"
var t_colour = "colour"
var t_fatherName = "f_name"
var t_motherName = "m_name"
var t_birthPlace = "birth_place"
var t_description = "description"


//=========<<24 Tirthankar t_name>>============//
var First_Tirthankar = "Rishabhanatha (Adinath)"
var Second_Tirthankar = "Ajitanatha"
var Third_Tirthankar = "Sambhavanatha"
var Fourth_Tirthankar = "Abhinandananatha"
var Fifth_Tirthankar = "Sumatinatha"
var Sixth_Tirthankar = "Padmaprabha"
var Seventh_Tirthankar = "Suparshvanatha"
var Eighth_Tirthankar = "Chandraprabha"
var Nineth_Tirthankar = "Pushpadanta"
var Tenth_Tirthankar = "Shitalanatha"
var Eleventh_Tirthankar = "Shreyanasanatha"
var Twevlv_Tirthankar = "Vasupujya"
var Thirteen_Tirthankar = "Vimalanatha"
var Fourteen_Tirthankar = "Anantanatha"
var Fifteen_Tirthankar = "Dharmanatha"
var Sixteen_Tirthankar = "Shantinatha"
var Seventeen_Tirthankar = "Kunthunatha"
var Eighteen_Tirthankar = "Aranatha"
var Nineteen_Tirthankar = "Mallinatha"
var Twenty_Tirthankar = "Munisuvrata"
var TwentyOne_Tirthankar = "Naminatha"
var TwentyTwo_Tirthankar = "Neminatha"
var TwentyThree_Tirthankar = "Parshvanatha"
var TwentyFour_Tirthankar = "Mahavira"


//=========<<24 Tirthankar t_symbol>>============//
var First_Tirthankar_symbol = "Bull"
var Second_Tirthankar_symbol = "Elephant"
var Third_Tirthankar_symbol = "Horse"
var Fourth_Tirthankar_symbol = "Monkey"
var Fifth_Tirthankar_symbol = "Heron"
var Sixth_Tirthankar_symbol = "Padma"
var Seventh_Tirthankar_symbol = "Swastika"
var Eighth_Tirthankar_symbol = "Crescent Moon"
var Nineth_Tirthankar_symbol = "Crocodile"
var Tenth_Tirthankar_symbol = "Shrivatsa"
var Eleventh_Tirthankar_symbol = "Rhinoceros"
var Twevlv_Tirthankar_symbol = "Buffalo"
var Thirteen_Tirthankar_symbol = "Boar"
var Fourteen_Tirthankar_symbol = "Falcon"
var Fifteen_Tirthankar_symbol = "Vajra"
var Sixteen_Tirthankar_symbol = "Antelope or deer"
var Seventeen_Tirthankar_symbol = "Goat"
var Eighteen_Tirthankar_symbol = "Nandyavarta or fish"
var Nineteen_Tirthankar_symbol = "Kalasha"
var Twenty_Tirthankar_symbol = "Tortoise"
var TwentyOne_Tirthankar_symbol = "Blue lotus"
var TwentyTwo_Tirthankar_symbol = "Shankha"
var TwentyThree_Tirthankar_symbol = "Snake"
var TwentyFour_Tirthankar_symbol = "Lion"

//=========<<Tirthankar Birth Places>>============//
var birthPlaceAyodhya = "Ayodhya"
var birthPlaceShravasti = "Shravasti"
var birthPlaceSamet_sikhar = "Samet Sikhar"
var birthPlaceChandrapuri = "Chandrapuri"
var birthPlaceKakandi = "Khukhundoo, Deoria"
var birthPlaceBhadrikpuri = "Bhadrikpuri"
var birthPlaceChampapuri = "Champapuri"
var birthPlaceKampilya = "Kampilya"
var birthPlaceRatnapuri = "Ratnapuri"
var birthPlaceHastinapur = "Hastinapur"
var birthPlaceMithila = "Mithila"
var birthPlaceKusagranagar = "Rajgir"
var birthPlaceDvaraka = "Dwarika"
var birthPlaceKashi = "Kashi"
var birthPlaceKshatriyakund = "Kundagrama"
var birthPlaceKosambi = "Kosambi"
var birthPlaceVaranasi = "Varanasi"
var birthPlaceSarnath = "Sarnath"
var birthPlaceChampapur = "Champapur"

var firstTrithankar_desc = "Rishabhanatha (also Rishabhadeva, Ṛṣabhadeva or Ṛṣabha which literally means 'bull') is the 1st Tirthankara in Jainism. Jain legends depict him as having lived millions of years ago. He is also known as Ādinātha which translates into First (Adi) Lord (nātha), as well as Adishvara (first ishvara), Yugadideva (deva of yuga, lord of an era), Prathamaraja (first king), and Nabheya (son of Nabhi).\nAccording to Jain traditional accounts, he was born to king Nabhi and queen Marudevi in north Indian city of Ayodhya, also called Vinita. He had two wives, Sunanda and Sumangala. Sumangala is described as the mother of his ninety-nine sons (including Bharata) and one daughter, Brahmi. Sunanda is depicted as the mother of Bahubali and Sundari."

var secondTrithankar_desc = "Ajitnatha (lit. invincible) was the 2nd tirthankara of the present age, avasarpini (half time cycle) according to Jainism. \nAjitnatha was born in the town of Saketa to King Jitashatru and Queen Vijaya at Ayodhya in the Ikshvaku dynasty on magha-shukla-dashmi (the tenth day of the bright half of the month of Magha).he became a siddha, a liberated soul which has destroyed all of its karma."

var ThirdTrithankar_desc = "Sambhavanatha was the 3rd tirthankara (omniscient Jain teacher) of the present age (Avasarpini). He was born to King Jitārī and Queen Susena at Sravasti. in the Ikshvaku dynasty. Sambhavanatha at the end of his life destroyed all associated karmas and attained moksha (liberation)."

var fourthTrithankar_desc = "Abhinandananatha or Abhinandana Swami was the 4th Tirthankara of the present age (Avasarpini). He is said to have lived for 50 lakh purva. He was born to King Sanvara and Queen Siddhartha at Ayodhya in the Ikshvaku clan. His birth date was the second day of the Magh shukla month of the Indian calendar. According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its Karma. He attained Kevala Jnana under priyangu tree."

var fifthTrithankar_desc = "Sumatinatha was the 5th Jain Tirthankara of the present age (Avasarpini). Sumatinatha was born to Kshatriya King Megha (Meghaprabha) and Queen Mangala (Sumangala) at Ayodhya in the Ikshvaku dynasty. His birth date was the eighth day of the Vaisakha shukla month of the Hindu calendar."

var sixthTrithankar_desc = "Padmaprabha, also known as Padmaprabhu, was the 6th Jain Tirthankara of the present age (Avsarpini). According to Jain beliefs, he became a siddha - a liberated soul which has destroyed all of its karma. In the Jain tradition, it is believed that Padmaprabha was born to King Shridhar and Queen Susimadevi in the Ikshvaku dynasty at Kausambi which is in today's Uttar Pradesh, India"

var seventhTrithankar_desc = "Suparśvanātha was the 7th Jain Tīrthankara of the present age (avasarpini). He was born to King Pratistha and Queen Prithvi at Varanasi on 12 Jestha Shukla in the Ikshvaku clan. He is said to have attained moksha at Śikharji on the sixth day of the dark half of the month of Phālguna."

var eightthTrithankar_desc = "In Jainism, Chandraprabha was the 8th Tirthankara of Avasarpini (present half cycle of time as per Jain cosmology). Chandraprabhu was born to King Mahasena and Queen Lakshmana Devi at Chandrapuri to the Ikshvaku dynasty. According to Jain texts, his birth-date was the twelfth day of the Posh Krishna month of the Indian calendar. He is said to have become a siddha, i.e. soul at its purest form or a liberated soul."

var ninethTrithankar_desc = "In Jainism, Puṣpadanta was the 9th Tirthankara of the present age (Avasarpini). According to Jain belief, he became a siddha and an arihant, a liberated soul that has destroyed all of its karma. \nPuṣpadanta was born to King Sugriva and Queen Rama at Kakandi (modern Khukhundoo, Deoria, Uttar Pradesh) to the Ikshvaku dynasty. His birth date was the fifth day of the Margshrsha Krishna month of the Vikram Samvat. Puṣpadanta was the ninth Tirthankara who re-established the four-part sangha in the tradition started by Rishabhanatha."

var tenthTrithankar_desc = "Shitalanatha was the 10th tirthankara of the present age according to Jainism. According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma. Jains believe Shitalanatha was born to King Dradhrath and Queen Nanda at Bhaddilpur into the Ikshvaku dynasty. His birth date was the twelfth day of the Magha Krishna month of the Indian national calendar."

var eleventhTrithankar_desc = "Shreyansanath was the 11th Jain Tirthankara of the present age (Avasarpini). According to Jain beliefs, he became a Siddha - a liberated soul which has destroyed all of its karma. Shreyansanatha was born to King Vishnu and Queen Vishnu Devi at Simhapuri, near Sarnath in the Ikshvaku dynasty. His birth date was the twelfth day of the Falgun Krishna month of the Indian calendar."

var twelveTrithankar_desc = "Vasupujya Swami was the 12th Tirthankara in Jainism of the avasarpini (present age). According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma. Vasupujya was born to King Vasupujya and Queen Jaya Devi at Champapuri in the Ikshvaku dynasty. His birth date was the fourteenth day of the Falgun Krishna month of the Indian calendar. He never married and remained a celibate. He attained Kevala Jnana within one month of Tapsya and Moksha at Champapuri."

var thrteenTrithankar_desc = "Vimalanatha was the 13th Jain Tirthankara of the present age (Avasarpini). According to Jain beliefs, he became a Siddha, a liberated soul which has destroyed all of its karma. Vimalanatha was born to King Kratavarma and Queen Shyamadevi at Kampilya of the Ikshvaku dynasty. His birth date was the third day of the Magh Sukla month of the Indian calendar."

var fourteenTrithankar_desc = "Anantanatha was the 14th Tirthankara of the present age (Avasarpini) of Jainism. According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma. Anantanatha was born to King Sinhasena and Queen Suyasha at Ayodhya in the Ikshvaku dynasty. His birth date was the 13th day of the Vaishakha Krishna month of the Indian calendar."

var fifteenTrithankar_desc = "Dharmanatha was the 15th Jain Tirthankara of the present age (Avasarpini). According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma. Dharmanath was born to King Bhanu Raja and Queen Suvrata Rani at Ratnapuri in the Ikshvaku dynasty. His birth date was the third day of the Magh Sukla month of the Indian calendar.He attained Moksha at Shikharji."

var sixteenTrithankar_desc = "Shree Shantinatha was the 16th Jain Tirthankar of the present age (Avasarpini). Shree Shantinatha was born to King Visvasen and Queen Achira at Hastinapur in the Ikshvaku dynasty. His birth date is the thirteenth day of the Jyest Krishna month of the Indian calendar. He was also a Chakravarti and a Kamadeva. He ascended to throne when he was 25 years old. At the age of 50 years, he became a Jain monk and started his penance. According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma."

var seventeenTrithankar_desc = "Kunthunath was the 17th Tirthankara, sixth Chakravartin and twelfth Kamadeva of the present half time cycle, Avasarpini. According to Jain beliefs, he became a siddha, a liberated soul which has destroyed all of its karma. Kunthunatha was born to King Sura (Surya) and Queen Sridevi at Hastinapur in the Ikshvaku dynasty on the fourteenth day of the Vaishakh Krishna month of the Indian calendar."

var eighteenTrithankar_desc = "Aranath was the 18th Jain Tirthankar of the present half cycle of time (Avasarpini). He was also the seventh Chakravartin and thirteenth Kamadeva. According to Jain beliefs, he was born around 16,585,000 BCE. He became a siddha i.e. a liberated soul which has destroyed all of its karmas. Aranath was born to King Sudarshan and Queen Devi (Mitra) at Hastinapur in the Ikshvaku dynasty. His birth date was the tenth day of the Migsar Krishna month of the Indian calendar."

var nineteenTrithankar_desc = "19th tīrthaṅkara Mallinatha of the present avasarpiṇī age in Jainism. Jain texts indicate Mālliṇāha was born at Mithila into the Ikshvaku dynasty to King Kumbha and Queen Prajâvatî. Tīrthaṅkara Māllīnātha lived for over 56,000 years, out of which 54,800 years less six days, was with omniscience (Kevala Jnana)."

var twenteenTrithankar_desc = "Munisuvrata Swami (Munisuvratanātha) was the 20th Tirthankara of the present half time cycle (avasarpini) in Jain cosmology. He became a siddha, a liberated soul which has destroyed all of his karma. Events of the Jaina version of Ramayana are placed at the time of Munisuvratanatha. His chief apostle (gañadhara) was sage Malli Svāmi."

var twentyOneTrithankar_desc = "Naminatha was born on the 8th day of Shravan Krishna of the lunisolar Jain calendar. He attained Kevala Jnana under a Bakula tree. He had 17 Ganadhara, Suprabha being the leader. According to Jain tradition, he liberated his soul by destroying all of his karma and attained Moksha from Sammed Shikhar nearly 50,000 years before Neminatha."

var twentyTwoTrithankar_desc = "Neminatha is the 22th Tirthankara in Jainism. He is also known simply as Nemi, or as Aristanemi which is an epithet of the sun-chariot. Along with Mahavira, Parshvanatha and Rishabhanatha, Neminatha is one of the twenty four Tirthankaras who attract the most devotional worship among the Jains.\nAccording to Jain beliefs, Neminatha lived 84,000 years before the 23rd Tirthankara Parshvanatha."

var twentyThreeTrithankar_desc = "Parshvanatha (Pārśvanātha), also known as Parshva (Pārśva) and Paras, was the 23rd of 24 Tirthankaras of Jainism. He is the earliest Jain Tirthankara who is generally acknowledged as a historical figure. His biography is uncertain, with Jain sources placing him between the 9th and 8th century BC and historians stating he may have lived in 8th or 7th century BC. Along with Mahavira, Rishabhanatha and Neminatha, Parshvanatha is one of the four Tirthankaras who attracts the most devotional worship among the Jains."

var twentyFourTrithankar_desc = "Mahavira, also known as Vardhamāna, was the 24th Tirthankara of Jainism. In the Jain tradition, it is believed that Mahavira was born in the early part of the 6th century BC into a royal kshatriya family in what is now Bihar, India. At the age of 30 he abandoned all worldly possessions and left home in pursuit of spiritual awakening, eventually becoming an ascetic. For the next 12 years, Mahavira practiced intense meditation and severe austerities, after which he is believed to have attained Kevala Jnana (omniscience). He preached for 30 years and is believed by Jains to have died in the 6th century BC, though the year varies by the Jain sect. Scholars such as Karl Potter consider his biographical details as uncertain, with some suggesting he lived in the 5th century BC contemporaneously with the Buddha. Mahavira attained nirvana at the age of 72 and his remains were cremated."

//=========<<Tirthankar Color>>============//
var colorGolden = "Golden"
var colorRed = "Red"
var colorWhite = "White"
var colorBlue = "Blue"
var colorBlack = "Black"
//***************************************//

var No_Result = "No Records Found"
var search_No_Result = "No Result available for this search"
var filter_No_Result = "No Members available in "
var notification_No_Result = "No notification available"
var staff_No_Result = "No Result available for this work"
//********************************************************//

//********************************************************//
//********************************************************//
let dic1: NSDictionary = [t_name : First_Tirthankar,
                          t_fatherName : "Nabhi",
                          t_motherName : "Marudevi",
                          t_died: "Mount Asthapada",
                          t_symbol : First_Tirthankar_symbol,
                          t_birthPlace : birthPlaceAyodhya,
                          t_colour : colorGolden,
                          t_age : "84,00,000 Purva",
                          t_description: firstTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Rishabhanatha"]

let dic2: NSDictionary = [t_name : Second_Tirthankar,
                          t_fatherName : "Jitasatru",
                          t_motherName : "Vijayadevi",
                          t_died: "Shikharji",
                          t_symbol : Second_Tirthankar_symbol,
                          t_birthPlace : birthPlaceAyodhya,
                          t_colour : colorGolden,
                          t_age : "72,00,000 Purva",
                          t_description: secondTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Ajitanatha"]

let dic3: NSDictionary = [t_name : Third_Tirthankar,
                          t_fatherName : "Jitari",
                          t_motherName : "Susena",
                          t_died: "Shikharji",
                          t_symbol : Third_Tirthankar_symbol,
                          t_birthPlace : birthPlaceShravasti,
                          t_colour : colorGolden,
                          t_age : "60,00,000 Purva",
                          t_description: ThirdTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Sambhavanatha"]

let dic4: NSDictionary = [t_name : Fourth_Tirthankar,
                          t_fatherName : "Sanvara",
                          t_motherName : "Siddhartha",
                          t_died: "Shikharji",
                          t_symbol : Fourth_Tirthankar_symbol,
                          t_birthPlace : birthPlaceAyodhya,
                          t_colour : colorGolden,
                          t_age : "50,00,000 Purva",
                          t_description: fourthTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Abhinandananatha"]

let dic5: NSDictionary = [t_name : Fifth_Tirthankar,
                          t_fatherName : "Megharatha",
                          t_motherName : "Sumangala",
                          t_died: "Shikharji",
                          t_symbol : Fifth_Tirthankar_symbol,
                          t_birthPlace : birthPlaceAyodhya,
                          t_colour : colorGolden,
                          t_age : "40,00,000 Purva",
                          t_description: fifthTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Sumatinatha"]

let dic6: NSDictionary = [t_name : Sixth_Tirthankar,
                          t_fatherName : "Sridhara",
                          t_motherName : "Susima",
                          t_died: "Shikharji",
                          t_symbol : Sixth_Tirthankar_symbol,
                          t_birthPlace : birthPlaceKosambi,
                          t_colour : colorRed,
                          t_age : "30,00,000 Purva",
                          t_description: sixthTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Padmaprabha"]

let dic7: NSDictionary = [t_name : Seventh_Tirthankar,
                          t_fatherName : "Pratishtha",
                          t_motherName : "Prithivī",
                          t_died: "Shikharji",
                          t_symbol : Seventh_Tirthankar_symbol,
                          t_birthPlace : birthPlaceVaranasi,
                          t_colour : colorGolden,
                          t_age : "20,00,000 Purva",
                          t_description: seventhTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Suparshvanatha"]

let dic8: NSDictionary = [t_name : Eighth_Tirthankar,
                          t_fatherName : "Mahasena",
                          t_motherName : "Sulakshana devi",
                          t_died: "Shikharji",
                          t_symbol : Eighth_Tirthankar_symbol,
                          t_birthPlace : birthPlaceChandrapuri,
                          t_colour : colorWhite,
                          t_age : "10,00,000 Purva",
                          t_description: eightthTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Chandraprabha"]

let dic9: NSDictionary = [t_name : Nineth_Tirthankar,
                          t_fatherName : "Sugriva",
                          t_motherName : "Rama",
                          t_died: "Shikharji",
                          t_symbol : Nineth_Tirthankar_symbol,
                          t_birthPlace : birthPlaceKakandi,
                          t_colour : colorWhite,
                          t_age : "2,00,000 Purva",
                          t_description: ninethTrithankar_desc,
                          t_url: "https://en.wikipedia.org/wiki/Pushpadanta"]

let dic10: NSDictionary = [t_name : Tenth_Tirthankar,
                           t_fatherName : "Dridharatha",
                           t_motherName : "Sunanda",
                           t_died: "Shikharji",
                           t_symbol : Tenth_Tirthankar_symbol,
                           t_birthPlace : birthPlaceAyodhya,
                           t_colour : colorGolden,
                           t_age : "1,00,000 Purva",
                           t_description: tenthTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Shitalanatha"]

let dic11: NSDictionary = [t_name : Eleventh_Tirthankar,
                           t_fatherName : "Vishnu",
                           t_motherName : "Vishnudri",
                           t_died: "Shikharji",
                           t_symbol : Eleventh_Tirthankar_symbol,
                           t_birthPlace : birthPlaceSarnath,
                           t_colour : colorGolden,
                           t_age : "84,00,000 Years",
                           t_description: eleventhTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Shreyansanatha"]

let dic12: NSDictionary = [t_name : Twevlv_Tirthankar,
                           t_fatherName : "Vasupujya",
                           t_motherName : "Jaya",
                           t_died: birthPlaceChampapur,
                           t_symbol : Twevlv_Tirthankar_symbol,
                           t_birthPlace : birthPlaceChampapur,
                           t_colour : colorRed,
                           t_age : "72,00,000 Years",
                           t_description: twelveTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Vasupujya"]

let dic13: NSDictionary = [t_name : Thirteen_Tirthankar,
                           t_fatherName : "Kritvarman",
                           t_motherName : "Suramya",
                           t_died: "Shikharji",
                           t_symbol : Thirteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceKampilya,
                           t_colour : colorGolden,
                           t_age : "60,00,000 Years",
                           t_description: thrteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Vimalanatha"]

let dic14: NSDictionary = [t_name : Fourteen_Tirthankar,
                           t_fatherName : "Simhasena",
                           t_motherName : "Suyasha",
                           t_died: "Shikharji",
                           t_symbol : Fourteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceAyodhya,
                           t_colour : colorGolden,
                           t_age : "30,00,000 Years",
                           t_description: fourteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Anantanatha"]

let dic15: NSDictionary = [t_name : Fifteen_Tirthankar,
                           t_fatherName : "Bhanu",
                           t_motherName : "Suvrata",
                           t_died: "Shikharji",
                           t_symbol : Fifteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceRatnapuri,
                           t_colour : colorGolden,
                           t_age : "10,00,000 Years",
                           t_description: fifteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Dharmanatha"]

let dic16: NSDictionary = [t_name : Sixteen_Tirthankar,
                           t_fatherName : "Visvasena",
                           t_motherName : "Achira",
                           t_died: "Shikharji",
                           t_symbol : Sixteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceHastinapur,
                           t_colour : colorGolden,
                           t_age : "1,00,000 Years",
                           t_description: sixteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Shantinatha"]

let dic17: NSDictionary = [t_name : Seventeen_Tirthankar,
                           t_fatherName : "Surya (Sura)",
                           t_motherName : "Sri devi",
                           t_died: "Shikharji",
                           t_symbol : Seventeen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceHastinapur,
                           t_colour : colorGolden,
                           t_age : "95,000 Years",
                           t_description: seventeenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Kunthunatha"]

let dic18: NSDictionary = [t_name : Eighteen_Tirthankar,
                           t_fatherName : "Sudarsana",
                           t_motherName : "Devi (Mitra)",
                           t_died: "Shikharji",
                           t_symbol : Eighteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceHastinapur,
                           t_colour : colorGolden,
                           t_age : "84,000 Years",
                           t_description: eighteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Aranatha"]

let dic19: NSDictionary = [t_name : Nineteen_Tirthankar,
                           t_fatherName : "Kumbha",
                           t_motherName : "Rakshita",
                           t_died: "Shikharji",
                           t_symbol : Nineteen_Tirthankar_symbol,
                           t_birthPlace : birthPlaceAyodhya,
                           t_colour : colorBlue,
                           t_age : "55,000 Years",
                           t_description: nineteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/M%C4%81ll%C4%ABn%C4%81tha"]

let dic20: NSDictionary = [t_name : Twenty_Tirthankar,
                           t_fatherName : "Sumitra",
                           t_motherName : "Padmavati",
                           t_died: "Shikharji",
                           t_symbol : Twenty_Tirthankar_symbol,
                           t_birthPlace : birthPlaceKusagranagar,
                           t_colour : colorBlack,
                           t_age : "30,000 Years",
                           t_description: twenteenTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Munisuvrata"]

let dic21: NSDictionary = [t_name : TwentyOne_Tirthankar,
                           t_fatherName : "Vijaya",
                           t_motherName : "Vapra",
                           t_died: "Shikharji",
                           t_symbol : TwentyOne_Tirthankar_symbol,
                           t_birthPlace : birthPlaceMithila,
                           t_colour : colorGolden,
                           t_age : "10,000 Years",
                           t_description: twentyOneTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Naminatha"]

let dic22: NSDictionary = [t_name : TwentyTwo_Tirthankar,
                           t_fatherName : "Samudravijaya",
                           t_motherName : "Shivadevi",
                           t_died: "Mount Girnar",
                           t_symbol : TwentyTwo_Tirthankar_symbol,
                           t_birthPlace : birthPlaceDvaraka,
                           t_colour : colorBlack,
                           t_age : "1,000 Years",
                           t_description: twentyTwoTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Neminatha"]

let dic23: NSDictionary = [t_name : TwentyThree_Tirthankar,
                           t_fatherName : "Ashvasena",
                           t_motherName : "Vamadevi",
                           t_died: "Shikharji",
                           t_symbol : TwentyThree_Tirthankar_symbol,
                           t_birthPlace : birthPlaceVaranasi,
                           t_colour : colorBlue,
                           t_age : "100 Years",
                           t_description: twentyThreeTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Parshvanatha"]

let dic24: NSDictionary = [t_name : TwentyFour_Tirthankar,
                           t_fatherName : "Siddhartha",
                           t_motherName : "Trishala",
                           t_died: "Pawapuri",
                           t_symbol : TwentyFour_Tirthankar_symbol,
                           t_birthPlace : birthPlaceKshatriyakund,
                           t_colour : colorGolden,
                           t_age : "72 Years",
                           t_description: twentyFourTrithankar_desc,
                           t_url: "https://en.wikipedia.org/wiki/Mahavira"]
//*******************************************************//
//******************************************************//


//Profile Param
var k_name = "Name*"
var k_mobile = "Mobile*"
var k_email = "Email"
var k_dob = "Date of birth*"
var k_qualification = "Qualification"
var k_profession = "Proffesion"
var k_family_members = "Members in family"
var k_blood_group = "Blood group"
var k_gender = "Gender*"
var k_submit = "Submit"


//Register Param
var key_name = "fullName"
var key_mobile = "mobile"
var key_email = "email"
var key_dob = "dob"
var key_qualification = "qualification"
var key_profession = "profession"
var key_blood_group = "blood_group"
var key_gender = "gender"

//Alert Message
var m_enterName = "Please enter your name"
var m_enterMobile = "Please enter your mobile number"
var m_enterdob = "Please enter your date of birth"
var m_enterValidEmail = "Please enter your valid email"




func greenColor()->UIColor{
    return UIColor(red:0/255.0, green:166/255.0, blue:81/255.0, alpha: 1.0)
}


func shadow_greenColor()->UIColor {
    return UIColor(red:0/255.0, green:166/255.0, blue:81/255.0, alpha: 1.0)
}

func shadow_orangeColor()->UIColor {
    return UIColor(red: 247/255.0, green: 148/255.0, blue:29/255.0, alpha: 1.0)
}

func border_groupColor()->UIColor {
    return UIColor(red: 235/255.0, green: 235/255.0, blue:241/255.0, alpha: 1.0)
}





//MARK:- METHODS
public func makeCall(number:String)
{
    let url = URL.init(string:"tel://\(number)" )
    if UIApplication.shared.canOpenURL(url!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }else{
        appDelegate.window?.rootViewController?.view.makeToast("This device unable to make call!")
    }
}

public func isValidString(_ strvalue:String?) -> Bool {
    return strvalue != nil && strvalue != ""
}



//MARK:- USERDEFAULT

func AppSetArchiveObjectToUserDefault(_ params:Any, Key: String ) {
    let data = NSKeyedArchiver.archivedData(withRootObject: params)
    UserDefaults.appSetObject(data, forKey: Key)
}

func AppGetArchievedObjectFromUserDefault(Key:String) -> Any {
    if let data = UserDefaults.appObjectForKey(Key) as? Data {
        if let storedData = NSKeyedUnarchiver.unarchiveObject(with: data){
            return storedData
        }
    }
    return NSNull()
}

func resetUserLogin() {
    loginType = UserLoginType.none.rawValue

    UserDefaults.appRemoveObjectForKey(eUserDefaultsKey.keyLoginUserID.rawValue)
    UserDefaults.appRemoveObjectForKey(eUserDefaultsKey.keyLoginID.rawValue)
    UserDefaults.appRemoveObjectForKey(eUserDefaultsKey.keyUserPayCardDetail.rawValue)
    UserDefaults.appSetObject(false, forKey: eUserDefaultsKey.keyisSuprelikePresented.rawValue)
    UserDefaults.appSetObject(false, forKey: eUserDefaultsKey.keyisRewindPresented.rawValue)

    glbUserID = ""
}

func kUserdefaultsRemoveAllData() {
    
    let defs = UserDefaults.standard
    let dict = defs.dictionaryRepresentation() as NSDictionary
    for key in dict.allKeys
    {
        if (key as! String != "accss_token") && (key as! String != "access_token_expire_time") && (key as! String != "fcmtoken") {
            defs.removeObject(forKey: key as! String)
        }
    }
    defs.synchronize()
    
}








//MARK: Array to JSON String
func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}



//MARK:- UIALERT VIEW
func showSingleAlert(Title:String, Message:String, buttonTitle:String, delegate:UIViewController? = appDelegate.window?.rootViewController, completion:@escaping ()->Void) {
    if let parentVC = delegate{
        let alertConfirm = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let actOk = UIAlertAction(title: buttonTitle, style: .default) { (finish) in
            completion()
        }
        alertConfirm.addAction(actOk)
        parentVC.present(alertConfirm, animated: true, completion: nil)
    }
}
//MARK:- DATE FORMATE
func convertGetFormatedDate(fromDate:String, ToFormate:String) -> String{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: "UTC")
//    formater.dateFormat = eUserDefaultsKey.keyServerdateformate.rawValue
    
    if let serverDate = formater.date(from: fromDate){
        formater.dateFormat = ToFormate
        formater.timeZone = TimeZone.current
        return formater.string(from: serverDate)
    }
    return fromDate
}


//MARK:- PROGRESS HUD
public func StartLoader() {
    let styles: [STLoadingStyle] = [.submit, .glasses, .walk, .arch, .bouncyPreloader, .zhihu, .triangle, .pacMan]

    let side: CGFloat = 50
    let style = styles[2]

    loadingGroup = STLoadingGroup(side: side, style: style)
    loadingGroup?.show(appDelegate.window?.rootViewController?.view)
    loadingGroup?.startLoading()
    
}

public func StopLoader() {
    loadingGroup?.stopLoading()
}








//MARK:- FORMATED JSON

func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    
    if JSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }catch {
            
            print("error")
            //Access error here
        }
        
    }
    return ""
}

//MARK:- ANIMATIONS

func animate_buttonBounce(sender:UIView, completions:((Bool) -> Swift.Void)? = nil) {
    sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: CGFloat(0.30),
                   initialSpringVelocity: CGFloat(5.0),
                   options: UIView.AnimationOptions.allowUserInteraction,
                   animations: {
                    sender.transform = CGAffineTransform.identity
    },
                   completion: { Void in()
                    if let callBack = completions{
                        callBack(true)
                    }
                    
    })
}

//MARK:- CHECK AUTHORIZATION CAMERA AND PHOTO

func checkCameraAutorization(completion: @escaping ((Bool) -> Void)) ->  Void{
    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
        //already authorized
        completion(true)
    } else {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                //access allowed
                completion(true)
            } else {
                //access denied
                completion(false)
                openSettingsPopup(title: "Permission", Message: "In order to capture image we need permission to access your camera. Please go to settings and give camera permission.")
            }
        })
    }
}

func checkPhotoLibraryPermission(completion: @escaping ((Bool) -> Void)) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
         completion(true)
        break
    case .denied, .restricted :
         completion(false)
         openSettingsPopup(title: "Permission", Message: "In order to pick image from photos we need permission to access your photos. Please go to settings and give photos permission.")
        break
    case .notDetermined:
        // ask for permissions
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
            case .authorized:
                completion(true)
                break
            case .denied, .restricted:
                completion(false)
                openSettingsPopup(title: "Permission", Message: "In order to pick image from photos we need permission to access your photos. Please go to settings and give photos permission.")
                break
            case .notDetermined:
                break
            }
        }
        break
    }
}

func openSettingsPopup(title:String,Message:String) {
    
    let alertPermission = UIAlertController(title: title, message: Message, preferredStyle: .alert)
    let actDismis = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    alertPermission.addAction(actDismis)
    alertPermission.addAction(settingsAction)
    
    appDelegate.window?.rootViewController?.present(alertPermission, animated: true, completion: nil)
}

//MARK:- SIMPLE PRINT METHODS

func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        debugPrint("------------------------------")
        debugPrint("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        debugPrint("Font Names = [\(names)]")
    }
}



func currentDateTimeString() -> String {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let strDate = dateFormat.string(from: NSDate() as Date)
    return strDate
}

func currentDateTimeStringAPIFormat() -> String {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let strDate = dateFormat.string(from: Date())
    return strDate
}


func currentDateString() -> String {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "dd-MM-yyyy"
    let strDate = dateFormat.string(from: NSDate() as Date)
    return strDate
}

func NextDateString() -> String {
    
    let dateFormat = DateFormatter()
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
    dateFormat.dateFormat = "dd-MM-yyyy"
    let strDate = dateFormat.string(from: tomorrow!)
    return strDate
}


func NumericToString(_ numbber: Int) -> String {
    var strNumber = ""
    if numbber == 1 {
        strNumber = "1st"
    }else if numbber == 2 {
        strNumber = "2nd"
    }else if numbber == 3 {
        strNumber = "3rd"
    }else if numbber == 4 {
        strNumber = "4th"
    }else if numbber == 5 {
        strNumber = "5th"
    }else if numbber == 6 {
        strNumber = "6th"
    }else if numbber == 7 {
        strNumber = "7th"
    }else if numbber == 8 {
        strNumber = "8th"
    }else if numbber == 9 {
        strNumber = "9th"
    }else if numbber == 10 {
        strNumber = "10th"
    }else if numbber == 11 {
        strNumber = "11th"
    }else if numbber == 12 {
        strNumber = "12th"
    }else if numbber == 13 {
        strNumber = "13th"
    }else if numbber == 14 {
        strNumber = "14th"
    }else if numbber == 15 {
        strNumber = "15th"
    }else if numbber == 16 {
        strNumber = "16th"
    }else if numbber == 17 {
        strNumber = "17th"
    }else if numbber == 18 {
        strNumber = "18th"
    }else if numbber == 19 {
        strNumber = "19th"
    }else if numbber == 20 {
        strNumber = "20th"
    }else if numbber == 21 {
        strNumber = "21st"
    }else if numbber == 22 {
        strNumber = "22nd"
    }else if numbber == 23 {
        strNumber = "23rd"
    }else if numbber == 24 {
        strNumber = "24th"
    }
    
    return strNumber
}




