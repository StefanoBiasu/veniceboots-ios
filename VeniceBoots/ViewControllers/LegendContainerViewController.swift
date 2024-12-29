//
//  LegendContainerViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 18/08/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit
import Charts
import TinyConstraints

class LegendContainerViewController: SLMapContainerViewController, ChartViewDelegate {
    
    var gradientLayer = CAGradientLayer()
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.delegate = self
        return chartView
    }()
    
    @IBOutlet weak var legendGradientBar: UIView!
    @IBOutlet weak var legendContainerView: UIView!

    var levelRequestPath: String! = VBConstants.SEA_LEVEL_BACKGROUND

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        legendContainerView.isHidden = isLegendHidden()
        barChartView.isHidden = isLegendHidden()
        legendGradientBar.isHidden = isLegendHidden()
        loadLegendBar()
    }
    
    func minimumSeaLevel() -> Double {
        if levelRequestPath != "full" && levelRequestPath != "background" {
            var levelRequestPathDouble = Double(-(Double(levelRequestPath)! - 40))
            levelRequestPathDouble /= 10
            levelRequestPathDouble.round(.towardZero)
            levelRequestPathDouble *= 10
            return levelRequestPathDouble
        }
        return 0
    }

    
    func maximumSeaLevel()-> Double {
        return 0
    }
    
    func labelCount() -> Int {
        return -Int(minimumSeaLevel() / 10)
    }
    
    func granularity() -> Double {
        return 10
    }
    
    func legendBargradientColors() -> [CGColor] {
        return [UIColor.green.cgColor, UIColor.black.cgColor]
    }
    
    func legendBarLocations() -> [NSNumber] {
        return [0.0, 1.0]
    }
    
    func isLegendHidden()->Bool {
        return levelRequestPath == "background"
    }
    
    override func refresh(_ levelRequestPath: String) {
        self.levelRequestPath = levelRequestPath
        super.refresh(levelRequestPath)
        legendContainerView.isHidden = isLegendHidden()
        barChartView.isHidden = isLegendHidden()
        legendGradientBar.isHidden = isLegendHidden()
        loadLegendBar()
    }
    
    func loadLegendBar() {
        //Legend
        legendContainerView.addSubview(barChartView)
        barChartView.rightToSuperview()
        barChartView.xAxis.enabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 13.0)
        barChartView.rightAxis.labelAlignment = .center
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.isUserInteractionEnabled = false
        
        let rightAxis = barChartView.rightAxis
        rightAxis.axisMinimum = minimumSeaLevel()
        rightAxis.axisMaximum = maximumSeaLevel()
        rightAxis.granularity = granularity()
        rightAxis.labelCount = labelCount()
        rightAxis.valueFormatter = SeaLevelsAxisValueFormatter()
        
        barChartView.drawMarkers = false
        let set = BarChartDataSet(values: [BarChartDataEntry(x: 0, y: 0)], label: "")
        let data = BarChartData(dataSet: set)
        barChartView.data = data
        set.barGradientColors = [[UIColor.black, UIColor.green]]
        
        barChartView.frame = legendContainerView.bounds
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: legendContainerView.topAnchor, constant: 0),
            barChartView.leadingAnchor.constraint(equalTo: legendContainerView.leadingAnchor, constant: 0),
            barChartView.bottomAnchor.constraint(equalTo: legendContainerView.bottomAnchor, constant: 0),
            barChartView.trailingAnchor.constraint(equalTo: legendContainerView.trailingAnchor, constant: 0)
        ])
        set.drawValuesEnabled = false
        barChartView.setNeedsDisplay()
        
        setGradientBackground()
    }
    
    
    func setGradientBackground() {
        gradientLayer.colors = legendBargradientColors()
        gradientLayer.locations = legendBarLocations()
        gradientLayer.frame = self.legendGradientBar.bounds
        self.legendGradientBar.layer.insertSublayer(gradientLayer, at:0)
        self.view.setNeedsDisplay()
    }
}
