//
//  Double+round.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/23/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

extension Double {
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
