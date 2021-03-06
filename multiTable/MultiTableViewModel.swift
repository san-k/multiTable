//
//  MultiTableViewModel.swift
//  multiTable
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 someCompany. All rights reserved.
//

import Foundation
import UIKit

struct CellDataInfo {
    var backgroungColor: UIColor
    var title: String
    var children: [CellDataInfo]?
    
}


class MultiTableViewModel: NSObject {
    
    enum CellType {
        case simpleCell(realIndex: Int) // with real index we are able to take info from cellDataInfoArr
        case tableCell(cellDataInfoArr: [CellDataInfo])
    }
    
    fileprivate enum SetupType {
        case reuseCell
        case updateParrent(amountOfIncrease: CGFloat)
    }
    
    // properties to setup
    weak var parent: MultiTableViewModel?
    var cellDataInfoArr: [CellDataInfo]?
    weak var table: UITableView?
    var indexPathInParrentCell = IndexPath()
    weak var tableHeightConstraint: NSLayoutConstraint?

    var tableHeight: CGFloat {
        get {return tableHeightConstraint?.constant ?? 0.0}
        set(newHeight) {
            if let tableHeightConstraint = tableHeightConstraint {
                tableHeightConstraint.constant = newHeight
            }
        }
    }

    fileprivate var setupType: SetupType = .reuseCell

    
    var cellTypeArr: [CellType]?
    
    func setup() {
        
        cellTypeArr = []
        for index in 0..<cellDataInfoArr!.count {
            cellTypeArr?.append(.simpleCell(realIndex: index))
        }
        
        if let table = table {
            table.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
            table.register(UINib(nibName: "TableTableViewCell", bundle: nil), forCellReuseIdentifier: "TableTableViewCell")
            
            table.estimatedRowHeight = 40
            table.rowHeight = UITableViewAutomaticDimension
            
            table.dataSource = self
            table.delegate = self
            
            switch setupType {
            case .reuseCell:
                guard tableHeightConstraint != nil else { break }
                table.reloadData()
                table.layoutSubviews()
                let neededHeight = table.contentSize.height
                tableHeight = neededHeight
                // and this is the height we need to add to all parents
                
                if let parent = parent {
                    parent.setupType = .updateParrent(amountOfIncrease: neededHeight)
                    parent.table!.reloadRows(at: [indexPathInParrentCell], with: UITableViewRowAnimation.none)
                }

            case let .updateParrent(amountOfIncrease):
                
                // here our cell is with good height
                // but if table on this level is also in cell
                // we need update table height, and then update parent cell
                
                if let parent = parent {
                    tableHeight += amountOfIncrease
                    parent.setupType = .updateParrent(amountOfIncrease: amountOfIncrease)
                    parent.table?.reloadRows(at: [indexPathInParrentCell], with: UITableViewRowAnimation.none)
                }
                
                setupType = .reuseCell
            }
        }
    }
    
}

extension MultiTableViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypeArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellTypeArr = cellTypeArr, cellTypeArr.count > indexPath.row else {return UITableViewCell() }
        
        let cellType = cellTypeArr[indexPath.row]
        switch cellType {
        case let .simpleCell(realIndex):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell", for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
            guard cellDataInfoArr!.count > realIndex else { return UITableViewCell() }
            let cellDataInfo = cellDataInfoArr![realIndex]
            
            cell.backgroundColor = cellDataInfo.backgroungColor
            cell.label.text = cellDataInfo.title
            return cell

        case let .tableCell(cellDataInfoArr):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableTableViewCell", for: indexPath) as? TableTableViewCell else { return UITableViewCell() }
            cell.viewModel.table = cell.table
            cell.viewModel.parent = self
            cell.viewModel.cellDataInfoArr = cellDataInfoArr
            cell.viewModel.indexPathInParrentCell = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            cell.viewModel.tableHeightConstraint = cell.tableHeightConstraint
            cell.viewModel.setup()
           return cell
        }
        
    }
}

extension MultiTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var cellTypeArr = cellTypeArr, cellTypeArr.count > indexPath.row else { return }
        
        guard case let CellType.simpleCell(realIndex) = cellTypeArr[indexPath.row] else { return }
        guard let nextLvlInfoArr = cellDataInfoArr?[realIndex].children else { return }
        
        self.cellTypeArr!.insert(.tableCell(cellDataInfoArr: nextLvlInfoArr), at: indexPath.row + 1)
        
        // tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: UITableViewRowAnimation.automatic)
        // tableView.endUpdates()
    }
}
