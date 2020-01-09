//
//  AdminViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 1/9/20.
//  Copyright © 2020 Illia Khrypunov. All rights reserved.
//

import UIKit
import Toast_Swift
import LanguageManager_iOS

class AdminViewController: UIViewController {
  // MARK: - Properties
  private let gradientLayer = CAGradientLayer()
  private let topGradientColor = UIColor(red: 69.0/255.0,
                                         green: 69.0/255.0,
                                         blue: 69.0/255.0,
                                         alpha: 1.0)
  private let bottomGradientColor = UIColor(red: 30.0/255.0,
                                            green: 30.0/255.0,
                                            blue: 30.0/255.0,
                                            alpha: 1.0)
  private var networkingManager: AdminManager?
  private let cellId: String = "serviceCell"
  private var services: [String : [ServiceStation]] = [:] {
    didSet {
      types = Array(services.keys).sorted()
      tableView.reloadData()
    }
  }
  private var types: [String] = []
  
  // MARK: - Outlets
  @IBOutlet var segmentViews: [UIView]!
  @IBOutlet private weak var closeButton: UIButton!
  @IBOutlet weak var serviceTypeTextField: UITextField!
  @IBOutlet weak var serviceTypeSubmitButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupManager()
    setupView()
    setupTableView()
  }
  
  // MARK: - Actions
  @IBAction func closeButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func submitServiceTypePressed(_ sender: Any) {
    guard
      let typeName = serviceTypeTextField.text,
      typeName.count > 0
      else {
        return
    }
    let type = ServiceType(typeName: typeName)
    showActivityIndicator()
    networkingManager?.addServiceType(serviceType: type)
  }
}

// MARK: - Private
private extension AdminViewController {
  func setupManager() {
    networkingManager = AdminManager(delegate: self)
    showActivityIndicator()
    networkingManager?.getAllStations()
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func setupView() {
    if let closeIcon = UIImage(named: Const.Image.close)?.withRenderingMode(.alwaysTemplate) {
      closeButton.tintColor = .white
      closeButton.setBackgroundImage(closeIcon, for: .normal)
    }
    styleSegmentViews()
    styleButton(button: serviceTypeSubmitButton,
                backgroundColor: Const.Color.textFieldFocusColor,
                textColor: .white)
    setGradientColor(top: topGradientColor, bottom: bottomGradientColor)
  }
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  func styleSegmentViews() {
    segmentViews.forEach {
      $0.layer.cornerRadius = 8
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.black.cgColor
    }
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 20
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
}

// MARK: - AdminManagerOutput
extension AdminViewController: AdminManagerOutput {
  func didRemoveServiceStation() {
    self.hideActivityIndicator()
    showToast(message: "Service removed succesfully")
    tableView.reloadData()
  }
  
  func didLoadedAllServiceStations(services: [String : [ServiceStation]]) {
    hideActivityIndicator()
    self.services = services
  }
  
  func didAddNewServiceType() {
    serviceTypeTextField.text = ""
    hideActivityIndicator()
    showToast(message: "New service type was added")
  }
  
  func didGetErrors(_ message: String?) {
    if let message = message {
      showToast(message: message)
    }
  }
}

// MARK: - UITableViewDelegate
extension AdminViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let currentLanguage = LanguageManager.shared.currentLanguage
    
    let actionTitle = currentLanguage == .en ? "Delete" : "Видалити"
    let action = UIContextualAction(style: .normal, title: actionTitle) { (action, view, handler) in
      let type = self.types[indexPath.section]
      guard
        let serviceStation = self.services[type]?[indexPath.row],
        let id = serviceStation.id else { return }
      self.showActivityIndicator()
      self.services[type]?.remove(at: indexPath.row)
      self.networkingManager?.deleteServiceStationWith(id: id)
    }
    action.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    let configuration = UISwipeActionsConfiguration(actions: [action])
    return configuration
  }
}

// MARK: - UITableViewDataSource
extension AdminViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return services[types[section]]?.count ?? 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return types.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return types[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AdminServiceTableViewCell else {
      fatalError()
    }
    let type = types[indexPath.section]
    if let service = services[type]?[indexPath.row] {
      cell.configureWith(name: service.name)
    }
    return cell
  }
}
