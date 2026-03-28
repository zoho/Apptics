
import UIKit
import AppticsRemoteConfig

class RemoteConfigViewController: UIViewController {

    private let keyField          = makeField(placeholder: "e.g. welcome_message", text: "welcome_message")
    private let coldFetchSwitch   = UISwitch()
    private let fallbackSwitch    = UISwitch()
    private let valueLabel        = UILabel()
    private let condKeyField      = makeField(placeholder: "e.g. user_type",  text: "user_type")
    private let condValueField    = makeField(placeholder: "e.g. premium",    text: "premium")
    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Remote Config"
        view.backgroundColor = DSColor.background
        fallbackSwitch.isOn = true
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

        // Info banner (orange)
        root.addArrangedSubview(infoBanner(
            "Configure parameters in the Apptics console. Use getStringValue() to fetch values. Cold fetch is limited to 3 calls/minute.",
            tint: DSColor.orange
        ))

        // — Fetch Parameter card —
        let fetchCard = cardStack()
        fetchCard.spacing = 12

        let fetchTitle = UILabel()
        fetchTitle.text = "Fetch Parameter"
        fetchTitle.font = .systemFont(ofSize: 17, weight: .bold)
        fetchCard.addArrangedSubview(fetchTitle)

        fetchCard.addArrangedSubview(inputLabel("Parameter Key"))
        fetchCard.addArrangedSubview(keyField)
        fetchCard.addArrangedSubview(toggleRow("Cold Fetch (skip cache)", toggle: coldFetchSwitch))
        fetchCard.addArrangedSubview(toggleRow("Fallback with Offline Value", toggle: fallbackSwitch))
        fetchCard.addArrangedSubview(DSButton("Fetch Value", color: .systemBlue, target: self, action: #selector(fetchValue)))

        // Result row inside card
        let resultRow = vStack(spacing: 4)
        resultRow.addArrangedSubview(inputLabel("Result"))
        valueLabel.text = "—"
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.numberOfLines = 0
        valueLabel.textColor = UIColor(white: 0.25, alpha: 1)
        resultRow.addArrangedSubview(valueLabel)
        fetchCard.addArrangedSubview(resultRow)

        root.addArrangedSubview(card(fetchCard))

        // — Set Custom Condition card —
        let condCard = cardStack()
        condCard.spacing = 12

        let condTitle = UILabel()
        condTitle.text = "Set Custom Condition"
        condTitle.font = .systemFont(ofSize: 17, weight: .bold)
        condCard.addArrangedSubview(condTitle)

        let condDesc = UILabel()
        condDesc.text = "Define device-specific conditions for targeted config delivery."
        condDesc.font = .systemFont(ofSize: 13)
        condDesc.textColor = .secondaryLabel
        condDesc.numberOfLines = 0
        condCard.addArrangedSubview(condDesc)

        condCard.addArrangedSubview(inputLabel("Condition Key"))
        condCard.addArrangedSubview(condKeyField)
        condCard.addArrangedSubview(inputLabel("Condition Value"))
        condCard.addArrangedSubview(condValueField)
        condCard.addArrangedSubview(DSButton("Set Condition", color: DSColor.orange, target: self, action: #selector(setCondition)))
        root.addArrangedSubview(card(condCard))

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 200).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Actions

    @objc private func fetchValue() {
        let key = keyField.text?.trimmed ?? ""
        guard !key.isEmpty else { return }
        let isCold = coldFetchSwitch.isOn
        let useFallback = fallbackSwitch.isOn
        valueLabel.text = "Fetching…"
        console.log("Fetching '\(key)'\(isCold ? " (cold)" : "")…", level: .info)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let value = APRemoteConfig.shared().getStringValue(key, coldFetch: isCold, fallbackWithOfflineValue: useFallback)
            DispatchQueue.main.async {
                let display = value.isEmpty ? "(empty / key not found)" : value
                self.valueLabel.text = display
                self.console.log("'\(key)' = \(display)", level: value.isEmpty ? .warn : .success)
            }
        }
    }

    @objc private func setCondition() {
        let key = condKeyField.text?.trimmed ?? ""
        let val = condValueField.text?.trimmed ?? ""
        guard !key.isEmpty, !val.isEmpty else { return }
        APRemoteConfig.shared().addCustomCriteria(key, value: val)
        console.log("Condition '\(key)' = '\(val)' set", level: .success)
    }
}

// MARK: - Toggle row helper

private func toggleRow(_ label: String, toggle: UISwitch) -> UIView {
    let l = UILabel()
    l.text = label
    l.font = .systemFont(ofSize: 15)
    l.textColor = UIColor(white: 0.2, alpha: 1)
    let row = UIStackView(arrangedSubviews: [l, toggle])
    row.axis = .horizontal
    row.alignment = .center
    row.spacing = 8
    return row
}
