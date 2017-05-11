//
//  TableTableViewOwner.swift
//  multiTable
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 someCompany. All rights reserved.
//

import Foundation
import UIKit


class TableTableViewController: NSObject {
    
    weak var cell: TableTableViewCell!
   
    public func setup() {
        let table = cell.table!
        table.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
        table.estimatedRowHeight = 40
        table.rowHeight = UITableViewAutomaticDimension
        
        table.reloadData()
        table.layoutSubviews()
        // table.layoutIfNeeded()
        table.heightAnchor.constraint(equalToConstant: table.contentSize.height).isActive = true

    }
    
}

extension TableTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell", for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
        cell.label.text = "second level - \(indexPath.row)"
        cell.label.backgroundColor = UIColor.red
        return cell
    }
    
}
