//
//  StatisticView.swift
//  Tracker
//
//  Created by Антон on 10.11.2026.
//

import UIKit

final class StatisticView: UIView {
    //MARK: - UI-elements
    private let gradientLayer = CAGradientLayer()
    private let borderMask = CAShapeLayer()
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .blackDay)
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .blackDay)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(resource: .backgroundDay)
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = contentView.bounds

        let path = UIBezierPath(
            roundedRect: contentView.bounds.insetBy(dx: 0.5, dy: 0.5),
            cornerRadius: 16
        )

        borderMask.frame = gradientLayer.bounds
        borderMask.path = path.cgPath
    }
    //MARK: - Override init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpGradient()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private Methods
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //NumberLabel
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            //DescriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            //ContentView
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ])
    }
    
    private func setUpView() {
        addSubview(contentView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setUpGradient() {
        gradientLayer.colors = [
            UIColor(resource: .colorSection3).cgColor,
            UIColor(resource: .colorSection9).cgColor,
            UIColor(resource: .colorSection1).cgColor
        ]

        gradientLayer.locations = [
            0.0,
            0.526,
            1.0
        ]

        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)

        borderMask.lineWidth = 1
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = UIColor.black.cgColor

        gradientLayer.mask = borderMask

        contentView.layer.addSublayer(gradientLayer)
    }
    
    func configure(number: String, description: String) {
        numberLabel.text = number
        descriptionLabel.text = description
    }
}
