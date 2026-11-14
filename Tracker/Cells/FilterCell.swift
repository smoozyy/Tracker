//
//  FilterCell.swift
//  Tracker
//
//  Created by Антон on 07.11.2026.
//

import UIKit

final class FilterCell: UITableViewCell {
    static let identifier = "FilterCell"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(resource: .tableViewBackcolor)
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

}
