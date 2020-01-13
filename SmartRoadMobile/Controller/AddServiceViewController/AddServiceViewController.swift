//
//  AddServiceViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import iOSDropDown
import Toast_Swift

class AddServiceViewController: UIViewController {
  private var serviceTypesManager: ServiceTypesManager?
  private var serviceStationsManager: ServiceStationsManager?
  private var serviceTypes: [ServiceType] = []
  private var selectedIndex: Int = -1
  private let gradientLayer = CAGradientLayer()
  
  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var descriptionTextField: UITextField!
  @IBOutlet private weak var latTextField: UITextField!
  @IBOutlet private weak var longTextField: UITextField!
  @IBOutlet private weak var dropDown: DropDown!
  @IBOutlet private weak var submitButton: UIButton!
  @IBOutlet private weak var closeButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupInputFieldsDelegates()
    showActivityIndicator()
    serviceTypesManager = ServiceTypesManager(delegate: self)
    serviceTypesManager?.getAllServiceTypes()
  }
  
  @IBAction func submitButtonPressed(_ sender: Any) {
    guard
      let name = nameTextField.text,
      name.count > 0,
      let description = descriptionTextField.text,
      description.count > 0,
      let lat = latTextField.text,
      lat.count > 0,
      let lon = longTextField.text,
      lon.count > 0,
      selectedIndex > 0,
      let latitude = Double(lat),
      let longitude = Double(lon)
    else {
      showToast(message: "Input fields are empty")
      return
    }
    let serviceStation = ServiceStation(
      name: name,
      description: description,
      latitude: latitude,
      longtitude: longitude,
      type: selectedIndex)
    showActivityIndicator()
    serviceStationsManager?.addService(service: serviceStation)
  }
  
  @IBAction func closeScreen(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - Private
private extension AddServiceViewController {
  func setupView() {
    var placeholder: String = "Select type"
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = "Add service"
    case .uk:
      self.title = "Додати сервіс"
      placeholder = "Оберіть тип"
    default:
      break
    }
    styleButton(button: submitButton,
                backgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                textColor: .white)
    setupDropDown(placeholder: placeholder)
    view.layer.insertSublayer(gradientLayer, at: 0)
    if let closeIcon = UIImage(named: Const.Image.close)?.withRenderingMode(.alwaysTemplate) {
      closeButton.tintColor = .white
      closeButton.setBackgroundImage(closeIcon, for: .normal)
    }
    if let color = MenuItems.getItems().first(where: { $0.type == .addService})?.background {
      setGradientColor(top: color.top, bottom: color.bottom)
    }
  }
  
  func setupInputFieldsDelegates() {
    nameTextField.delegate = self
    descriptionTextField.delegate = self
    latTextField.delegate = self
    longTextField.delegate = self
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 25
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = backgroundColor
  }
  
  func showToast(message: String) {
    self.view.makeToast(message, duration: 3.0, position: .bottom)
  }
  
  func showActivityIndicator() {
    self.view.makeToastActivity(.center)
  }
  
  func hideActivityIndicator() {
    self.view.hideToastActivity()
  }
  
  func cleanInputs() {
    nameTextField.text = ""
    descriptionTextField.text = ""
    latTextField.text = ""
    longTextField.text = ""
    selectedIndex = -1
  }
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
  }
  
  func setupDropDown(placeholder: String) {
    dropDown.rowBackgroundColor = .white
    dropDown.textColor = .white
    dropDown.rowHeight = 40
    dropDown.placeholder = placeholder
  }
}

// MARK: - ServiceStationsManagerOutput
extension AddServiceViewController: ServiceStationsManagerOutput {
  func didGetAmountOfEmptyPlacesForStation(amount: Int) { return }
  
  func didFinishLoadingAllServices(services: [ServiceStation]) { return }
  
  func didFinishGettingNearestEmptyServices(services: [ServiceStation]) { return }
  
  func didGetEmptyListOfStations() { return }
  
  func didAddServiceStationToBase() {
    hideActivityIndicator()
    showToast(message: "Service was added successfully")
    cleanInputs()
  }
  
  func didGetErrorsWhileAddingServiceStation(_ message: String?) {
    hideActivityIndicator()
    if let message = message {
      showToast(message: message)
      cleanInputs()
    }
  }
}

// MARK: - ServiceTypesManagerOutput
extension AddServiceViewController: ServiceTypesManagerOutput {
  func didFinishLoadingTypes(serviceTypes: [ServiceType]) {
    hideActivityIndicator()
    dropDown.optionArray = serviceTypes.map { $0.typeName }
    dropDown.optionIds = serviceTypes.map { $0.id }
    dropDown.didSelect { (selectedText, index, id) in
      self.selectedIndex = id
    }
  }
}

// MARK: - UITextFieldDelegate
extension AddServiceViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}
