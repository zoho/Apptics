
import UIKit
import AppticsInAppUpdate

class UpdatesViewController: UIViewController {

    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "In-App Updates"
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

        let root = vStack(spacing: 16)
        root.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(root)
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
            root.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            root.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            root.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
        ])

        // Info banner
        root.addArrangedSubview(infoBanner(
            "Make sure Apptics.initialize() is called before any update APIs. Configure update settings in the Apptics console.",
            tint: .systemGreen
        ))

        // Built-in popup card
        root.addArrangedSubview(infoCard(
            title: "Built-in Update Popup",
            description: "Displays the default Apptics-styled version alert popup.",
            tint: .systemGreen
        ) { [weak self] in self?.showVersionAlert() })

        // Custom flow card
        root.addArrangedSubview(infoCard(
            title: "Custom Update Flow",
            description: "Fetch update data and build your own UI.",
            tint: DSColor.purple
        ) { [weak self] in self?.checkForUpdate() })

        // Result card
        let resultCard = cardStack()
        resultCard.addArrangedSubview(inputLabel("Result"))
        resultLabel.text = "Tap a button to check for updates."
        resultLabel.font = .systemFont(ofSize: 14)
        resultLabel.numberOfLines = 0
        resultLabel.textColor = UIColor(white: 0.3, alpha: 1)
        resultCard.addArrangedSubview(resultLabel)
        root.addArrangedSubview(card(resultCard))

        // Theming info card
        root.addArrangedSubview(bulletCard(
            title: "iOS Theming",
            description: "Customize the update dialog by setting a custom theme via Apptics.setTheme():",
            bullets: [
                "navigationBarTintColor",
                "primaryTextColor",
                "secondaryTextColor",
                "actionButtonColor",
                "actionButtonTextColor",
            ]
        ))
    }

    // MARK: - Actions

    private func showVersionAlert() {
        APAppUpdateManager.checkAndShowVersionAlert(nil)
        self.resultLabel.text = "Version alert popup presented."
    }

    private func checkForUpdate() {
        resultLabel.text = "Checking for update…"
        APAppUpdateManager.checkForAppUpdates { info in
            DispatchQueue.main.async {
                if let info = info as? [String: Any], !info.isEmpty {
                    self.resultLabel.text = "Update info:\n\(info)"
                } else {
                    self.resultLabel.text = "No update available or unable to fetch."
                }
            }
        }
    }
}

// MARK: - Card variant with button action closure

private func infoCard(title: String, description: String, tint: UIColor, action: @escaping () -> Void) -> UIView {
    let container = UIView()
    container.backgroundColor = DSColor.card
    container.layer.cornerRadius = 14
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.06
    container.layer.shadowOffset = CGSize(width: 0, height: 2)
    container.layer.shadowRadius = 6

    let titleL = UILabel()
    titleL.text = title
    titleL.font = .systemFont(ofSize: 17, weight: .bold)
    titleL.textColor = UIColor(white: 0.1, alpha: 1)

    let descL = UILabel()
    descL.text = description
    descL.font = .systemFont(ofSize: 13)
    descL.textColor = .secondaryLabel
    descL.numberOfLines = 0

    let btn = ActionButton(title: buttonTitle(for: title), color: tint, action: action)

    let inner = vStack(spacing: 10)
    inner.addArrangedSubview(titleL)
    inner.addArrangedSubview(descL)
    inner.addArrangedSubview(btn)
    inner.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(inner)
    NSLayoutConstraint.activate([
        inner.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
        inner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
        inner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        inner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
    ])
    return container
}

private func buttonTitle(for cardTitle: String) -> String {
    if cardTitle.contains("Popup") { return "Show Version Alert Popup" }
    if cardTitle.contains("Custom") { return "Check for Update" }
    return cardTitle
}

private func bulletCard(title: String, description: String, bullets: [String]) -> UIView {
    let container = UIView()
    container.backgroundColor = DSColor.card
    container.layer.cornerRadius = 14
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.06
    container.layer.shadowOffset = CGSize(width: 0, height: 2)
    container.layer.shadowRadius = 6

    let titleL = UILabel()
    titleL.text = title
    titleL.font = .systemFont(ofSize: 17, weight: .bold)
    titleL.textColor = UIColor(white: 0.1, alpha: 1)

    let descL = UILabel()
    descL.text = description
    descL.font = .systemFont(ofSize: 13)
    descL.textColor = .secondaryLabel
    descL.numberOfLines = 0

    let inner = vStack(spacing: 6)
    inner.addArrangedSubview(titleL)
    inner.addArrangedSubview(descL)
    for b in bullets {
        let l = UILabel()
        l.text = "• \(b)"
        l.font = .systemFont(ofSize: 13)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        inner.addArrangedSubview(l)
    }
    inner.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(inner)
    NSLayoutConstraint.activate([
        inner.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
        inner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
        inner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        inner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
    ])
    return container
}

// Closure-based button
private class ActionButton: UIButton {
    private var action: (() -> Void)?

    convenience init(title: String, color: UIColor, action: @escaping () -> Void) {
        self.init(type: .system)
        self.action = action
        setTitle(title, for: .normal)
        backgroundColor = color
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc private func tapped() { action?() }
}
