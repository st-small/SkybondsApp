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
    
    private var periodsView: PeriodsView = {
        let view = PeriodsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Data
    public var viewModel: ChartModelProtocol! {
        didSet {
            viewModel.isUIBlocked.bind { [weak self] isBlocked in
                DispatchQueue.main.async {
                    isBlocked ? self?.lockUI() : self?.unlockUI()
                }
            }
            
            viewModel.bonds.bind { [weak self] bonds in
                guard
                    let bond = bonds.first,
                    let start = bond.items.first?.date,
                    let end = bond.items.last?.date else { return }
                DispatchQueue.main.async {
                    self?.periodsView.update(start, end)
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
        preparePeriodsView()
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
    
    private func preparePeriodsView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPeriodsViewTapped))
        periodsView.addGestureRecognizer(tap)
        view.addSubview(periodsView)
        periodsView.snp.remakeConstraints { make in
            make.top.equalTo(reportsView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(reportsView)
            make.height.equalTo(44)
        }
    }
    
    @objc
    private func openPeriodsViewTapped() {
        let assembly = PeriodsChangeAssembly()
        assembly.handler = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
            })
        }
        let modal = assembly.view
        presentViaCrossDissolve(modal, on: navigationController!)
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
        
        guard let bond = viewModel?.bonds.value.first else { return }
        reportsView.update(bond, type: type)
    }
}
