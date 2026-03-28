
import UIKit
import Apptics
import Apptics_Swift

class PrivacyViewController: UIViewController {

    private let engSwitch  = UISwitch()
    private let crashSwitch = UISwitch()
    private let piiSwitch   = UISwitch()

    private let stateNameLabel  = UILabel()
    private let stateEnumLabel  = UILabel()
    private var referenceRows   = [StateReferenceRow]()

    // Derived state
    private var eng:   Bool { engSwitch.isOn }
    private var crash: Bool { crashSwitch.isOn }
    private var pii:   Bool { piiSwitch.isOn }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Settings"
        view.backgroundColor = DSColor.background
        setupUI()
        loadCurrentState()
    }

    // MARK: - State

    private func loadCurrentState() {
        engSwitch.isOn   = Apptics.trackingStatus()
        crashSwitch.isOn = Apptics.crashReportStatus()
        piiSwitch.isOn   = Apptics.personalInfoTrackingStatus()
        refreshState()
    }

    private func applyAndRefresh() {
        Apptics.setTrackingStatus(engSwitch.isOn)
        Apptics.setCrashReportStatus(crashSwitch.isOn)
        Apptics.setPersonalInfoTrackingStatus(piiSwitch.isOn)
        refreshState()
    }

    private func refreshState() {
        let (name, enumStr) = stateDescription(eng: eng, crash: crash, pii: pii)
        stateNameLabel.text = name
        stateEnumLabel.text = enumStr
        for row in referenceRows {
            let isActive = row.stateName == name
            row.label.textColor    = isActive ? DSColor.purple : UIColor(white: 0.3, alpha: 1)
            row.label.font         = isActive ? .systemFont(ofSize: 15, weight: .semibold) : .systemFont(ofSize: 15)
            row.checkmark.isHidden = !isActive
            row.container.backgroundColor = isActive
                ? DSColor.purple.withAlphaComponent(0.08)
                : .clear
        }
    }

    private func stateDescription(eng: Bool, crash: Bool, pii: Bool) -> (name: String, enumStr: String) {
        switch (eng, crash, pii) {
        case (true,  true,  true):  return ("Usage + Crash + PII",     "TrackingState.AllTrackingWithPII")
        case (true,  true,  false): return ("Usage + Crash (no PII)",  "TrackingState.UsageAndCrashTrackingWithoutPII")
        case (true,  false, true):  return ("Usage only + PII",        "TrackingState.UsageTrackingWithPII")
        case (true,  false, false): return ("Usage only (no PII)",     "TrackingState.UsageTrackingWithoutPII")
        case (false, true,  true):  return ("Crash only + PII",        "TrackingState.CrashTrackingWithPII")
        case (false, true,  false): return ("Crash only (no PII)",     "TrackingState.CrashTrackingWithoutPII")
        default:                    return ("All Tracking Off",         "TrackingState.TrackingOff")
        }
    }

    private var allStateNames: [(name: String, eng: Bool, crash: Bool, pii: Bool)] {
        [
            ("Usage + Crash + PII",    true,  true,  true),
            ("Usage only + PII",       true,  false, true),
            ("Crash only + PII",       false, true,  true),
            ("Usage + Crash (no PII)", true,  true,  false),
            ("Usage only (no PII)",    true,  false, false),
            ("Crash only (no PII)",    false, true,  false),
        ]
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

        // Info banner
        root.addArrangedSubview(infoBanner(
            "Control what data Apptics collects. Changes take effect immediately via Apptics.setTrackingState().",
            tint: .systemBlue
        ))

        // Toggle cards
        let toggleData: [(String, String, UIColor, UISwitch, Selector)] = [
            ("Track Engagements",       "Events, screens, sessions, and API usage",          .systemBlue,  engSwitch,   #selector(toggled)),
            ("Track Crash & Non-fatal", "Unhandled exceptions and non-fatal errors",         .systemRed,   crashSwitch, #selector(toggled)),
            ("Track with PII",          "Include personally identifiable info set via Apptics.setUser()", DSColor.orange, piiSwitch, #selector(toggled)),
        ]
        for (title, subtitle, color, sw, action) in toggleData {
            sw.addTarget(self, action: action, for: .valueChanged)
            root.addArrangedSubview(toggleCard(title: title, subtitle: subtitle, color: color, toggle: sw))
        }

        // Active state card (dark)
        let darkCard = UIView()
        darkCard.backgroundColor = UIColor(red: 0.09, green: 0.10, blue: 0.17, alpha: 1)
        darkCard.layer.cornerRadius = 14

        let stateTitleL = UILabel()
        stateTitleL.text = "Active Tracking State"
        stateTitleL.font = .systemFont(ofSize: 12, weight: .semibold)
        stateTitleL.textColor = UIColor(white: 0.55, alpha: 1)
        stateTitleL.textAlignment = .center

        stateNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        stateNameLabel.textColor = .white
        stateNameLabel.textAlignment = .center
        stateNameLabel.numberOfLines = 0

        stateEnumLabel.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        stateEnumLabel.textColor = UIColor(white: 0.45, alpha: 1)
        stateEnumLabel.textAlignment = .center
        stateEnumLabel.numberOfLines = 0

        let darkInner = vStack(spacing: 6)
        darkInner.alignment = .center
        [stateTitleL, stateNameLabel, stateEnumLabel].forEach { darkInner.addArrangedSubview($0) }
        darkInner.translatesAutoresizingMaskIntoConstraints = false
        darkCard.addSubview(darkInner)
        NSLayoutConstraint.activate([
            darkInner.topAnchor.constraint(equalTo: darkCard.topAnchor, constant: 18),
            darkInner.leadingAnchor.constraint(equalTo: darkCard.leadingAnchor, constant: 16),
            darkInner.trailingAnchor.constraint(equalTo: darkCard.trailingAnchor, constant: -16),
            darkInner.bottomAnchor.constraint(equalTo: darkCard.bottomAnchor, constant: -18),
        ])
        root.addArrangedSubview(darkCard)

        // State reference card
        let refCard = UIView()
        refCard.backgroundColor = DSColor.card
        refCard.layer.cornerRadius = 14
        refCard.layer.shadowColor  = UIColor.black.cgColor
        refCard.layer.shadowOpacity = 0.06
        refCard.layer.shadowOffset  = CGSize(width: 0, height: 2)
        refCard.layer.shadowRadius  = 6

        let refInner = vStack(spacing: 2)
        let refHeader = UILabel()
        refHeader.text = "STATE REFERENCE"
        refHeader.font = .systemFont(ofSize: 11, weight: .semibold)
        refHeader.textColor = UIColor(white: 0.55, alpha: 1)
        refInner.addArrangedSubview(refHeader)
        refInner.setCustomSpacing(10, after: refHeader)

        for state in allStateNames {
            let row = StateReferenceRow(stateName: state.name)
            referenceRows.append(row)
            refInner.addArrangedSubview(row.container)
        }

        refInner.translatesAutoresizingMaskIntoConstraints = false
        refCard.addSubview(refInner)
        NSLayoutConstraint.activate([
            refInner.topAnchor.constraint(equalTo: refCard.topAnchor, constant: 16),
            refInner.leadingAnchor.constraint(equalTo: refCard.leadingAnchor, constant: 16),
            refInner.trailingAnchor.constraint(equalTo: refCard.trailingAnchor, constant: -16),
            refInner.bottomAnchor.constraint(equalTo: refCard.bottomAnchor, constant: -16),
        ])
        root.addArrangedSubview(refCard)
    }

    @objc private func toggled() { applyAndRefresh() }

    // MARK: - Toggle card

    private func toggleCard(title: String, subtitle: String, color: UIColor, toggle: UISwitch) -> UIView {
        let v = UIView()
        v.backgroundColor = DSColor.card
        v.layer.cornerRadius = 14
        v.layer.shadowColor  = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.05
        v.layer.shadowOffset  = CGSize(width: 0, height: 2)
        v.layer.shadowRadius  = 4

        let dot = UIView()
        dot.backgroundColor    = color
        dot.layer.cornerRadius = 5
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 10).isActive = true

        let titleL = UILabel()
        titleL.text = title
        titleL.font = .systemFont(ofSize: 16, weight: .semibold)

        let subtitleL = UILabel()
        subtitleL.text = subtitle
        subtitleL.font = .systemFont(ofSize: 13)
        subtitleL.textColor = .secondaryLabel
        subtitleL.numberOfLines = 0

        let textStack = vStack(spacing: 2)
        textStack.addArrangedSubview(titleL)
        textStack.addArrangedSubview(subtitleL)

        let leftStack = UIStackView(arrangedSubviews: [dot, textStack])
        leftStack.axis = .horizontal
        leftStack.spacing = 10
        leftStack.alignment = .center

        let row = UIStackView(arrangedSubviews: [leftStack, toggle])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: v.topAnchor, constant: 14),
            row.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -14),
        ])
        return v
    }
}

// MARK: - State reference row model

private class StateReferenceRow {
    let stateName: String
    let container = UIView()
    let label     = UILabel()
    let checkmark = UILabel()

    init(stateName: String) {
        self.stateName = stateName
        label.text = stateName
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(white: 0.3, alpha: 1)

        checkmark.text = "✓"
        checkmark.font = .systemFont(ofSize: 15, weight: .bold)
        checkmark.textColor = DSColor.purple
        checkmark.isHidden = true

        let row = UIStackView(arrangedSubviews: [label, checkmark])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false

        container.layer.cornerRadius = 8
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
        ])
    }
}
