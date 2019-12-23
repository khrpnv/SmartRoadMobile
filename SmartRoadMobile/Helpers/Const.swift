//
//  Const.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

struct Const {
  struct Base {
    static let url = "https://smart-road.herokuapp.com/api"
  }
  
  struct Image {
    static let languageIcon = "languageIcon"
    static let logo = "logo"
    static let logout = "logout"
    static let english = "en"
    static let ukraine = "ukraine"
    static let open = "openButton"
    static let add = "addButton"
    static let title = "title"
    static let close = "close"
    static let info = "info"
  }
  
  struct Color {
    static let languageTint = UIColor(red: 103.0/255.0, green: 197.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    static let lightGray = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    static let textFieldFocusColor = UIColor(red: 76.0/255.0, green: 161.0/255.0, blue: 214.0/255.0, alpha: 1.0)
  }
}
