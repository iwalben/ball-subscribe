//
//  BSTSquareModel.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/13.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import HandyJSON

class BSTSquareModel: HandyJSON {
    var imageName : String?
    var placeName : String?
    var address : String?
    var grade : String?
    var price : String?
    var introduce : String?
    var opentime : String?
    var phoneNum : String?
    var appointmenttime : String?
    var finished : Bool = false
    var cancle : Bool = false
    var collect : Bool = false
    required init() {}
}
