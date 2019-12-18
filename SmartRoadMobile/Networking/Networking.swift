//
//  Networking.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
  
  private weak var loginViewControllerInput: LoginViewControllerInput?
  private weak var roadsViewControllerInput: RoadsViewControllerInput?
  private weak var addServiceViewControllerInput: AddServiceViewControllerInput?
  private weak var servicesViewControllerInput: ServicesViewControllerInput?
  
  // MARK: - Setters
  func setLoginDelegate(loginViewControllerInput: LoginViewControllerInput) {
    self.loginViewControllerInput = loginViewControllerInput
  }
  
  func setRoadsDelegate(roadsViewControllerInput: RoadsViewControllerInput) {
    self.roadsViewControllerInput = roadsViewControllerInput
  }
  
  func setAddServiceDelegate(addServiceViewControllerInput: AddServiceViewControllerInput) {
    self.addServiceViewControllerInput = addServiceViewControllerInput
  }
  
  func setServicesDelegate(servicesViewControllerInput: ServicesViewControllerInput) {
    self.servicesViewControllerInput = servicesViewControllerInput
  }
  
  // MARK: - Service Types
  func getServices() {
    let url = "\(Const.Base.url)/service_types"
    Alamofire.request(url).responseJSON { [weak self] (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var serviceTypes: [ServiceType] = []
      for object in jsonArray {
        serviceTypes.append(ServiceType(object: object))
      }
      self?.addServiceViewControllerInput?.didFinishLoadingTypes(types: serviceTypes)
      self?.servicesViewControllerInput?.didFinishGettingTypes(types: serviceTypes)
    }
  }
  
  func getServiceById(id: Int) {
    let url = "\(Const.Base.url)/service_types/\(id)/services"
    Alamofire.request(url).responseJSON { [weak self] (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var services: [ServiceStation] = []
      for object in jsonArray {
        services.append(ServiceStation(object: object))
      }
      self?.servicesViewControllerInput?.didFinishGettingStations(stations: services)
    }
  }
  
  func getNearestServices(id: Int, startLat: Double, startLong: Double, range: Int) {
    let url = "\(Const.Base.url)/service_stations/nearest?lat=\(startLat)&long=\(startLong)&type=\(id)&range=\(range)"
    Alamofire.request(url).responseJSON { [weak self] (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var services: [ServiceStation] = []
      for index in 0..<jsonArray.count {
        let service = ServiceStation(object: jsonArray[index])
        guard let id = service.id else { return }
        let emptyUrl = "\(Const.Base.url)/service_stations/\(id)/sensors/empty"
        Alamofire.request(emptyUrl).responseJSON { (sensors) in
          guard let sensorsValue = sensors.result.value else { return }
          let jsonSensorsObject = JSON(sensorsValue)
          let jsonSensorsArray = jsonSensorsObject.arrayValue
          if jsonSensorsArray.count > 0 {
            services.append(service)
          }
          if index == jsonArray.count - 1 {
            self?.servicesViewControllerInput?.didFinishGettingStations(stations: services)
          }
        }
      }
    }
  }
  
  // MARK: - Service Stations
  func addService(service: ServiceStation) {
    let url = "\(Const.Base.url)/service_stations"
    let parameters = service.convertToParameters()
    Alamofire.request(url, method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { [weak self] response in
        if response.result.isSuccess {
          self?.addServiceViewControllerInput?.didAddedSuccessfully()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self?.addServiceViewControllerInput?.didGetErrors(message: jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
  
  // MARK: - User
  func authorization(user: User, type: String) {
    let url = "\(Const.Base.url)/users/\(type)"
    let parameters = user.convertToParameters()
    Alamofire.request(url, method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { [weak self] response in
        if response.result.isSuccess {
          self?.loginViewControllerInput?.didFinishSuccessfully()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self?.loginViewControllerInput?.didGetErrors(jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
  
  // MARK: - Roads
  func getRoads() {
    let url = "\(Const.Base.url)/roads"
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var roads: [Road] = []
      for object in jsonArray {
        var road = Road(object: object)
        let roadStateUrl = "\(Const.Base.url)/roads/\(road.id)/state"
        Alamofire.request(roadStateUrl).responseString { [weak self] (stateResponse) in
          let result = stateResponse.result
          switch result {
          case .success(let state):
            road.state = state
            roads.append(road)
            if jsonArray.count == roads.count {
              self?.roadsViewControllerInput?.didLoadedRoads(roads: roads)
            }
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
}
