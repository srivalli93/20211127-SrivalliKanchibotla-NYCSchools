//
//  SchoolListTableViewCell.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/29/21.
//

import UIKit

class SchoolListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var schoolNameCellTitle: UILabel!
    @IBOutlet weak var schoolAddressCellSubtitle: UILabel!    
    @IBOutlet weak var colorFillView: UIView!
    
    var colors : [UIColor] = [.green,.orange,.systemBlue]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    //choose colors for view
    func colorPickerForView(_ indexNumber: Int) {
        colorFillView.backgroundColor = colors[indexNumber]
    }
}
