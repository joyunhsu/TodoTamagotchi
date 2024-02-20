//
//  ViewController.swift
//  TodoTamagotchi
//
//  Created by Jo Hsu on 2024/2/20.
//

import Combine
import UIKit
import SnapKit
import WidgetKit

class ViewController: UIViewController {

    let petImages: [Profile.Lifecycle: UIImage]
    init(petAssetNames: [Profile.Lifecycle: String]) {
        var images = [Profile.Lifecycle: UIImage]()

        for (lifecycle, assetName) in petAssetNames {
            if let url = Bundle.main.url(forResource: assetName, withExtension: "gif"),
               let imageData = try? Data(contentsOf: url),
               let gifImage = UIImage.gifImageWithData(imageData) {
                images[lifecycle] = gifImage
            } else {
                print("Failed to load GIF for asset name: \(assetName)")
            }
        }

        self.petImages = images
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let petView: UIImageView = {
        let petView = UIImageView()
        petView.translatesAutoresizingMaskIntoConstraints = false
        return petView
    }()

    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.numberOfLines = 0
        descLabel.backgroundColor = .clear

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributedString = NSAttributedString(
            string: "Loading...",
            attributes: [
                .font: UIFont.descriptionLabel ?? .systemFont(ofSize: 13),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paragraphStyle
        ])
        descLabel.attributedText = attributedString
        return descLabel
    }()

    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton()
        refreshBtn.setImage(UIImage(named: "btn_refresh"), for: .normal)
        refreshBtn.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return refreshBtn
    }()

    let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
        return loadingView
    }()

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        view.backgroundColor = UIColor.beige

        let titleLabel = { () -> UILabel in
            let label = UILabel()
            label.text = "Release Band"
            label.font = .titleLabel
            label.numberOfLines = 0
            label.textColor = .label
            label.textAlignment = .center
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(130)
        }

        let subtitleLabel = { () -> UILabel in
            let label = UILabel()
            label.text = "24A Cycle 5"
            label.font = .subtitleLabel
            label.numberOfLines = 0
            label.textColor = .label
            label.textAlignment = .center
            return label
        }()
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        view.addSubview(petView)
        petView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.width.height.equalTo(282)
        }

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(petView.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(26)
        }

        let clickUpBtnImageView = { () -> UIImageView in
            let view = UIImageView()
            view.image = UIImage(named: "btn_icon+text")
            view.contentMode = .scaleAspectFill
            view.frame.size = CGSize(width: 121, height: 40)
            return view
        }()

        let buttonContainerView = UIView()
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(refreshBtn)
        buttonContainerView.addSubview(clickUpBtnImageView)

        refreshBtn.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.centerY.equalToSuperview()
        }

        clickUpBtnImageView.snp.makeConstraints { make in
            make.width.equalTo(121)
            make.height.equalTo(40)
            make.trailing.centerY.equalToSuperview()
        }

        buttonContainerView.snp.makeConstraints { make in
            make.width.equalTo(173)
            make.height.equalTo(40)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-30)
            make.centerX.equalToSuperview()
        }

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(refreshBtn)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            do {
                profile = try await remoteService.getProfile()
            } catch {
                profile = .init(lifecycle: .egg)
                print(error)
            }
        }

    }

    @objc func refresh() {
        Task {
            do {
                loadingView.startAnimating()
                descLabel.text = "Loading..."
                profile = try await remoteService.updateProfile()
                loadingView.stopAnimating()
                WidgetCenter.shared.reloadTimelines(ofKind: "petConsoleWidget")
            } catch {
                profile = .init(lifecycle: .chick)
                print(error)
            }
        }
    }

    let remoteService = RemoteService()

    var profile: Profile? {
        didSet {
            petView.image = (profile?.lifecycle).flatMap { petImages[$0] }
            descLabel.text = profile?.lifecycle.desc
        }
    }
}

struct Profile {
    let lifecycle: Lifecycle
    enum Lifecycle: String, Decodable {
        case egg
        case crackedEgg
        case chick
        case fledgling
        case grownChicken
        case finishLine

        var desc: String {
            switch self {
            case .egg:
                return "As an egg, I'm sturdy but fragile, brimming with potential and waiting to break free."
            case .crackedEgg:
                return "As an egg, I'm sturdy but fragile, brimming with potential and waiting to break free."
            case .chick:
                return "Just hatched, everything is new, exciting, and a little scary. I'm small but willing to grow."
            case .fledgling:
                return "Building strength and learning fast. It's a big world, but bit by bit, I'm conquering it."
            case .grownChicken:
                return "I'm a full-grown chicken now! Capable, strong, and contributing to the world."
            case .finishLine:
                return "I'm a full-grown chicken now! Capable, strong, and contributing to the world."
            }
        }
    }
}

extension Profile: Decodable {
    enum CodingKeys: CodingKey {
        case completeness
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let completeness = try container.decode(Double.self, forKey: .completeness)
        let epsilon = 0.0001

        switch completeness {
        case 0.8 ..< 1:
            self.lifecycle = .finishLine
        case 0.6 ..< 0.8:
            self.lifecycle = .grownChicken
        case 0.4 ..< 0.6:
            self.lifecycle = .fledgling
        case 0.2 ..< 0.4:
            self.lifecycle = .chick
        case epsilon ..< 0.2:
            self.lifecycle = .crackedEgg
        default:
            self.lifecycle = .egg
        }
    }
}

class RemoteService {
    func getProfile() async throws -> Profile {
        let url = URL(string: "https://sprint-tamagotchi.vercel.app/api/stats?value=8.35")!
        let (data, _) = try await URLSession.shared.data(from: url)
        String(data: data, encoding: .utf8).map { print($0) }
        let profile = try JSONDecoder().decode(Profile.self, from: data)
        save(profile)
        return profile
    }

    func updateProfile() async throws -> Profile {
        let url = URL(string: "https://sprint-tamagotchi.vercel.app/api/snapshots?value=8.35")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let (data, _) = try await URLSession.shared.data(for: request)
        String(data: data, encoding: .utf8).map { print($0) }
        let profile = try JSONDecoder().decode(Profile.self, from: data)
        save(profile)
        return profile
    }

    private func save(_ profile: Profile) {
        let userDefaults = UserDefaults(suiteName: "group.com.joyunhsu.todoTamagotchi")
        userDefaults?.set(profile.lifecycle.rawValue, forKey: "LifeCycleStringKey")
    }
}

extension UIColor {
    static let beige = UIColor(red: 226/255, green: 221/255, blue: 215/255, alpha: 1)
    static let label = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
    static let darkButton = UIColor(red: 48/255, green: 48/255, blue: 54/255, alpha: 1)
}

extension UIFont {
    static let titleLabel = UIFont(name: "JoystixMonospace-Regular", size: 26)
    static let subtitleLabel = UIFont(name: "Dogica", size: 16)
    static let descriptionLabel = UIFont(name: "Dogica", size: 13)
}

