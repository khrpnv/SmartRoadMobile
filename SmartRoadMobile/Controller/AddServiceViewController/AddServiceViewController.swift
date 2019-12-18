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
  
  private var networkManager: Networking?
  private var serviceTypes: [ServiceType] = []
  private var selectedIndex: Int = -1
  
  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var descriptionTextField: UITextField!
  @IBOutlet private weak var latTextField: UITextField!
  @IBOutlet private weak var longTextField: UITextField!
  @IBOutlet private weak var dropDown: DropDown!
  @IBOutlet weak var submitButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    networkManager = Networking()
    networkManager?.setAddServiceDelegate(addServiceViewControllerInput: self)
    networkManager?.getServices()
    self.textFiledsDelegates()
    
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
    networkManager?.addService(service: serviceStation)
  }
  
  
}

// MARK: - Private
private extension AddServiceViewController {
  func setupView() {
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = "Add service"
    case .uk:
      self.title = "Додати сервіс"
    default:
      break
    }
    styleButton(button: submitButton,
                backgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                textColor: .white)
  }
  
  func textFiledsDelegates() {
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
}

// MARK: -
extension AddServiceViewController: AddServiceViewControllerInput {
  func didFinishLoadingTypes(types: [ServiceType]) {
    dropDown.optionArray = types.map { $0.typeName }
    dropDown.optionIds = types.map { $0.id }
    dropDown.didSelect { (selectedText, index, id) in
      self.selectedIndex = id
    }
  }
  
  func didAddedSuccessfully() {
    hideActivityIndicator()
    showToast(message: "Servcie was added successfully")
    cleanInputs()
  }
  
  func didGetErrors(message: String?) {
    hideActivityIndicator()
    if let message = message {
      showToast(message: message)
      cleanInputs()
    }
  }
}

// MARK: -
extension AddServiceViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}
