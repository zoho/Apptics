
import UIKit
import Apptics_Swift

class NonFatalListViewController: UIViewController {

    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Non-Fatal Errors"
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
            "Non-fatal errors are caught and reported without crashing the app. Apptics tracks them for analysis in the dashboard.",
            tint: DSColor.orange
        ))

        for item in NonFatalTableList.nonFatalData {
            root.addArrangedSubview(nonFatalCard(for: item))
        }

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 220).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Card

    private func nonFatalCard(for item: NonFatalTableList) -> UIView {
        let container = UIView()
        container.backgroundColor = DSColor.card
        container.layer.cornerRadius = 14
        container.layer.shadowColor  = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset  = CGSize(width: 0, height: 2)
        container.layer.shadowRadius  = 6

        let iconBg = UIView()
        iconBg.backgroundColor = DSColor.orange.withAlphaComponent(0.1)
        iconBg.layer.cornerRadius = 20
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: sfSymbol(for: item.type)))
        iconView.tintColor = DSColor.orange
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
        ])

        let nameL = UILabel()
        nameL.text = item.name
        nameL.font = .systemFont(ofSize: 15, weight: .semibold)
        nameL.textColor = UIColor(white: 0.1, alpha: 1)
        nameL.numberOfLines = 0

        let descL = UILabel()
        descL.text = description(for: item.type)
        descL.font = .systemFont(ofSize: 12)
        descL.textColor = .secondaryLabel
        descL.numberOfLines = 0

        let textStack = vStack(spacing: 2)
        textStack.addArrangedSubview(nameL)
        textStack.addArrangedSubview(descL)

        let topRow = UIStackView(arrangedSubviews: [iconBg, textStack])
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 12

        let btn = UIButton(type: .system)
        btn.setTitle("Track Error", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = DSColor.orange
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let idx = NonFatalTableList.nonFatalData.firstIndex(where: { $0.name == item.name }) {
            btn.tag = idx
        }
        btn.addTarget(self, action: #selector(trackTapped(_:)), for: .touchUpInside)

        let inner = vStack(spacing: 10)
        inner.addArrangedSubview(topRow)
        inner.addArrangedSubview(btn)
        inner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(inner)
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            inner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            inner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            inner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])
        return container
    }

    // MARK: - Actions

    @objc private func trackTapped(_ sender: UIButton) {
        let item = NonFatalTableList.nonFatalData[sender.tag]
        console.log("Tracking: \(item.name)", level: .info)

        switch item.type {
        case .ObjcException:
            NonFatalMasterObjc().throwException()
            console.log("Tracked Objective-C exception → APTrackException()", level: .success)
        case .ObjcError:
            NonFatalMasterObjc().throwError()
            console.log("Tracked Objective-C error → APTrackError()", level: .success)
        case .SwiftError:
            NonFatalMasterSwift().throwError()
            console.log("Tracked Swift error → APTrackError()", level: .success)
        }
    }

    // MARK: - Metadata

    private func sfSymbol(for type: NonFatalListType) -> String {
        switch type {
        case .ObjcException: return "bolt.circle.fill"
        case .ObjcError:     return "exclamationmark.circle.fill"
        case .SwiftError:    return "swift"
        }
    }

    private func description(for type: NonFatalListType) -> String {
        switch type {
        case .ObjcException: return "Catches an NSException and reports it via APTrackException()"
        case .ObjcError:     return "Catches an NSError and reports it via APTrackError()"
        case .SwiftError:    return "Catches a Swift Error from a failed file read via APTrackError()"
        }
    }
}
