//
//  ServiceStationsManager.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServiceStationsManager {
  private weak var delegate: ServiceStationsManagerOutput?
  
  init(delegate: ServiceStationsManagerOutput) {
    self.delegate = delegate
  }
  
  private func getAllServices(requestUrl url: String,
                              handler: Command<[ServiceStation]>) {
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var services: [ServiceStation] = []
      for object in jsonArray {
        services.append(ServiceStation(object: object))
      }
      handler.perform(with: services)
    }
  }
  
  private func getAmountOfEmptyPlacesAtServiceWith(_ id: String, handler: Command<Int>) {
    let url = "\(Const.Base.url)/service_stations/\(id)/sensors/empty"
    Alamofire.request(url).responseJSON { (sensors) in
      guard let sensorsValue = sensors.result.value else { return }
      let jsonSensorsObject = JSON(sensorsValue)
      let jsonSensorsArray = jsonSensorsObject.arrayValue
      handler.perform(with: jsonSensorsArray.count)
    }
  }
  
  func getAllServicesOfType(_ id: Int) {
    let url = "\(Const.Base.url)/service_types/\(id)/services"
    getAllServices(
      requestUrl: url,
      handler: .init(with: { (services) in
        self.delegate?.didFinishLoadingAllServices(services: services)
      }))
  }
  
  func getNearestEmptyServicesOfTypeWith(_ id: Int,
                                         startLat: Double,
                                         startLong: Double,
                                         range: Int) {
    let url = "\(Const.Base.url)/service_stations/nearest?lat=\(startLat)&long=\(startLong)&type=\(id)&range=\(range)"
    getAllServices(
      requestUrl: url,
      handler: .init(with: { (services) in
        guard services.count > 0 else {
          self.delegate?.didGetEmptyListOfStations()
          return
        }
        var serviceStations: [ServiceStation] = []
        for index in 0 ..< services.count {
          guard let serviceId = services[index].id else {
            continue
          }
          self.getAmountOfEmptyPlacesAtServiceWith(
            serviceId,
            handler: .init(with: { (amount) in
              if amount > 0 {
                serviceStations.append(services[index])
              }
              if index == services.count - 1 {
                self.delegate?.didFinishGettingNearestEmptyServices(services: serviceStations)
              }
            })
          )
        }
      }))
  }
  
  func addService(service: ServiceStation) {
    let url = "\(Const.Base.url)/service_stations"
    let parameters = service.convertToParameters()
    Alamofire.request(url, method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        if response.result.isSuccess {
          self.delegate?.didAddServiceStationToBase()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrorsWhileAddingServiceStation(jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
}
