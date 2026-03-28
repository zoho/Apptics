
import UIKit

class APIListViewController: UIViewController {

    private let console = ConsoleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "API Tracking"
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

        root.addArrangedSubview(infoBanner(
            "Apptics intercepts URLSession requests made with APAPIManager-enabled configurations. Tap any card to fire a real request.",
            tint: UIColor(red: 0.36, green: 0.42, blue: 0.75, alpha: 1)
        ))

        for item in APITableList.apiData {
            root.addArrangedSubview(apiCard(for: item))
        }

        // Console
        console.translatesAutoresizingMaskIntoConstraints = false
        console.heightAnchor.constraint(equalToConstant: 200).isActive = true
        root.addArrangedSubview(console)
    }

    // MARK: - Cards

    private func apiCard(for item: APITableList) -> UIView {
        let (color, icon, desc) = meta(for: item.type)

        let container = UIView()
        container.backgroundColor = DSColor.card
        container.layer.cornerRadius = 14
        container.layer.shadowColor  = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset  = CGSize(width: 0, height: 2)
        container.layer.shadowRadius  = 6

        // Icon circle
        let iconBg = UIView()
        iconBg.backgroundColor = color.withAlphaComponent(0.12)
        iconBg.layer.cornerRadius = 22
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 44).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
        ])

        let nameL = UILabel()
        nameL.text = item.name
        nameL.font = .systemFont(ofSize: 16, weight: .semibold)
        nameL.textColor = UIColor(white: 0.1, alpha: 1)

        let descL = UILabel()
        descL.text = desc
        descL.font = .systemFont(ofSize: 13)
        descL.textColor = .secondaryLabel
        descL.numberOfLines = 0

        let urlL = UILabel()
        urlL.text = item.url
        urlL.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        urlL.textColor = color
        urlL.numberOfLines = 1

        let textStack = vStack(spacing: 3)
        textStack.addArrangedSubview(nameL)
        textStack.addArrangedSubview(descL)
        textStack.addArrangedSubview(urlL)

        let topRow = UIStackView(arrangedSubviews: [iconBg, textStack])
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 12

        let btn = DSButton("Send Request", color: color, target: self, action: #selector(trackTapped(_:)))
        btn.tag = APITableList.apiData.firstIndex(where: { $0.name == item.name }) ?? 0

        let inner = vStack(spacing: 12)
        inner.addArrangedSubview(topRow)
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

    // MARK: - Actions

    @objc private func trackTapped(_ sender: UIButton) {
        let item = APITableList.apiData[sender.tag]
        let apiId: String? = item.type == .TrackByApiID ? "2138769408909" : "62000000002355"

        console.log("Sending \(item.name)…", level: .info)

        request(url: item.url, apiId: apiId) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.console.log("\(item.name) → request completed", level: .success)
                } else {
                    self?.console.log("\(item.name) → request failed", level: .error)
                }
            }
        }
    }

    // MARK: - Networking

    func request(url: String, apiId: String?, completion: ((Bool) -> Void)? = nil) {
        guard let urlObj = URL(string: url) else { completion?(false); return }

        var request = URLRequest(url: urlObj)
        request.httpMethod = "GET"

        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            if let apiId = apiId {
                mutableRequest.addValue(apiId, forHTTPHeaderField: "API-ID")
            }

            let configuration = URLSessionConfiguration.default
            APAPIManager.enable(for: configuration)
            let session = URLSession(configuration: configuration)

            let task = session.dataTask(with: mutableRequest as URLRequest) { data, response, error in
                if let data = data {
                    print(String(decoding: data, as: UTF8.self))
                    completion?(true)
                } else {
                    print("error \(String(describing: error))")
                    completion?(false)
                }
            }
            task.resume()
        }
    }

    // MARK: - Metadata

    private func meta(for type: ApiListType) -> (UIColor, String, String) {
        switch type {
        case .SimpleMatch:
            return (.systemBlue,   "link",                "Matches the full URL against a configured pattern.")
        case .SingleWithParam:
            return (DSColor.purple, "slider.horizontal.3", "Matches URL with query parameters.")
        case .RegexMatch:
            return (DSColor.teal,  "text.magnifyingglass", "Uses a regex pattern to identify the API.")
        case .TrackByApiID:
            return (DSColor.orange, "tag.fill",             "Uses a custom API-ID request header for tracking.")
        }
    }
}
