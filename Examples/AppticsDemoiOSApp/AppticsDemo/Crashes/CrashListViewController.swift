
import UIKit

class CrashListViewController: UIViewController {

    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crash Reporting"
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
            "Each button below triggers a real crash. The app will terminate and Apptics will report it on the next launch.",
            tint: .systemRed
        ))

        for item in CrashTableList.crashData {
            root.addArrangedSubview(crashCard(for: item))
        }

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 200).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Card

    private func crashCard(for item: CrashTableList) -> UIView {
        let container = UIView()
        container.backgroundColor = DSColor.card
        container.layer.cornerRadius = 14
        container.layer.shadowColor  = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset  = CGSize(width: 0, height: 2)
        container.layer.shadowRadius  = 6

        let iconBg = UIView()
        iconBg.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        iconBg.layer.cornerRadius = 20
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: sfSymbol(for: item.type)))
        iconView.tintColor = .systemRed
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

        let btn = makeCrashButton(item: item)

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

    private func makeCrashButton(item: CrashTableList) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("Trigger Crash", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemRed
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Store type via tag index
        if let idx = CrashTableList.crashData.firstIndex(where: { $0.name == item.name }) {
            btn.tag = idx
        }
        btn.addTarget(self, action: #selector(crashTapped(_:)), for: .touchUpInside)
        return btn
    }

    // MARK: - Actions

    @objc private func crashTapped(_ sender: UIButton) {
        let item = CrashTableList.crashData[sender.tag]
        console.log("Triggering: \(item.name)", level: .warn)
        console.log("App will crash now…", level: .error)

        // Small delay so console entry renders before crash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            switch item.type {
            case .NullPointer:    CrashNULL().crash()
            case .BadPointer:     CrashGarbage().crash()
            case .AsyncSafeThread:CrashAsyncSafeThread().crash()
            case .ObjCException:  CrashObjCException().crash()
            case .ReadOnlyPage:   CrashReadOnlyPage().crash()
            case .CrashAbort:     CrashAbort().crash()
            case .CrashSwift:     CrashSwift().crash()
            }
        }
    }

    // MARK: - Metadata

    private func sfSymbol(for type: CrashListType) -> String {
        switch type {
        case .NullPointer:     return "minus.circle.fill"
        case .BadPointer:      return "exclamationmark.triangle.fill"
        case .AsyncSafeThread: return "lock.fill"
        case .ObjCException:   return "bolt.fill"
        case .ReadOnlyPage:    return "pencil.slash"
        case .CrashAbort:      return "xmark.octagon.fill"
        case .CrashSwift:      return "swift"
        }
    }

    private func description(for type: CrashListType) -> String {
        switch type {
        case .NullPointer:     return "Dereferences a null pointer → SIGSEGV"
        case .BadPointer:      return "Accesses an invalid memory address"
        case .AsyncSafeThread: return "Crashes while __pthread_list_lock is held"
        case .ObjCException:   return "Throws an unhandled NSException"
        case .ReadOnlyPage:    return "Writes to a read-only memory page → SIGBUS"
        case .CrashAbort:      return "Calls abort() to terminate the process → SIGABRT"
        case .CrashSwift:      return "Triggers a Swift runtime fatal error"
        }
    }
}
