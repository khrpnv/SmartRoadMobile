//
//  ServiceStationsManagerOutput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol ServiceStationsManagerOutput: class {
  func didFinishLoadingAllServices(services: [ServiceStation])
  func didFinishGettingNearestEmptyServices(services: [ServiceStation])
  func didGetEmptyListOfStations()
  func didAddServiceStationToBase()
  func didGetErrorsWhileAddingServiceStation(_ message: String?)
  func didGetAmountOfEmptyPlacesForStation(amount: Int)
}
