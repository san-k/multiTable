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

class NextLevelTableInfo {
    weak var viewModelParent: MultiTableViewModel?
    var cellDataInfoArr: [CellDataInfo]
    var table: UITableView?
    
    init(viewModelParent: MultiTableViewModel?, cellDataInfoArr: [CellDataInfo], table: UITableView?) {
        self.viewModelParent = viewModelParent
        self.cellDataInfoArr = cellDataInfoArr
        self.table = table
    }
}

class MultiTableViewModel: NSObject {
    
    enum CellType {
        case simpleCell(realIndex: Int) // with real index we are able to take info from cellDataInfoArr
        case tableCell(currentLevelTableInfo: NextLevelTableInfo)
    }
    
    weak var parent: MultiTableViewModel?
    var tableDeepnessLevel: Int = 0

    var cellTypeArr: [CellType]?
    var cellDataInfoArr: [CellDataInfo]?
    
    weak var table: UITableView?
    weak var tableHeightConstraint: NSLayoutConstraint?
    var tableHeight: CGFloat? {
        get {return tableHeightConstraint?.constant }
        set(newHeight) {
            if let height = newHeight {
                tableHeightConstraint?.constant = height
            }
        }
    }
    
    func load(currentLevelTableInfo: NextLevelTableInfo) {
        
        parent = currentLevelTableInfo.viewModelParent
        cellDataInfoArr = currentLevelTableInfo.cellDataInfoArr
        table = currentLevelTableInfo.table
        
        cellTypeArr = []
        for index in 0..<cellDataInfoArr!.count {
            cellTypeArr?.append(.simpleCell(realIndex: index))
        }

    }
    
    func setup(addTableHeightConstraint: Bool = false) {
        
        if let table = table {
            table.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
            table.register(UINib(nibName: "TableTableViewCell", bundle: nil), forCellReuseIdentifier: "TableTableViewCell")
            
            table.estimatedRowHeight = 40
            table.rowHeight = UITableViewAutomaticDimension
            
            table.dataSource = self
            table.delegate = self
            
            if addTableHeightConstraint {
                table.reloadData()
                table.layoutSubviews()
                let neededHeight = table.contentSize.height
                // and this is the height we need to add to all parents
                
                var localParent = parent
                while localParent != nil {
                    if var tableHeight = localParent!.tableHeight {
                        tableHeight += neededHeight
                    }
                    localParent = localParent!.parent
                }

                let constraint = table.heightAnchor.constraint(equalToConstant: table.contentSize.height)
                tableHeightConstraint = constraint  // this is just because tableHeightConstraint is weak
                tableHeightConstraint!.isActive = true
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

        case let .tableCell(currentLevelTableInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableTableViewCell", for: indexPath) as? TableTableViewCell else { return UITableViewCell() }
            cell.currentLevelTableInfo = currentLevelTableInfo
           return cell
        }
        
    }
}

extension MultiTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var cellTypeArr = cellTypeArr, cellTypeArr.count > indexPath.row else { return }
        
        guard case let CellType.simpleCell(realIndex) = cellTypeArr[indexPath.row] else { return }
        guard let nextLvlInfoArr = cellDataInfoArr?[realIndex].children else { return }
        let nextLevelTableInfo = NextLevelTableInfo(viewModelParent: self, cellDataInfoArr: nextLvlInfoArr, table: nil)
        cellTypeArr.insert(.tableCell(currentLevelTableInfo: nextLevelTableInfo), at: indexPath.row + 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
}
