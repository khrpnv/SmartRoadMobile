//
//  ServiceTableViewCellDelegate.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/23/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol ServiceTableViewCellDelegate: class {
  func showEmptyPlacesForServiceStationWith(_ id: String)
  func showMapsAlertActionForStation(_ station: ServiceStation)
}
