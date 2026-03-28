
import UIKit
import Apptics
import Apptics_Swift
import AppticsScreenTracker

class ScreenTrackingViewController: UIViewController {

    private let screenNameField = makeField(placeholder: "e.g. ProductDetailScreen", text: "ProductDetailScreen")
    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Screen Tracking"
        view.backgroundColor = DSColor.background
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APScreentracker.trackViewEnter("ScreenTrackingViewController")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        APScreentracker.trackViewExit("ScreenTrackingViewController")
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
            "Call screenAttached() when a screen appears and screenDetached() when it disappears. This screen is already being tracked.",
            tint: .systemBlue
        ))

        // Screen name card
        let nameCard = cardStack()
        nameCard.addArrangedSubview(inputLabel("Screen Name"))
        nameCard.addArrangedSubview(screenNameField)

        // Attach / Detach row
        let btnRow = UIStackView()
        btnRow.axis = .horizontal
        btnRow.spacing = 12
        btnRow.distribution = .fillEqually
        btnRow.addArrangedSubview(DSButton("Attach", color: .systemGreen, target: self, action: #selector(attachScreen)))
        btnRow.addArrangedSubview(DSButton("Detach", color: UIColor(red: 0.88, green: 0.33, blue: 0.33, alpha: 1), target: self, action: #selector(detachScreen)))
        nameCard.addArrangedSubview(btnRow)
        root.addArrangedSubview(card(nameCard))

        // Simulate 3-screen flow
        root.addArrangedSubview(DSButton("Simulate 3-Screen Flow", color: DSColor.purple, target: self, action: #selector(simulate3ScreenFlow)))

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 200).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Actions

    @objc private func attachScreen() {
        let name = screenNameField.text?.trimmed ?? "ProductDetailScreen"
        guard !name.isEmpty else { return }
        APScreentracker.trackViewEnter(name)
        console.log("screenAttached('\(name)')", level: .success)
    }

    @objc private func detachScreen() {
        let name = screenNameField.text?.trimmed ?? "ProductDetailScreen"
        guard !name.isEmpty else { return }
        APScreentracker.trackViewExit(name)
        console.log("screenDetached('\(name)')", level: .warn)
    }

    @objc private func simulate3ScreenFlow() {
        let screens = ["HomeScreen", "ProductListScreen", "ProductDetailScreen"]
        console.log("Simulating 3-screen flow…", level: .info)
        for (i, name) in screens.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.4) { [weak self] in
                APScreentracker.trackViewEnter(name)
                self?.console.log("screenAttached('\(name)')", level: .success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.4 + 0.3) { [weak self] in
                APScreentracker.trackViewExit(name)
                self?.console.log("screenDetached('\(name)')", level: .warn)
            }
        }
    }
}
