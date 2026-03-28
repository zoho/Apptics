
import Foundation
import UIKit
import AppticsPrivacyShield

class SecureElementsController: UIViewController {
    @objc var ap_screen_name: String = "Secure container screen"

    // Secure elements (hidden during recording/screenshot)
    let sImageView    = APSecureImageView()
    let sSecureLabel  = APSecureLabel()
    let sSecureButton = APSecureButton()
    let sSecureTextView = APSecureTextView()

    // Regular elements (always visible)
    let rImageView    = UIImageView()
    let rSecureLabel  = UILabel()
    let rSecureButton = UIButton(type: .system)
    let rSecureTextView = UITextView()

    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Secure UI Elements"
        view.backgroundColor = DSColor.background
        setupUI()
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
            "APSecure* elements are hidden during screen recording and screenshots. Regular elements remain visible.",
            tint: DSColor.teal
        ))

        // Column header
        root.addArrangedSubview(columnHeader())

        // Element rows
        configureImageViews()
        root.addArrangedSubview(comparisonCard(
            title: "Image View",
            secureView: sImageView,
            regularView: rImageView,
            height: 80
        ))

        configureLabels()
        root.addArrangedSubview(comparisonCard(
            title: "Label",
            secureView: sSecureLabel,
            regularView: rSecureLabel,
            height: 44
        ))

        configureButtons()
        root.addArrangedSubview(comparisonCard(
            title: "Button",
            secureView: sSecureButton,
            regularView: rSecureButton,
            height: 48
        ))

        configureTextViews()
        root.addArrangedSubview(comparisonCard(
            title: "Text View",
            secureView: sSecureTextView,
            regularView: rSecureTextView,
            height: 80
        ))

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 160).isActive = true
        root.addArrangedSubview(console)
    }

    private func columnHeader() -> UIView {
        let typeL = UILabel()
        typeL.text = ""

        let secureL = UILabel()
        secureL.text = "SECURE"
        secureL.font = .systemFont(ofSize: 11, weight: .bold)
        secureL.textColor = DSColor.teal
        secureL.textAlignment = .center

        let regularL = UILabel()
        regularL.text = "REGULAR"
        regularL.font = .systemFont(ofSize: 11, weight: .bold)
        regularL.textColor = UIColor(white: 0.55, alpha: 1)
        regularL.textAlignment = .center

        let row = UIStackView(arrangedSubviews: [typeL, secureL, regularL])
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        row.isLayoutMarginsRelativeArrangement = true
        return row
    }

    private func comparisonCard(title: String, secureView: UIView, regularView: UIView, height: CGFloat) -> UIView {
        let container = UIView()
        container.backgroundColor = DSColor.card
        container.layer.cornerRadius = 14
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 6

        let titleL = UILabel()
        titleL.text = title
        titleL.font = .systemFont(ofSize: 13, weight: .semibold)
        titleL.textColor = UIColor(white: 0.4, alpha: 1)

        secureView.heightAnchor.constraint(equalToConstant: height).isActive = true
        regularView.heightAnchor.constraint(equalToConstant: height).isActive = true

        let cols = UIStackView(arrangedSubviews: [secureView, regularView])
        cols.axis = .horizontal
        cols.distribution = .fillEqually
        cols.spacing = 12
        cols.alignment = .center

        let inner = vStack(spacing: 10)
        inner.addArrangedSubview(titleL)
        inner.addArrangedSubview(cols)
        inner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(inner)
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            inner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            inner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])
        return container
    }

    // MARK: - Configure elements

    private func configureImageViews() {
        sImageView.image = UIImage(systemName: "eye.slash.circle.fill")
        sImageView.tintColor = DSColor.teal
        sImageView.contentMode = .scaleAspectFit

        rImageView.image = UIImage(systemName: "eye.circle.fill")
        rImageView.tintColor = UIColor(white: 0.65, alpha: 1)
        rImageView.contentMode = .scaleAspectFit
    }

    private func configureLabels() {
        let inner = sSecureLabel.label
        inner.text = "Secured Label"
        inner.textColor = .white
        inner.backgroundColor = DSColor.teal
        inner.font = .systemFont(ofSize: 14, weight: .semibold)
        inner.textAlignment = .center
        inner.layer.cornerRadius = 8
        inner.layer.masksToBounds = true

        rSecureLabel.text = "Regular Label"
        rSecureLabel.textColor = UIColor(white: 0.3, alpha: 1)
        rSecureLabel.backgroundColor = UIColor(white: 0.93, alpha: 1)
        rSecureLabel.font = .systemFont(ofSize: 14)
        rSecureLabel.textAlignment = .center
        rSecureLabel.layer.cornerRadius = 8
        rSecureLabel.layer.masksToBounds = true
    }

    private func configureButtons() {
        sSecureButton.button.setTitle("Secure Button", for: .normal)
        sSecureButton.button.setTitleColor(.white, for: .normal)
        sSecureButton.button.backgroundColor = DSColor.teal
        sSecureButton.button.layer.cornerRadius = 10
        sSecureButton.button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        sSecureButton.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        rSecureButton.setTitle("Normal Button", for: .normal)
        rSecureButton.setTitleColor(.white, for: .normal)
        rSecureButton.backgroundColor = UIColor(white: 0.65, alpha: 1)
        rSecureButton.layer.cornerRadius = 10
        rSecureButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        rSecureButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func configureTextViews() {
        let inner = sSecureTextView.textView
        inner.text = "Confidential\nInformation"
        inner.textColor = UIColor(white: 0.15, alpha: 1)
        inner.backgroundColor = DSColor.teal.withAlphaComponent(0.12)
        inner.font = .systemFont(ofSize: 13)
        inner.isEditable = false
        inner.layer.cornerRadius = 8
        inner.isScrollEnabled = false

        rSecureTextView.text = "Non-sensitive\nData"
        rSecureTextView.textColor = UIColor(white: 0.3, alpha: 1)
        rSecureTextView.backgroundColor = UIColor(white: 0.93, alpha: 1)
        rSecureTextView.font = .systemFont(ofSize: 13)
        rSecureTextView.isEditable = false
        rSecureTextView.layer.cornerRadius = 8
        rSecureTextView.isScrollEnabled = false
    }

    @objc private func buttonTapped() {
        console.log("Button tapped", level: .info)
    }
}
