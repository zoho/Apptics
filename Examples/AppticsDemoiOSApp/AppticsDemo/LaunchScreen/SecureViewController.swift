
import Foundation
import UIKit
import AppticsPrivacyShield

class SecureViewController: UIViewController {
    @objc var ap_screen_name: String = "Secure container screen"

    private let bodyContainer = UIView()
    private lazy var secureView = APSecureView(contentView: bodyContainer)
    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Secure Views"
        view.backgroundColor = DSColor.background

        // APSecureView fills the screen
        secureView.isUserInteractionEnabled = true
        secureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secureView)
        NSLayoutConstraint.activate([
            secureView.topAnchor.constraint(equalTo: view.topAnchor),
            secureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        setupContent()
    }

    // MARK: - UI

    private func setupContent() {
        bodyContainer.backgroundColor = DSColor.background

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        bodyContainer.addSubview(scroll)
        // Use view.safeAreaLayoutGuide — bodyContainer may not be window-connected yet
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: bodyContainer.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: bodyContainer.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bodyContainer.bottomAnchor),
        ])

        // .fill alignment: arranged subviews stretch to full width — no cross-view width constraints needed
        let root = vStack(spacing: 20)
        root.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(root)
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
            root.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            root.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            root.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
        ])

        // Info banner — fills width naturally with .fill alignment
        root.addArrangedSubview(infoBanner(
            "This entire screen is wrapped in APSecureView — all content below is hidden during screen recording and screenshots.",
            tint: DSColor.purple
        ))

        // Shield badge
        root.addArrangedSubview(makeShieldBadge())

        // Avatar — centered via a full-width wrapper row
        let avatarRow = UIView()
        let avatarCircle = makeAvatar()
        avatarCircle.translatesAutoresizingMaskIntoConstraints = false
        avatarRow.addSubview(avatarCircle)
        NSLayoutConstraint.activate([
            avatarCircle.centerXAnchor.constraint(equalTo: avatarRow.centerXAnchor),
            avatarCircle.topAnchor.constraint(equalTo: avatarRow.topAnchor),
            avatarCircle.bottomAnchor.constraint(equalTo: avatarRow.bottomAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 100),
            avatarCircle.heightAnchor.constraint(equalToConstant: 100),
        ])
        root.addArrangedSubview(avatarRow)

        // Content card
        root.addArrangedSubview(makeContentCard())

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 160).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Sub-views

    private func makeAvatar() -> UIView {
        let circle = UIView()
        circle.backgroundColor = .systemBlue
        circle.layer.cornerRadius = 50

        let icon = UIImageView(image: UIImage(systemName: "person.fill"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        circle.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 52),
            icon.heightAnchor.constraint(equalToConstant: 52),
        ])
        return circle
    }

    private func makeContentCard() -> UIView {
        let card = UIView()
        card.backgroundColor = DSColor.card
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 8

        let inner = vStack(spacing: 16)
        inner.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(inner)
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
        ])

        let addressLabel = UILabel()
        addressLabel.text = "Home address"
        addressLabel.textColor = .white
        addressLabel.backgroundColor = UIColor(red: 0.13, green: 0.38, blue: 0.75, alpha: 1)
        addressLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        addressLabel.textAlignment = .center
        addressLabel.layer.cornerRadius = 12
        addressLabel.layer.masksToBounds = true
        addressLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        inner.addArrangedSubview(addressLabel)

        let bankButton = UIButton(type: .system)
        bankButton.setTitle("Bank details", for: .normal)
        bankButton.setTitleColor(.white, for: .normal)
        bankButton.backgroundColor = UIColor(red: 0.07, green: 0.22, blue: 0.45, alpha: 1)
        bankButton.layer.cornerRadius = 12
        bankButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        bankButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        bankButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        inner.addArrangedSubview(bankButton)

        let healthView = UITextView()
        healthView.text = "Health information"
        healthView.textColor = UIColor(white: 0.2, alpha: 1)
        healthView.backgroundColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 0.3)
        healthView.font = .systemFont(ofSize: 16)
        healthView.isEditable = false
        healthView.layer.cornerRadius = 12
        healthView.isScrollEnabled = false
        healthView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        healthView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        inner.addArrangedSubview(healthView)

        return card
    }

    private func makeShieldBadge() -> UIView {
        let container = UIView()
        container.backgroundColor = DSColor.purple.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10

        let icon = UIImageView(image: UIImage(systemName: "eye.slash.fill"))
        icon.tintColor = DSColor.purple
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let label = UILabel()
        label.text = "Screen content is protected"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = DSColor.purple

        let row = UIStackView(arrangedSubviews: [icon, label])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
        ])
        return container
    }

    @objc private func buttonTapped() {
        console.log("Bank details button tapped", level: .info)
    }
}
