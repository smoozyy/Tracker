import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapPlus(_ cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    //MARK: - Static let
    static let identifier = "TrackerCell"
    
    //MARK: - Delegate
    weak var delegate: TrackerCellDelegate?
    
    //MARK: - UI-elements
    private lazy var cardView: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        card.layer.borderWidth = 1
        card.backgroundColor = UIColor(resource: .colorSection5)
        card.layer.borderColor = UIColor(resource: .borderCard).cgColor
        return card
    }()
    
    private lazy var emojiContainerView: UIView = {
        let emoji = UIView()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.backgroundColor = UIColor(resource: .emojiContainer)
        emoji.layer.cornerRadius = 12
        return emoji
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.text = "😘"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .ypWhite)
        label.numberOfLines = 2
        label.text = "Поливаю растения"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .blackDay)
        label.text = "0 дней"
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .colorSection5)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .whiteDay
        let plus = UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
        let image = UIImage(systemName: SystemImages.System.plus, withConfiguration: plus)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
        setupConstraint()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Private methods
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            //CardView
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            //EmojiContainerView
            emojiContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiContainerView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiContainerView.widthAnchor.constraint(equalToConstant: 24),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 24),
            //EmojiLabel
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainerView.centerYAnchor),
            //TitleLabel
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            //CountLabel
            countLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            //PlusButton
            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
            ])
    }
    
    private func setupView() {
        contentView.addSubview(cardView)
        contentView.addSubview(plusButton)
        contentView.addSubview(countLabel)
        cardView.addSubview(emojiContainerView)
        cardView.addSubview(titleLabel)
        emojiContainerView.addSubview(emojiLabel)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        
    }
    
    func configure(isCompleted: Bool, completedDays: Int, tracker: Tracker){
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        countLabel.text = completedDays.daysString()
        let image = isCompleted ? SystemImages.System.checkmark : SystemImages.System.plus
        let config = UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
        let imageName = UIImage(systemName: image, withConfiguration: config)
        plusButton.setImage(UIImage(systemName: image), for: .normal)
        plusButton.alpha = isCompleted ? 0.5 : 1.0
    }
    
    @objc private func didTapPlusButton() {
        delegate?.trackerCellDidTapPlus(self)
    }
}
