//
//  HabitCellHeader.swift
//  Tracker
//
//  Created by Антон on 03.10.2026.
//

import UIKit
final class HabitEmojiHeader: UICollectionReusableView {
    static let identifier = "emojiHeader"
    
    //MARK: - UI-elements
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
            ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
