//  HabitCell.swift
//  Tracker
//  Created by Антон on 23.09.2026.

import UIKit

final class HabitCell: UICollectionViewCell {
    
    //MARK: - Identifier
    static let habitIdentifier = "HabitCell"
    //MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorCollection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstraint()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder){
        nil
    }
    
    //MARK: - Methods
        override func prepareForReuse() {
            super.prepareForReuse()
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
            contentView.layer.cornerRadius = 0
            titleLabel.text = nil
            titleLabel.isHidden = false
            colorCollection.isHidden = true
            colorCollection.backgroundColor = .clear
        }
        
        func configureEmoji(emojiTitleLabel: String, isSelectedEmoji: Bool) {
            titleLabel.text = emojiTitleLabel
            titleLabel.isHidden = false
            colorCollection.isHidden = true
            
            contentView.layer.borderWidth = 0
            
            if isSelectedEmoji {
                contentView.backgroundColor = UIColor(resource: .lightGray)
                contentView.layer.cornerRadius = 16
            } else {
                contentView.backgroundColor = .clear
            }
        }
        
        func configureColor(colorView: UIColor, isSelectedColor: Bool) {
            titleLabel.isHidden = true
            colorCollection.isHidden = false
            colorCollection.backgroundColor = colorView
            
            contentView.backgroundColor = .clear
            
            if isSelectedColor {
                contentView.layer.cornerRadius = 12
                contentView.layer.borderWidth = 4
                contentView.layer.borderColor = colorView.withAlphaComponent(0.3).cgColor
            } else {
                contentView.layer.borderWidth = 0
            }
        }

    
    //MARK: - Private methods
    private func setUpViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(colorCollection)
    }
    
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
        //TitleLabel
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //ColorCollection
        colorCollection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        colorCollection.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        colorCollection.widthAnchor.constraint(equalToConstant: 40),
        colorCollection.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

