//
//  ServicesViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import iOSDropDown
import Toast_Swift
import CoreLocation

class ServicesViewController: UIViewController {
  private var networkManager: Networking?
  private var services: [ServiceStation] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private let cellID = "CellID"
  private var selectedType: Int = -1
  private let locationManager = CLLocationManager()
  private var currentLat: Double = 32.23432
  private var currentLong: Double = 54.43435
  
  public var isDriver: Bool = false
  
  @IBOutlet weak var dropDown: DropDown!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
    networkManager = Networking()
    networkManager?.setServicesDelegate(servicesViewControllerInput: self)
    networkManager?.getServices()
    if isDriver {
      setupLocationManager()
    }
  }
  
  @IBAction func submitPressed(_ sender: Any) {
    guard selectedType > 0  else {
      showToast(message: "Choose service type");
      return
    }
    showActivityIndicator()
    switch isDriver {
    case true:
      networkManager?.getNearestServices(id: selectedType, startLat: currentLat, startLong: currentLong, range: 7)
    case false:
      networkManager?.getServiceById(id: selectedType)
    }
  }
}

// MARK: - Private
private extension ServicesViewController {
  func setupView() {
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = isDriver ? "Nearest" : "Services"
    case .uk:
      self.title = isDriver ? "Найближчі" : "Сервіси"
    default:
      break
    }
    styleButton(button: submitButton,
                backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                textColor: .white)
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "ServiceTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellID)
  }
  
  func showActivityIndicator() {
    self.view.makeToastActivity(.center)
  }
  
  func hideActivityIndicator() {
    self.view.hideToastActivity()
  }
  
  func showToast(message: String) {
    self.view.makeToast(message, duration: 3.0, position: .bottom)
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 25
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = backgroundColor
  }
  
  func setupLocationManager() {
    self.locationManager.requestAlwaysAuthorization()
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
  }
  
  func getCoords() {
    
  }
}

// MARK: - UITableViewDelegate
extension ServicesViewController: UITableViewDelegate {
  
}

// MARK: - UITableViewDataSource
extension ServicesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return services.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ServiceTableViewCell else {
      fatalError("No such cell")
    }
    cell.configureWith(serviceStation: services[indexPath.row])
    return cell
  }
}

// MARK: - ServicesViewControllerInput
extension ServicesViewController: ServicesViewControllerInput {
  func didFinishGettingTypes(types: [ServiceType]) {
    dropDown.selectedRowColor = .lightGray
    dropDown.optionArray = types.map { $0.typeName }
    dropDown.optionIds = types.map { $0.id }
    dropDown.didSelect { (selectedText, index, id) in
      self.selectedType = id
    }
  }
  
  func didFinishGettingStations(stations: [ServiceStation]) {
    hideActivityIndicator()
    self.services = stations
  }
}

// MARK: -
extension ServicesViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    currentLat = Double(locValue.latitude)
    currentLong = Double(locValue.longitude)
  }
}
