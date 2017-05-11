//
//  ViewController.swift
//  multiTable
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 someCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: MultiTableViewModel?
    lazy var fullCellDataInfoArr = [CellDataInfo]()
    
    @IBOutlet weak var table: UITableView! {
        didSet {
            
            viewModel = MultiTableViewModel()
            let currentLevelTableInfo = NextLevelTableInfo(viewModelParent: nil, cellDataInfoArr: fullCellDataInfoArr, table: table)
            viewModel?.load(currentLevelTableInfo: currentLevelTableInfo)
            viewModel?.setup(addTableHeightConstraint: false)
            
            
        }
    }

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        table.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
//        table.register(UINib(nibName: "TableTableViewCell", bundle: nil), forCellReuseIdentifier: "TableTableViewCell")
//        
//        table.estimatedRowHeight = 40
//        table.rowHeight = UITableViewAutomaticDimension
//        
//    }

}

//extension ViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cellInfoArr.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard cellInfoArr.count > indexPath.row else {return UITableViewCell() }
//        
//        let cellInfo = cellInfoArr[indexPath.row]
//        switch cellInfo {
//        case let .simpleCell(text):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell", for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
//            cell.label.text = text
//            return cell
//        case .tableCell:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableTableViewCell", for: indexPath) as? TableTableViewCell else { return UITableViewCell() }
//            return cell
//        }
//        
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard cellInfoArr.count > indexPath.row else { return }
//        cellInfoArr.insert(.tableCell, at: indexPath.row + 1)
//        
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: UITableViewRowAnimation.automatic)
//        tableView.endUpdates()
//        
//        
//    }
//}
