//
//  ChartTypesTableView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public enum ChartType: String, CaseIterable {
    case price = "PRICE"
    case yield = "YIELD"
    
    public var value: String {
        return rawValue
    }
}

public protocol ChartTypesTableViewDelegate: class {
    func didSelectChartType(_ type: ChartType)
}

public class ChartTypesTableView: UITableViewController {
    
    // Data
    public weak var chartTypeDelegate: ChartTypesTableViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChartType.allCases.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ChartType.allCases[indexPath.row].rawValue
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = ChartType.allCases[indexPath.row]
        chartTypeDelegate?.didSelectChartType(type)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
