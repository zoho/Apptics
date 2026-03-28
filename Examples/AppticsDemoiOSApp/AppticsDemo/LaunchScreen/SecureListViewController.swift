
import Foundation
import UIKit
import AppticsPrivacyShield

class SecureListViewController: UIViewController {
    @objc var ap_screen_name: String = "Secure List Screen"

    private var recordingBadge: UIView?
    private var recordingLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Shield"
        view.backgroundColor = DSColor.background
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APWindowShield.shared().enableScreenRecordingMonitoring()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        APWindowShield.shared().disableScreenRecordingMonitoring()
    }

    // MARK: - UI

    private func setupUI() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let root = vStack(spacing: 14)
        root.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(root)
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
            root.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            root.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            root.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
        ])

        root.addArrangedSubview(infoBanner(
            "AppticsPrivacyShield protects sensitive UI from screen recording and screenshots.",
            tint: DSColor.purple
        ))

        let items: [(String, String, UIColor, SecureTableListType)] = [
            ("Secure UI Elements",       "Protect individual views — hidden during recording.",  DSColor.teal,    .secureElements),
            ("Secure Views",             "Wrap entire screens with APSecureView.",               DSColor.purple,  .secureViews),
            ("Monitor Screen Recording", "Detect active screen recording on this screen.",       .systemOrange,   .secureWindow),
        ]

        for (title, desc, color, type) in items {
            root.addArrangedSubview(navCard(title: title, description: desc, color: color, type: type))
        }

        // Recording status card
        let statusCard = makeRecordingStatusCard()
        root.addArrangedSubview(statusCard)
    }

    private func navCard(title: String, description: String, color: UIColor, type: SecureTableListType) -> UIView {
        let container = UIView()
        container.backgroundColor = DSColor.card
        container.layer.cornerRadius = 14
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 6

        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 5
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 10).isActive = true

        let titleL = UILabel()
        titleL.text = title
        titleL.font = .systemFont(ofSize: 16, weight: .semibold)

        let descL = UILabel()
        descL.text = description
        descL.font = .systemFont(ofSize: 13)
        descL.textColor = .secondaryLabel
        descL.numberOfLines = 0

        let textStack = vStack(spacing: 2)
        textStack.addArrangedSubview(titleL)
        textStack.addArrangedSubview(descL)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor(white: 0.7, alpha: 1)
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [dot, textStack, chevron])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])

        let tap = TypedTapGesture(target: self, action: #selector(cardTapped(_:)))
        tap.listType = type
        container.addGestureRecognizer(tap)
        container.isUserInteractionEnabled = true
        return container
    }

    private func makeRecordingStatusCard() -> UIView {
        let isRecording = UIScreen.main.isCaptured

        let container = UIView()
        container.backgroundColor = isRecording
            ? UIColor.systemRed.withAlphaComponent(0.08)
            : UIColor.systemGreen.withAlphaComponent(0.08)
        container.layer.cornerRadius = 14

        let icon = UIImageView(image: UIImage(systemName: isRecording ? "record.circle" : "eye.slash.fill"))
        icon.tintColor = isRecording ? .systemRed : .systemGreen
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let statusL = UILabel()
        statusL.text = isRecording ? "Screen Recording Active" : "No Recording Detected"
        statusL.font = .systemFont(ofSize: 15, weight: .semibold)
        statusL.textColor = isRecording ? .systemRed : .systemGreen

        let subL = UILabel()
        subL.text = "Screen recording monitoring is enabled on this screen."
        subL.font = .systemFont(ofSize: 13)
        subL.textColor = .secondaryLabel
        subL.numberOfLines = 0

        let textCol = vStack(spacing: 2)
        textCol.addArrangedSubview(statusL)
        textCol.addArrangedSubview(subL)

        let row = UIStackView(arrangedSubviews: [icon, textCol])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])

        recordingLabel = statusL
        recordingBadge = container
        return container
    }

    @objc private func cardTapped(_ gesture: TypedTapGesture) {
        switch gesture.listType {
        case .secureElements:
            navigationController?.pushViewController(SecureElementsController(), animated: true)
        case .secureViews:
            navigationController?.pushViewController(SecureViewController(), animated: true)
        case .secureWindow:
            break
        case .none:
            break
        }
    }
}

private class TypedTapGesture: UITapGestureRecognizer {
    var listType: SecureTableListType?
}
