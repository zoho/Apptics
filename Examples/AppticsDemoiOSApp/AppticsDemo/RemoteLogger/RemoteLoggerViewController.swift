
import UIKit
import Apptics
import Apptics_Swift

class RemoteLoggerViewController: UIViewController {

    private let enableSwitch = UISwitch()
    private let enableLabel = UILabel()
    private let logLevelSegment = UISegmentedControl(items: ["All", "Verbose", "Debug", "Info", "Warn", "Error", "Off"])
    private let messageField = UITextField()
    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Remote Logger"
        view.backgroundColor = .systemBackground
        setupUI()
        // Reflect current status
        enableSwitch.isOn = APLog.logStatus()
        updateEnableLabel()
    }

    // MARK: - UI Setup

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        // Info card
        stack.addArrangedSubview(makeInfoCard(
            text: "APLog lets you remotely capture logs from user devices. " +
                  "Enable logging, set a level, then send logs at different severities."
        ))

        // Enable / disable row
        let enableCard = UIView()
        enableCard.backgroundColor = .secondarySystemBackground
        enableCard.layer.cornerRadius = 12

        enableLabel.font = .systemFont(ofSize: 16, weight: .medium)
        enableSwitch.addTarget(self, action: #selector(toggleLogging), for: .valueChanged)

        let enableRow = UIStackView(arrangedSubviews: [enableLabel, enableSwitch])
        enableRow.axis = .horizontal
        enableRow.alignment = .center
        enableRow.spacing = 12
        enableRow.translatesAutoresizingMaskIntoConstraints = false
        enableCard.addSubview(enableRow)
        NSLayoutConstraint.activate([
            enableRow.topAnchor.constraint(equalTo: enableCard.topAnchor, constant: 12),
            enableRow.leadingAnchor.constraint(equalTo: enableCard.leadingAnchor, constant: 16),
            enableRow.trailingAnchor.constraint(equalTo: enableCard.trailingAnchor, constant: -16),
            enableRow.bottomAnchor.constraint(equalTo: enableCard.bottomAnchor, constant: -12)
        ])
        stack.addArrangedSubview(enableCard)

        // Log level
        stack.addArrangedSubview(makeSectionLabel("Log Level"))
        logLevelSegment.selectedSegmentIndex = 0
        logLevelSegment.addTarget(self, action: #selector(logLevelChanged), for: .valueChanged)
        stack.addArrangedSubview(logLevelSegment)

        // Message input
        stack.addArrangedSubview(makeSectionLabel("Send Log"))

        messageField.placeholder = "Enter log message"
        messageField.borderStyle = .roundedRect
        messageField.text = "Test log from Apptics demo"
        stack.addArrangedSubview(messageField)

        // Log buttons — row 1: Verbose, Debug, Info
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .fillEqually

        let verboseBtn = makeButton(title: "Verbose", color: .systemGray)
        verboseBtn.addTarget(self, action: #selector(logVerbose), for: .touchUpInside)

        let debugBtn = makeButton(title: "Debug", color: .systemBlue)
        debugBtn.addTarget(self, action: #selector(logDebug), for: .touchUpInside)

        let infoBtn = makeButton(title: "Info", color: .systemGreen)
        infoBtn.addTarget(self, action: #selector(logInfo), for: .touchUpInside)

        row1.addArrangedSubview(verboseBtn)
        row1.addArrangedSubview(debugBtn)
        row1.addArrangedSubview(infoBtn)
        stack.addArrangedSubview(row1)

        // Log buttons — row 2: Warn, Error
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .fillEqually

        let warnBtn = makeButton(title: "Warn", color: .systemOrange)
        warnBtn.addTarget(self, action: #selector(logWarn), for: .touchUpInside)

        let errorBtn = makeButton(title: "Error", color: .systemRed)
        errorBtn.addTarget(self, action: #selector(logError), for: .touchUpInside)

        row2.addArrangedSubview(warnBtn)
        row2.addArrangedSubview(errorBtn)
        stack.addArrangedSubview(row2)

        // Privacy masking demo section
        stack.addArrangedSubview(makeSectionLabel("Privacy Masking Demo"))
        let privacyBtn = makeButton(title: "Log with Privacy Masks", color: .systemPurple)
        privacyBtn.addTarget(self, action: #selector(logWithPrivacyMasks), for: .touchUpInside)
        stack.addArrangedSubview(privacyBtn)

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 220).isActive = true
        stack.addArrangedSubview(console)
    }

    // MARK: - Actions

    @objc private func toggleLogging(_ sender: UISwitch) {
        APLog.setLogStatus(sender.isOn)
        updateEnableLabel()
        console.log(sender.isOn ? "Remote logging ENABLED" : "Remote logging DISABLED", level: .info)
    }

    @objc private func logLevelChanged(_ sender: UISegmentedControl) {
        let levels: [APLogLevel] = [.all, .verbose, .debug, .info, .warning, .error, .off]
        let names = ["All", "Verbose", "Debug", "Info", "Warning", "Error", "Off"]
        APLog.setLogLevel(levels[sender.selectedSegmentIndex])
        console.log("Log level set to: \(names[sender.selectedSegmentIndex])", level: .info)
    }

    @objc private func logVerbose() {
        let msg = currentMessage()
        APLogVerbose(msg)
        console.log("[VERBOSE] \(msg)", level: .info)
    }

    @objc private func logDebug() {
        let msg = currentMessage()
        APLogDebug(msg)
        console.log("[DEBUG] \(msg)", level: .info)
    }

    @objc private func logInfo() {
        let msg = currentMessage()
        APLogInfo(msg)
        console.log("[INFO] \(msg)", level: .success)
    }

    @objc private func logWarn() {
        let msg = currentMessage()
        APLogWarn(msg)
        console.log("[WARN] \(msg)", level: .warn)
    }

    @objc private func logError() {
        let msg = currentMessage()
        APLogError(msg)
        console.log("[ERROR] \(msg)", level: .error)
    }

    @objc private func logWithPrivacyMasks() {
        let email = "user@example.com"
        APLogDebug("Debug \(email.ap_privacy(.privateMask))")
        APLogInfo("Info \(email.ap_privacy(.sensitiveMask))")
        APLogWarn("Warn \(email.ap_privacy(.private))")
        APLogError("Error \(email.ap_privacy(.sensitive))")
        console.log("[PRIVACY] Logged '\(email)' with all 4 privacy masks", level: .info)
    }

    // MARK: - Helpers

    private func currentMessage() -> String {
        let text = messageField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        return text.isEmpty ? "Test log message" : text
    }

    private func updateEnableLabel() {
        let on = APLog.logStatus()
        enableLabel.text = on ? "Remote Logging: On" : "Remote Logging: Off"
        enableLabel.textColor = on ? .systemGreen : .label
    }

    private func makeInfoCard(text: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        card.layer.cornerRadius = 12
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        return card
    }

    private func makeSectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }

    private func makeButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }
}
