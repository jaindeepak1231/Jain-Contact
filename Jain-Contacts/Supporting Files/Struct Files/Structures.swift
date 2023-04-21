//
//  Structures.swift
//  xkeeper
//
//  Created by Zignuts Technolab on 07/08/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit


//MARK: Head Struct
struct HeadData: Decodable {
    
    var result: [HeadListData]?
}

struct HeadListData: Decodable {
    
    var id: String?
    var area_name: String?
    var family_name: String?
    var address: String?
    var area_id: String?
    var fullName: String?
    var email: String?
    var mobile: String?
    var gender: String?
    var qualification: String?
    var profession: String?
    var dob: String?
    var image: String?
    var family_members: String?
    
}
//*******//


//MARK: Area Struct
struct AreaData: Decodable {
    
    var result: [AreaListData]?
}

struct AreaListData: Decodable {
    
    var id: String?
    var area_name: String?
    var city_name: String?
}
//*******//



//MARK:- HomeView Struct

struct HomeData: Decodable {
    
    var result: [HomeListData]?
}

struct HomeListData: Decodable {
    
    var name: String?
    var f_name: String?
    var m_name: String?
    var symbol: String?
    var colour: String?
    var age: String?
    var url: String?
    var died: String?
    var birth_place: String?
    var description: String?
}

//*******//
//Dictinar Keys


