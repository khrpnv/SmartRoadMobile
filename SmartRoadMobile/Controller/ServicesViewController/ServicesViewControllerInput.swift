//
//  ServicesViewControllerInput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol ServicesViewControllerInput: class {
  func didFinishGettingTypes(types: [ServiceType])
  func didFinishGettingStations(stations: [ServiceStation])
}
