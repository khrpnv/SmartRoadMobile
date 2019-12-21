//
//  RoadsViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import Charts
import Toast_Swift

class RoadsViewController: UIViewController {
  private var roads: [Road] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private let cellID = "CellID"
  private let gradientLayer = CAGradientLayer()

  // MARK: - Outlets
  @IBOutlet private weak var chartView: LineChartView!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var closeButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
    let roadsManager = RoadsManager(delegate: self)
    roadsManager.getRoadsData()
    showActivityIndicator()
  }

  @IBAction func closeScreen(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - Private
private extension RoadsViewController {
  func setupView() {
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = "Roads"
      setupChart(label: "Cars/hour", description: "Amount of cars on road / time")
    case .uk:
      self.title = "Дороги"
      setupChart(label: "Авто/години", description: "Кількість авто на дорозі / час")
    default:
      break
    }
    if let closeIcon = UIImage(named: Const.Image.close)?.withRenderingMode(.alwaysTemplate) {
      closeButton.tintColor = .white
      closeButton.setBackgroundImage(closeIcon, for: .normal)
    }
    view.layer.insertSublayer(gradientLayer, at: 0)
    self.tableView.backgroundColor = .clear
    if let bgColor = MenuItems.getItems().first(where: { $0.type == .roads})?.background {
      setGradientColor(top: bgColor.top, bottom: bgColor.bottom)
    }
  }
  
  func setupChart(label: String, description: String) {
    let entries: [ChartDataEntry] = [
      ChartDataEntry(x: 3, y: 300),
      ChartDataEntry(x: 6, y: 400),
      ChartDataEntry(x: 9, y: 420),
      ChartDataEntry(x: 12, y: 350),
      ChartDataEntry(x: 15, y: 375),
      ChartDataEntry(x: 18, y: 700),
      ChartDataEntry(x: 21, y: 500),
      ChartDataEntry(x: 24, y: 100),
    ]
    let line = LineChartDataSet(entries: entries, label: label)
    line.colors = [.white]
    let data = LineChartData()
    data.addDataSet(line)
    chartView.data = data
    chartView.chartDescription?.text = description
    chartView.chartDescription?.textColor = .white
  }
  
  func showActivityIndicator() {
    self.view.makeToastActivity(.center)
  }
  
  func hideActivityIndicator() {
    self.view.hideToastActivity()
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "RoadTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellID)
  }
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
  }
}

// MARK: - RoadsManagerOutput
extension RoadsViewController: RoadsManagerOutput {
  func didFinishLoadingRoadsData(roads: [Road]) {
    hideActivityIndicator()
    self.roads = roads
  }
}

// MARK: - UITableViewDelegate
extension RoadsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension RoadsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return roads.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? RoadTableViewCell else {
      fatalError("No such cell")
    }
    cell.configureWith(road: roads[indexPath.row])
    return cell
  }
}
