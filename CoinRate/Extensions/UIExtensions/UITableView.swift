//
//  UITableView.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import UIKit

extension UITableView {
    
    func register(cell:UITableViewCell.Type){
        self.register(UINib.init(nibName: cell.identifier(), bundle: nil), forCellReuseIdentifier: cell.identifier())
    }
    
    func register(cells:[UITableViewCell.Type]) {
        cells.forEach { (cell) in
            self.register(cell: cell)
        }
    }
    
    func dequeueCell<T:UITableViewCell>(of type: T.Type ,for indexPath:IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.identifier(), for: indexPath) as! T
    }
    
}
