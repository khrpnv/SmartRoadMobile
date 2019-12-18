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
  private var networkManager: Networking?
  private var roads: [Road] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private let cellID = "CellID"

  // MARK: - Outlets
  @IBOutlet private weak var chartView: LineChartView!
  @IBOutlet private weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
    networkManager = Networking()
    networkManager?.setRoadsDelegate(roadsViewControllerInput: self)
    showActivityIndicator()
    networkManager?.getRoads()
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
    line.colors = [Const.Color.textFieldFocusColor]
    let data = LineChartData()
    data.addDataSet(line)
    chartView.data = data
    chartView.chartDescription?.text = description
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
}

// MARK: - RoadsViewControllerInput
extension RoadsViewController: RoadsViewControllerInput {
  func didLoadedRoads(roads: [Road]) {
    hideActivityIndicator()
    self.roads = roads
  }
}

// MARK: - UITableViewDelegate
extension RoadsViewController: UITableViewDelegate {
  
}

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
