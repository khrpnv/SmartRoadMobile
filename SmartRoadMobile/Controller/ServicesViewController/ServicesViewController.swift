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
  
  private let gradientLayer = CAGradientLayer()
  
  @IBOutlet weak var dropDown: DropDown!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var closeButton: UIButton!
  
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
  
  @IBAction func closeScreen(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - Private
private extension ServicesViewController {
  func setupView() {
    var placeholder: String = "Select type"
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = isDriver ? "Nearest" : "Services"
      
    case .uk:
      self.title = isDriver ? "Найближчі" : "Сервіси"
      placeholder = "Оберіть тип"
    default:
      break
    }
    setupDropDown(placeholder: placeholder)
    styleButton(button: submitButton,
                backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                textColor: .white)
    if let closeIcon = UIImage(named: Const.Image.close)?.withRenderingMode(.alwaysTemplate) {
      closeButton.tintColor = .white
      closeButton.setBackgroundImage(closeIcon, for: .normal)
    }
    self.tableView.backgroundColor = .clear
    view.layer.insertSublayer(gradientLayer, at: 0)
    let itemType: MenuItemType = isDriver ? .driver : .services
    if let color = MenuItems.getItems().first(where: { $0.type == itemType})?.background {
      setGradientColor(top: color.top, bottom: color.bottom)
    }
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "ServiceTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellID)
  }
  
  func setupDropDown(placeholder: String) {
    dropDown.rowBackgroundColor = .white
    dropDown.textColor = .white
    dropDown.rowHeight = 40
    dropDown.borderColor = .white
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
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
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
    if self.services.count == 0 {
      showToast(message: "Nothing suitable has been found")
    }
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
