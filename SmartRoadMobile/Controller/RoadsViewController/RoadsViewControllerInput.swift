//
//  RoadsViewControllerInput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol RoadsViewControllerInput: class {
  func didLoadedRoads(roads: [Road])
}
