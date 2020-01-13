//
//  LoginViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import Toast_Swift

class LoginViewController: UIViewController {
  // MARK: - Properties
  private var authorizationManager: AuthorizationManager?
  private let gradientLayer = CAGradientLayer()
  private let topGradientColor = UIColor(red: 37.0/255.0,
                                         green: 37.0/255.0,
                                         blue: 37.0/255.0,
                                         alpha: 1.0)
  private let bottomGradientColor = UIColor(red: 5.0/255.0,
                                            green: 5.0/255.0,
                                            blue: 5.0/255.0,
                                            alpha: 1.0)
  
  // MARK: - Outlets
  @IBOutlet private weak var switchLanguageButton: UIButton!
  @IBOutlet private weak var emailDescriptionLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var logInButton: UIButton!
  @IBOutlet private weak var signUpButton: UIButton!
  @IBOutlet private weak var logoWidthContraint: NSLayoutConstraint!
  @IBOutlet private weak var logoCenterConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authorizationManager = AuthorizationManager(delegate: self)
    setupView()
    setupDelegates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNotificationsObserver()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Actions
  @IBAction func switchLanguage(_ sender: Any) {
    let currentLanguage = LanguageManager.shared.currentLanguage
    let selectedLanguage: Languages
    switch currentLanguage {
    case .en:
      selectedLanguage = .uk
    case .uk:
      selectedLanguage = .en
    default:
      return
    }
    
    LanguageManager.shared.setLanguage(
      language: selectedLanguage,
      viewControllerFactory: { title -> UIViewController in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }) { view in
      view.alpha = 0
    }
  }
  
  @IBAction func loginPressed(_ sender: Any) {
    guard
      let email = emailTextField.text,
      let password = passwordTextField.text,
      email.count > 0, password.count > 0
      else {
        showToast(message: "Input fields are empty")
        return
    }
    guard email.isEmail else {
      showToast(message: "Invalid email address")
      return
    }
    showActivityIndicator()
    authorizationManager?.logIn(user: User(email: email, password: password))
  }
  
  @IBAction func signupPressed(_ sender: Any) {
    guard
      let email = emailTextField.text,
      let password = passwordTextField.text,
      email.count > 0, password.count > 0
      else {
        showToast(message: "Input fields are empty")
        return
    }
    guard email.isEmail else {
      showToast(message: "Invalid email address")
      return
    }
    showActivityIndicator()
    authorizationManager?.signUp(user: User(email: email, password: password))
  }
  
  @IBAction func adminButtonPressed(_ sender: Any) {
    let currentLanguage = LanguageManager.shared.currentLanguage
    let alertTitle = currentLanguage == .en ? "Log In" : "Увійти"
    let alertMessage = currentLanguage == .en ? "Login as admin to the app" : "Увійти до додатку як адміністратор"
    let loginTextFiledPlaceholder = currentLanguage == .en ? "Login" : "Логін"
    let passwordTextFiledPlaceholder = currentLanguage == .en ? "Password" : "Пароль"
    let loginButtonTitle = currentLanguage == .en ? "Login" : "Увійти"
    let cancelButtonTitle = currentLanguage == .en ? "Cancel" : "Відмінити"
    
    let alert = UIAlertController(title: alertTitle,
                                  message: alertMessage,
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = loginTextFiledPlaceholder
    }
    alert.addTextField { (textField) in
      textField.placeholder = passwordTextFiledPlaceholder
      textField.textContentType = .password
      textField.isSecureTextEntry = true
    }
    let loginAction = UIAlertAction(title: loginButtonTitle, style: .default) { [weak alert] (action) in
      let loginField = alert?.textFields![0]
      let passwordField = alert?.textFields![1]
      if loginField?.text == Const.Admin.login, passwordField?.text == Const.Admin.password {
        self.presentAdminViewController()
      } else {
        self.showToast(message: "Access denied")
      }
    }
    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
    alert.addAction(loginAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
}


// MARK: - Private
private extension LoginViewController {
  func setupView() {
    if let icon = UIImage(named: Const.Image.languageIcon)?.withRenderingMode(.alwaysTemplate){
      switchLanguageButton.leftImage(image: icon, renderMode: .alwaysTemplate)
      switchLanguageButton.titleLabel?.textColor = .white
      switchLanguageButton.tintColor = .white
    }
    emailDescriptionLabel.textColor = Const.Color.lightGray
    styleButton(button: logInButton,
                backgroundColor: Const.Color.languageTint,
                textColor: .white)
    styleButton(button: signUpButton,
                backgroundColor: .white,
                textColor: Const.Color.languageTint)
    setGradientColor(top: topGradientColor, bottom: bottomGradientColor)
  }
  
  func setupDelegates() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 30
    button.layer.borderWidth = 2
    button.layer.borderColor = Const.Color.languageTint.cgColor
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
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  func setupNotificationsObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(willShowKeyboard),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(willHideKeyboard),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  func presentMainViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(identifier: "MainViewController")
    mainVC.modalPresentationStyle = .fullScreen
    present(mainVC, animated: true)
  }
  
  func presentAdminViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(identifier: "AdminViewController")
    mainVC.modalPresentationStyle = .fullScreen
    present(mainVC, animated: true)
  }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 2
    textField.layer.cornerRadius = 5
    textField.layer.borderColor = Const.Color.textFieldFocusColor.cgColor
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 0
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}

// MARK: - AuthorizationManagerOutput
extension LoginViewController: AuthorizationManagerOutput {
  func loggedUserIn() {
    hideActivityIndicator()
    presentMainViewController()
  }
  
  func signedUserUp() {
    hideActivityIndicator()
    presentMainViewController()
  }
  
  func didGetErrors(_ message: String?) {
    hideActivityIndicator()
    if let message = message {
      showToast(message: message)
    }
  }
}

// MARK: - Keyboard notifications handler
private extension LoginViewController {
  @objc func willShowKeyboard() {
    self.logoWidthContraint = self.logoWidthContraint.setMultiplier(multiplier: 0.4)
    logoCenterConstraint.constant = -110
    UIView.animate(withDuration: 3.0) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func willHideKeyboard() {
    self.logoWidthContraint = self.logoWidthContraint.setMultiplier(multiplier: 0.65)
    logoCenterConstraint.constant = 0
    UIView.animate(withDuration: 3.0) {
      self.view.layoutIfNeeded()
    }
  }
}
