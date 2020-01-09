//
//  AdminManagerOutput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 1/9/20.
//  Copyright © 2020 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol AdminManagerOutput: class {
  func didAddNewServiceType()
  func didGetErrors(_ message: String?)
  func didLoadedAllServiceStations(services: [String: [ServiceStation]])
  func didRemoveServiceStation()
}
