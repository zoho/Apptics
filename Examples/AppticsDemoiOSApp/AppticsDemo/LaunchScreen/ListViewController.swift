
import UIKit
import Apptics
import Apptics_Swift
import AppticsFeedbackKit
import AppticsInAppUpdate
import AppticsCrossPromotion

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DSColor.background
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = ""
        setupUI()
    }

    // MARK: - UI

    private func setupUI() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let root = vStack(spacing: 28)
        root.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(root)
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: scroll.topAnchor),
            root.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            root.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -32),
            root.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
        ])

        root.addArrangedSubview(makeHeader())

        let groups: [(String, [TableList])] = [
            ("Analytics",          items(for: [.Event, .Screens, .Apitracking])),
            ("Error Reporting",    items(for: [.Crash, .Nonfatal])),
            ("Remote",             items(for: [.Remoteconfig, .Remotelogger, .Appupdate])),
            ("Privacy & Security", items(for: [.Privacy, .securecontainer])),
            ("Engagement",         items(for: [.Feedback, .Crosspromotion])),
            ("Account",            items(for: [.Login, .Logout, .Opensettings])),
        ]

        for (title, groupItems) in groups {
            root.addArrangedSubview(makeSection(title: title, items: groupItems))
        }
    }

    private func makeHeader() -> UIView {
        let container = UIView()

        let appLabel = UILabel()
        appLabel.text = "Apptics Demo"
        appLabel.font = .systemFont(ofSize: 30, weight: .bold)
        appLabel.textColor = UIColor(white: 0.1, alpha: 1)

        let subLabel = UILabel()
        subLabel.text = "iOS Native Integration"
        subLabel.font = .systemFont(ofSize: 15)
        subLabel.textColor = UIColor(white: 0.5, alpha: 1)

        let stack = vStack(spacing: 4)
        stack.addArrangedSubview(appLabel)
        stack.addArrangedSubview(subLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 56),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
        ])
        return container
    }

    private func makeSection(title: String, items: [TableList]) -> UIView {
        let section = vStack(spacing: 12)

        let headerL = UILabel()
        headerL.text = title.uppercased()
        headerL.font = .systemFont(ofSize: 11, weight: .bold)
        headerL.textColor = UIColor(white: 0.55, alpha: 1)
        headerL.letterSpacing(1.2)
        section.addArrangedSubview(headerL)

        // Build 2-column grid rows
        var i = 0
        while i < items.count {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            rowStack.addArrangedSubview(makeTile(item: items[i]))

            if i + 1 < items.count {
                rowStack.addArrangedSubview(makeTile(item: items[i + 1]))
            } else {
                // Odd item — add invisible spacer so tile keeps half-width
                let spacer = UIView()
                spacer.isUserInteractionEnabled = false
                rowStack.addArrangedSubview(spacer)
            }

            section.addArrangedSubview(rowStack)
            i += 2
        }

        return section
    }

    private func makeTile(item: TableList) -> UIView {
        let tile = UIView()
        tile.backgroundColor = DSColor.card
        tile.layer.cornerRadius = 18
        tile.layer.shadowColor = UIColor.black.cgColor
        tile.layer.shadowOpacity = 0.07
        tile.layer.shadowOffset = CGSize(width: 0, height: 2)
        tile.layer.shadowRadius = 8
        // Square-ish tile
        tile.heightAnchor.constraint(equalTo: tile.widthAnchor, multiplier: 0.88).isActive = true

        // Colored icon circle
        let iconBg = UIView()
        iconBg.backgroundColor = item.color.withAlphaComponent(0.12)
        iconBg.layer.cornerRadius = 24
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: sfSymbol(for: item.type)))
        iconView.tintColor = item.color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
        ])

        let titleL = UILabel()
        titleL.text = item.title
        titleL.font = .systemFont(ofSize: 13, weight: .semibold)
        titleL.textColor = UIColor(white: 0.15, alpha: 1)
        titleL.numberOfLines = 2

        let inner = vStack(spacing: 10)
        inner.alignment = .leading
        inner.addArrangedSubview(iconBg)
        inner.addArrangedSubview(titleL)
        inner.translatesAutoresizingMaskIntoConstraints = false
        tile.addSubview(inner)
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: tile.topAnchor, constant: 16),
            inner.leadingAnchor.constraint(equalTo: tile.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -16),
        ])

        let tap = TileGestureRecognizer(target: self, action: #selector(tileTapped(_:)))
        tap.item = item
        tile.addGestureRecognizer(tap)
        tile.isUserInteractionEnabled = true
        return tile
    }

    // MARK: - Navigation

    @objc private func tileTapped(_ gesture: TileGestureRecognizer) {
        guard let item = gesture.item else { return }
        animateTile(gesture.view)
        navigate(to: item.type)
    }

    private func navigate(to type: TableListType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch type {
        case .Event:
            navigationController?.pushViewController(EventsListViewController(), animated: true)
        case .Screens:
            navigationController?.pushViewController(ScreenTrackingViewController(), animated: true)
        case .Crash:
            let vc = storyboard.instantiateViewController(withIdentifier: "CrashListViewController")
            navigationController?.pushViewController(vc, animated: true)
        case .Nonfatal:
            let vc = storyboard.instantiateViewController(withIdentifier: "NonFatalListViewController")
            navigationController?.pushViewController(vc, animated: true)
        case .Feedback:
            FeedbackKit.showFeedback()
        case .securecontainer:
            navigationController?.pushViewController(SecureListViewController(), animated: true)
        case .Appupdate:
            navigationController?.pushViewController(UpdatesViewController(), animated: true)
        case .Apitracking:
            let vc = storyboard.instantiateViewController(withIdentifier: "APIListViewController")
            navigationController?.pushViewController(vc, animated: true)
        case .Remoteconfig:
            navigationController?.pushViewController(RemoteConfigViewController(), animated: true)
        case .Remotelogger:
            navigationController?.pushViewController(RemoteLoggerViewController(), animated: true)
        case .Privacy:
            navigationController?.pushViewController(PrivacyViewController(), animated: true)
        case .Login:
            Apptics.trackLog(in:"user@example.com")
            break
        case .Logout:
            Apptics.trackLogOut("user@example.com")
            break
        case .Opensettings:
            Apptics.openAnalyticSettingsController()
        case .Crosspromotion:
            PromotedAppsKit.presentPromotedAppsController(sectionHeader1: "Related apps", sectionHeader2: "More apps")
        }
    }

    private func animateTile(_ view: UIView?) {
        guard let v = view else { return }
        UIView.animate(withDuration: 0.08, animations: {
            v.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.12) { v.transform = .identity }
        })
    }

    // MARK: - Helpers

    private func items(for types: [TableListType]) -> [TableList] {
        TableList.testData.filter { types.contains($0.type) }
    }

    private func sfSymbol(for type: TableListType) -> String {
        switch type {
        case .Event:          return "bolt.fill"
        case .Screens:        return "rectangle.stack.fill"
        case .Crash:          return "exclamationmark.triangle.fill"
        case .Nonfatal:       return "exclamationmark.circle.fill"
        case .Feedback:       return "bubble.left.fill"
        case .securecontainer:return "lock.fill"
        case .Appupdate:      return "arrow.down.app.fill"
        case .Apitracking:    return "network"
        case .Remoteconfig:   return "slider.horizontal.3"
        case .Remotelogger:   return "doc.text.fill"
        case .Privacy:        return "hand.raised.fill"
        case .Login:          return "person.fill.checkmark"
        case .Logout:         return "person.fill.xmark"
        case .Opensettings:   return "gearshape.fill"
        case .Crosspromotion: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - Tap gesture carrying a TableList item

private class TileGestureRecognizer: UITapGestureRecognizer {
    var item: TableList?
}

// MARK: - Toast

class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15),
            toastContainer.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            toastContainer.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor, constant: -100),
        ])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: { _ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
