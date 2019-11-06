//
//  ChartViewController.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class ChartViewController: SKBViewController {
    
    // UI elements
    private var reportsView: ReportsView = {
        let view = ReportsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var chartTypeSelectorView: ChartTypeSelector = {
        let view = ChartTypeSelector()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var chartTypesTableView: ChartTypesTableView = {
        let tableViewController = ChartTypesTableView()
        return tableViewController
    }()

    public var viewModel: ChartModelProtocol! {
        didSet {
            viewModel.isUIBlocked.bind { [weak self] isBlocked in
                DispatchQueue.main.async {
                    isBlocked ? self?.lockUI() : self?.unlockUI()
                }
            }
            
            viewModel.bonds.bind { [weak self] bonds in
                guard let bond = bonds.first else { return }
                DispatchQueue.main.async {
                    self?.reportsView.update(bond)
                }
            }
        }
    }
    
    public override func loadView() {
        super.loadView()
        
        loadData()
    }
    
    @objc private func loadData() {
        viewModel?.getBonds()
        
        title = "Charts"
        
        prepareReportsView()
        prepareChartTypeSelectorView()
    }
    
    private func prepareReportsView() {
        view.addSubview(reportsView)
        reportsView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func prepareChartTypeSelectorView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeChartType))
        chartTypeSelectorView.addGestureRecognizer(tap)
        view.addSubview(chartTypeSelectorView)
        chartTypeSelectorView.snp.remakeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(reportsView.snp.top).offset(10)
            make.leading.equalTo(reportsView.snp.leading).offset(10)
        }
    }
    
    @objc
    private func changeChartType() {
        
        if chartTypesTableView.chartTypeDelegate == nil {
            chartTypesTableView.chartTypeDelegate = self
        }
        chartTypesTableView.modalPresentationStyle = .popover
        
        let popOver = chartTypesTableView.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = chartTypeSelectorView
        popOver?.sourceRect =
            CGRect(x: chartTypeSelectorView.bounds.maxX - 10,
                   y: chartTypeSelectorView.bounds.midY,
                   width: 0, height: 0)
        chartTypesTableView.preferredContentSize = CGSize(width: 250, height: 100)
        
        present(chartTypesTableView, animated: true, completion: nil)
    }
}

extension ChartViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ChartViewController: ChartTypesTableViewDelegate {
    public func didSelectChartType(_ type: ChartType) {
        chartTypesTableView.dismiss(animated: true, completion: nil)
        chartTypeSelectorView.updateTitle(type.value)
    }
}
