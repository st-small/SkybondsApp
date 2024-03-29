//
//  ReportsView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Charts
import Foundation
import SnapKit

public class ReportsView: UIView {
    
    // UI elements
    private var barChartView: BarChartView!
    private var pieChartView: PieChartView!
    private var lineChartView: LineChartView!
    
    // Data
    private var bondItems: [BondValue]!

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    public func update(_ bondItems: [BondValue], type: ChartType = .price) {
        guard !bondItems.isEmpty else { return }
        self.bondItems = bondItems
        
        clear()
        
        switch type {
        case .price:
            createBarChartView()
        case .yield:
            createLineChart()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func createBarChartView() {
        barChartView = BarChartView()
        setup(barLineChartView: barChartView)
        self.addSubview(barChartView)
        
        barChartView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        barChartView.delegate = self
        
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.legend.enabled = false
        barChartView.maxVisibleCount = 60
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.granularityEnabled = true
        xAxis.labelCount = 5
        
        let xValues = bondItems.compactMap({ $0.dateValue })
        let xValuesStrings = xValues.map({ $0.stringDateWithFormatUTC(format: "HH:mm\ndd.MM.yy") })
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xValuesStrings)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let valuesStrings = xValues.map({ $0.stringDateWithFormatUTC(format: "HH:mm  dd.MM.yyyy") })
        let valueFormatter = IndexAxisValueFormatter(values: valuesStrings)
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: valueFormatter)
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartView.marker = marker
    }
    
    private func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 2.5)
        
        updateBarChartData()
    }
    
    private func updateBarChartData() {
        let dataEntry = bondItems.enumerated().map({ index, item -> BarChartDataEntry in
            BarChartDataEntry(x: Double(index), y: item.price)
        })
        let set = BarChartDataSet(entries: dataEntry)
        set.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        barChartView.data = data
    }
    
    private func createLineChart() {
        
        lineChartView = LineChartView()
        lineChartView.legend.enabled = false
        
        setup(lineChartView: lineChartView)
        self.addSubview(lineChartView)
        
        lineChartView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setup(lineChartView: LineChartView) {
        let values = bondItems.map({ $0.price })
        let valuesMax = (values.max() ?? 1000) * 1.25
        let valuesMin = Double(0)

        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true

        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 5
        xAxis.granularityEnabled = true

        let xValues = bondItems.compactMap({ $0.dateValue })
        let xValuesStrings = xValues.map({ $0.stringDateWithFormatUTC(format: "HH:mm\ndd.MM.yy") })
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xValuesStrings)

        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)

        lineChartView.xAxis.gridLineDashLengths = [10, 10]
        lineChartView.xAxis.gridLineDashPhase = 0

        let leftAxis = lineChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = valuesMax
        leftAxis.axisMinimum = valuesMin
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true

        lineChartView.rightAxis.enabled = false

        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        lineChartView.marker = marker

        lineChartView.legend.form = .line

        lineChartView.animate(xAxisDuration: 2.5)

        updateLineChartData()
    }
    
    private func updateLineChartData() {
        let values = bondItems.enumerated().map { (index, i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: i.price, icon: nil)
        }

        let set1 = LineChartDataSet(entries: values, label: "")
        set1.drawIconsEnabled = false

        set1.setColor(.red)
        set1.setCircleColor(.clear)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineWidth = 1
        set1.formSize = 15

        set1.fillAlpha = 1
        set1.fill = Fill(color: .clear)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        lineChartView.data = data
    }
    
    private func clear() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
}

extension ReportsView: ChartViewDelegate { }
