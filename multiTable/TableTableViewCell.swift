//
//  TableTableViewCell.swift
//  multiTable
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 someCompany. All rights reserved.
//

import UIKit

class TableTableViewCell: UITableViewCell {

    // need to set!!!
    var currentLevelTableInfo: NextLevelTableInfo?
    
    fileprivate var viewModel: MultiTableViewModel?

    @IBOutlet weak var table: UITableView! {
        didSet {
            currentLevelTableInfo?.table = table
            
            viewModel = MultiTableViewModel()
            viewModel?.load(currentLevelTableInfo: currentLevelTableInfo!)
            viewModel?.setup(addTableHeightConstraint: true)
        }
    }

}


