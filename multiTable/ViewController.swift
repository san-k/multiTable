//
//  ViewController.swift
//  multiTable
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 someCompany. All rights reserved.
//

import UIKit

func getArr(color: UIColor, title: String, count: Int) -> [CellDataInfo] {
    var arr = [CellDataInfo]()
    
    for a in 0 ..< count {
        let element = CellDataInfo(backgroungColor: color, title: "\(title) \(a)", children: nil)
        arr.append(element)
    }
    return arr
}

class ViewController: UIViewController {

    var viewModel: MultiTableViewModel = MultiTableViewModel()
    @IBOutlet weak var table: UITableView!

    
    lazy var fullCellDataInfoArr: [CellDataInfo] =  {
        // let arr = [CellDataInfo]()

        let arr_level3_row_1 = getArr(color: .blue, title: "First Row Level 3. ", count: 5)
        
        var arr_level2_row_1 = getArr(color: .yellow, title: "First Row Level 2. ", count: 5)
        arr_level2_row_1[0].children = arr_level3_row_1
        
        
        let arr_level2_row_2 = getArr(color: .yellow, title: "Second Row Level 2. ", count: 5)
        let arr_level2_row_3 = getArr(color: .yellow, title: "Third Row Level 2. ", count: 5)
        let arr_level2_row_4 = getArr(color: .yellow, title: "Fourth Row Level 2. ", count: 5)
        let arr_level2_row_5 = getArr(color: .yellow, title: "Fifth Row Level 2. ", count: 5)
        
        var arr_level1 = getArr(color: .green, title: "Level 1. ", count: 5)
        
        arr_level1[0].children = arr_level2_row_1
        arr_level1[1].children = arr_level2_row_2
        arr_level1[2].children = arr_level2_row_3
        arr_level1[3].children = arr_level2_row_4
        arr_level1[4].children = arr_level2_row_5

        
        
        return arr_level1
    }()
    
    override func viewDidLoad() {
        viewModel.parent = nil
        viewModel.rowInParrentCell = 0 // it doesnt metter, coz parrent is nil.
        viewModel.cellDataInfoArr = fullCellDataInfoArr
        viewModel.table = table
        viewModel.setup()
    }
}
