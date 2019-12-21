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
  private var range = 5
  
  public var isDriver: Bool = false
  
  private let gradientLayer = CAGradientLayer()
  
  @IBOutlet weak var dropDown: DropDown!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var rangeStackView: UIStackView!
  @IBOutlet weak var rangeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var dropDownTopMarginConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
    showActivityIndicator()
    let serviceTypesManager = ServiceTypesManager(delegate: self)
    serviceTypesManager.getAllServiceTypes()
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
    let serviceStationsManager = ServiceStationsManager(delegate: self)
    switch isDriver {
    case true:
      serviceStationsManager.getNearestEmptyServicesOfTypeWith(selectedType, startLat: currentLat, startLong: currentLong, range: range)
    case false:
      serviceStationsManager.getAllServicesOfType(selectedType)
    }
  }
  
  @IBAction func closeScreen(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didSelectRange(_ sender: Any) {
    switch rangeSegmentedControl.selectedSegmentIndex {
    case 0:
      range = 5
    case 1:
      range = 7
    case 2:
      range = 9
    case 3:
      range = 12
    default:
      break
    }
  }
}

// MARK: - Private
private extension ServicesViewController {
  func setupView() {
    var placeholder: String = "Select type"
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.titleLabel.text = isDriver ? "Nearest" : "Services"
      
    case .uk:
      self.titleLabel.text = isDriver ? "Найближчі" : "Сервіси"
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
    rangeStackView.isHidden = !isDriver
    dropDownTopMarginConstraint.constant = isDriver ? 8.0 : -25.0
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "ServiceTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellID)
  }
  
  func setupDropDown(placeholder: String) {
    dropDown.rowBackgroundColor = .white
    dropDown.textColor = .black
    dropDown.rowHeight = 40
    dropDown.borderColor = .white
    dropDown.placeholder = placeholder
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
  
  func updateDataSource(stations: [ServiceStation]) {
    hideActivityIndicator()
    self.services = stations
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

// MARK: - ServiceStationsManagerOutput
extension ServicesViewController: ServiceStationsManagerOutput {
  func didFinishLoadingAllServices(services: [ServiceStation]) {
    updateDataSource(stations: services)
  }
  
  func didFinishGettingNearestEmptyServices(services: [ServiceStation]) {
    updateDataSource(stations: services)
  }
  
  func didGetEmptyListOfStations() {
    hideActivityIndicator()
    showToast(message: "Nothing suitable has been found")
  }
  
  func didAddServiceStationToBase() { return }
  
  func didGetErrorsWhileAddingServiceStation(_ message: String?) { return }
}

// MARK: - ServiceTypesManagerOutput
extension ServicesViewController: ServiceTypesManagerOutput {
  func didFinishLoadingTypes(serviceTypes: [ServiceType]) {
    hideActivityIndicator()
    dropDown.selectedRowColor = .lightGray
    dropDown.optionArray = serviceTypes.map { $0.typeName }
    dropDown.optionIds = serviceTypes.map { $0.id }
    dropDown.didSelect { (selectedText, index, id) in
      self.selectedType = id
    }
  }
}


// MARK: - CLLocationManagerDelegate
extension ServicesViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    currentLat = Double(locValue.latitude)
    currentLong = Double(locValue.longitude)
  }
}
