
import UIKit

class ListCell: UITableViewCell {

    // Keep IBOutlet name so storyboard doesn't crash, but we won't use it
    var titleLabel: UILabel!

    private let cardView    = UIView()
    private let accentBar   = UIView()
    private let dotView     = UIView()
    private let chevronLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // Card
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 14
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 6
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        // Left accent bar
        accentBar.layer.cornerRadius = 3
        accentBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(accentBar)
        NSLayoutConstraint.activate([
            accentBar.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            accentBar.topAnchor.constraint(equalTo: cardView.topAnchor),
            accentBar.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
        ])

        // Dot
        dotView.layer.cornerRadius = 5
        dotView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dotView)
        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 16),
            dotView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 10),
            dotView.heightAnchor.constraint(equalToConstant: 10),
        ])

        // Chevron
        chevronLabel.text = "›"
        chevronLabel.font = .systemFont(ofSize: 22, weight: .light)
        chevronLabel.textColor = UIColor(white: 0.75, alpha: 1)
        chevronLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(chevronLabel)
        NSLayoutConstraint.activate([
            chevronLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])

        // Title label
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(white: 0.13, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: chevronLabel.leadingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
        titleLabel = label
    }

    // MARK: - Configure

    func configure(with item: TableList) {
        titleLabel.text = item.title
        accentBar.backgroundColor = item.color
        dotView.backgroundColor = item.color
    }

    // MARK: - Highlight

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.12) {
            self.cardView.alpha = highlighted ? 0.85 : 1.0
            self.cardView.transform = highlighted
                ? CGAffineTransform(scaleX: 0.98, y: 0.98)
                : .identity
        }
    }
}
