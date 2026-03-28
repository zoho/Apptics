
import UIKit
import AppticsEventTracker

class EventsListViewController: UIViewController {

    private let eventNameField  = makeField(placeholder: "e.g. button_clicked",  text: "button_clicked")
    private let groupNameField  = makeField(placeholder: "e.g. UserActions",     text: "UserActions")
    private let propKeyField    = makeField(placeholder: "e.g. plan",            text: "plan")
    private let propValueField  = makeField(placeholder: "e.g. premium",         text: "premium")
    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "In-App Events"
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

        // — Simple Event card —
        root.addArrangedSubview(sectionHeader("Simple Event"))
        let simpleCard = cardStack()
        simpleCard.addArrangedSubview(inputLabel("Event Name"))
        simpleCard.addArrangedSubview(eventNameField)
        simpleCard.addArrangedSubview(inputLabel("Group Name"))
        simpleCard.addArrangedSubview(groupNameField)
        simpleCard.addArrangedSubview(DSButton("Log Simple Event", color: .systemBlue, target: self, action: #selector(logSimple)))
        root.addArrangedSubview(card(simpleCard))

        // — Event with Properties card —
        root.addArrangedSubview(sectionHeader("Event with Properties"))
        let propCard = cardStack()
        propCard.addArrangedSubview(inputLabel("Property Key"))
        propCard.addArrangedSubview(propKeyField)
        propCard.addArrangedSubview(inputLabel("Property Value"))
        propCard.addArrangedSubview(propValueField)
        propCard.addArrangedSubview(DSButton("Log Event with Props", color: DSColor.purple, target: self, action: #selector(logWithProps)))
        root.addArrangedSubview(card(propCard))

        // — Preset events —
        root.addArrangedSubview(DSButton("Log 3 Preset Events", color: .systemGreen, target: self, action: #selector(logPresets)))

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 200).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Actions

    @objc private func logSimple() {
        let name  = eventNameField.text?.trimmed ?? "button_clicked"
        let group = groupNameField.text?.trimmed ?? "UserActions"
        APEvent.trackEvent(name, withGroupName: group)
        console.log("Event '\(name)' logged in group '\(group)'", level: .success)
    }

    @objc private func logWithProps() {
        let name  = eventNameField.text?.trimmed ?? "button_clicked"
        let group = groupNameField.text?.trimmed ?? "UserActions"
        let key   = propKeyField.text?.trimmed   ?? "plan"
        let value = propValueField.text?.trimmed ?? "premium"
        APEvent.trackEvent(name, andGroupName: group, withProperties: [key: value])
        console.log("Event '\(name)' logged with [\(key): \(value)]", level: .success)
    }

    @objc private func logPresets() {
        let presets: [(String, String)] = [
            (AP_EVENT_APP_FIRST_OPEN,  AP_GROUP_APP_LIFE_CYCLE),
            (AP_EVENT_APP_LAUNCHING,   AP_GROUP_APP_LIFE_CYCLE),
            (AP_EVENT_APP_UPDATE,      AP_GROUP_APP_LIFE_CYCLE),
        ]
        presets.forEach { APEvent.trackEvent($0.0, withGroupName: $0.1) }
        console.log("Logged: \(AP_EVENT_APP_FIRST_OPEN)", level: .success)
        console.log("Logged: \(AP_EVENT_APP_LAUNCHING)", level: .success)
        console.log("Logged: \(AP_EVENT_APP_UPDATE)", level: .success)
    }
}

// MARK: - Design Helpers (shared across redesigned screens)

enum DSColor {
    static let background = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    static let card       = UIColor.white
    static let purple     = UIColor(red: 0.42, green: 0.33, blue: 0.85, alpha: 1)
    static let orange     = UIColor(red: 0.95, green: 0.60, blue: 0.10, alpha: 1)
    static let teal       = UIColor(red: 0.15, green: 0.70, blue: 0.70, alpha: 1)
}

func sectionHeader(_ text: String) -> UILabel {
    let l = UILabel()
    l.text = text
    l.font = .systemFont(ofSize: 20, weight: .bold)
    l.textColor = UIColor(white: 0.1, alpha: 1)
    return l
}

func inputLabel(_ text: String) -> UILabel {
    let l = UILabel()
    l.text = text
    l.font = .systemFont(ofSize: 13)
    l.textColor = .secondaryLabel
    return l
}

func makeField(placeholder: String, text: String = "") -> UITextField {
    let f = UITextField()
    f.placeholder = placeholder
    f.text = text
    f.borderStyle = .roundedRect
    f.autocapitalizationType = .none
    f.autocorrectionType = .no
    return f
}

func cardStack() -> UIStackView {
    let s = UIStackView()
    s.axis = .vertical
    s.spacing = 10
    return s
}

func card(_ inner: UIStackView) -> UIView {
    let v = UIView()
    v.backgroundColor = DSColor.card
    v.layer.cornerRadius = 14
    v.layer.shadowColor = UIColor.black.cgColor
    v.layer.shadowOpacity = 0.06
    v.layer.shadowOffset = CGSize(width: 0, height: 2)
    v.layer.shadowRadius = 6
    inner.translatesAutoresizingMaskIntoConstraints = false
    v.addSubview(inner)
    NSLayoutConstraint.activate([
        inner.topAnchor.constraint(equalTo: v.topAnchor, constant: 16),
        inner.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 16),
        inner.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -16),
        inner.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -16),
    ])
    return v
}

/// Card with bold title + gray description inside
func infoCard(title: String, description: String, tint: UIColor) -> UIView {
    let v = UIView()
    v.backgroundColor = tint.withAlphaComponent(0.1)
    v.layer.cornerRadius = 12
    let titleL = UILabel()
    titleL.text = title
    titleL.font = .systemFont(ofSize: 16, weight: .bold)
    titleL.textColor = UIColor(white: 0.1, alpha: 1)
    titleL.numberOfLines = 0
    let descL = UILabel()
    descL.text = description
    descL.font = .systemFont(ofSize: 13)
    descL.textColor = tint.darker()
    descL.numberOfLines = 0
    let stack = UIStackView(arrangedSubviews: [titleL, descL])
    stack.axis = .vertical
    stack.spacing = 6
    stack.translatesAutoresizingMaskIntoConstraints = false
    v.addSubview(stack)
    NSLayoutConstraint.activate([
        stack.topAnchor.constraint(equalTo: v.topAnchor, constant: 14),
        stack.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 14),
        stack.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -14),
        stack.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -14),
    ])
    return v
}

/// Plain colored info banner (no title, just colored text)
func infoBanner(_ text: String, tint: UIColor) -> UIView {
    let v = UIView()
    v.backgroundColor = tint.withAlphaComponent(0.1)
    v.layer.cornerRadius = 12
    let l = UILabel()
    l.text = text
    l.font = .systemFont(ofSize: 14)
    l.textColor = tint.darker()
    l.numberOfLines = 0
    l.translatesAutoresizingMaskIntoConstraints = false
    v.addSubview(l)
    NSLayoutConstraint.activate([
        l.topAnchor.constraint(equalTo: v.topAnchor, constant: 14),
        l.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 14),
        l.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -14),
        l.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -14),
    ])
    return v
}

func vStack(spacing: CGFloat) -> UIStackView {
    let s = UIStackView()
    s.axis = .vertical
    s.spacing = spacing
    return s
}

func DSButton(_ title: String, color: UIColor, target: Any?, action: Selector) -> UIButton {
    let b = UIButton(type: .system)
    b.setTitle(title, for: .normal)
    b.backgroundColor = color
    b.setTitleColor(.white, for: .normal)
    b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    b.layer.cornerRadius = 12
    b.heightAnchor.constraint(equalToConstant: 52).isActive = true
    b.addTarget(target, action: action, for: .touchUpInside)
    return b
}

extension UIColor {
    func darker(by factor: CGFloat = 0.6) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: min(s * 1.2, 1), brightness: b * factor, alpha: a)
        }
        return self
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
}

extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
        attributedText = attributed
    }
}

// MARK: - Console View

enum ConsoleLevel {
    case info, success, warn, error
    var prefix: String {
        switch self {
        case .info:    return "›"
        case .success: return "✓"
        case .warn:    return "⚠"
        case .error:   return "✕"
        }
    }
    var color: UIColor {
        switch self {
        case .info:    return UIColor(white: 0.65, alpha: 1)
        case .success: return UIColor(red: 0.2, green: 0.85, blue: 0.4, alpha: 1)
        case .warn:    return UIColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 1)
        case .error:   return UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1)
        }
    }
}

class ConsoleView: UIView {

    private let textView   = UITextView()
    private let headerView = UIView()
    private var entries: [(String, ConsoleLevel)] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        backgroundColor = UIColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 1)
        layer.cornerRadius = 14
        clipsToBounds = true

        // Header bar
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.04)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)

        let titleL = UILabel()
        titleL.text = "CONSOLE"
        titleL.font = .systemFont(ofSize: 11, weight: .bold)
        titleL.textColor = UIColor(white: 0.4, alpha: 1)

        let dot: (UIColor) -> UIView = { c in
            let v = UIView(); v.backgroundColor = c
            v.layer.cornerRadius = 5
            v.widthAnchor.constraint(equalToConstant: 10).isActive = true
            v.heightAnchor.constraint(equalToConstant: 10).isActive = true
            return v
        }
        let dots = UIStackView(arrangedSubviews: [dot(.systemRed), dot(.systemYellow), dot(.systemGreen)])
        dots.axis = .horizontal
        dots.spacing = 6

        let clearBtn = UIButton(type: .system)
        clearBtn.setTitle("Clear", for: .normal)
        clearBtn.setTitleColor(UIColor(white: 0.4, alpha: 1), for: .normal)
        clearBtn.titleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        clearBtn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

        let headerRow = UIStackView(arrangedSubviews: [dots, titleL, UIView(), clearBtn])
        headerRow.axis = .horizontal
        headerRow.alignment = .center
        headerRow.spacing = 10
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerRow)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),
            headerRow.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            headerRow.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            headerRow.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])

        // Text view
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.textColor = UIColor(white: 0.65, alpha: 1)
        textView.text = "Waiting for events…"
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func log(_ message: String, level: ConsoleLevel = .info) {
        let ts = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        entries.append(("\(ts)  \(level.prefix)  \(message)", level))
        redraw()
    }

    private func redraw() {
        let result = NSMutableAttributedString()
        for (i, (text, level)) in entries.enumerated() {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 12, weight: .regular),
                .foregroundColor: level.color,
            ]
            result.append(NSAttributedString(string: i == 0 ? text : "\n" + text, attributes: attrs))
        }
        textView.attributedText = result
        // Scroll to bottom
        guard textView.text.count > 0 else { return }
        let bottom = NSRange(location: textView.text.count - 1, length: 1)
        textView.scrollRangeToVisible(bottom)
    }

    @objc private func clearTapped() {
        entries.removeAll()
        textView.text = "Waiting for events…"
        textView.textColor = UIColor(white: 0.65, alpha: 1)
    }
}
