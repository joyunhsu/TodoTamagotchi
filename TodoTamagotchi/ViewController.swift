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

    let petImages: [UIImage?]
    init(petAssetNames: [String], ext: String = "gif") {
        let images: [UIImage?] = petAssetNames.map { assetName in
            if let url = Bundle.main.url(forResource: assetName, withExtension: ext),
               let imageData = try? Data(contentsOf: url),
               let gifImage = UIImage.gifImageWithData(imageData) {
                return gifImage
            } else {
                print("Failed to load GIF for asset name: \(assetName)")
                return nil
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
        return petView
    }()

    let descLabel: UILabel = {
        let descLabel = UILabel()
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
        refreshBtn.isEnabled = false
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

        profile = localService.getProfile()
        refresh()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            do {
                profile = try await remoteService.getProfile()
                localService.updateProfile(profile)
            } catch {
                print(error)
            }
        }

    }

    @objc func refresh() {
        Task {
            do {
                loadingView.startAnimating()
                defer { loadingView.stopAnimating() }
//                descLabel.text = "Loading..."
                profile = try await remoteService.updateProfile()
                localService.updateProfile(profile)
                WidgetCenter.shared.reloadTimelines(ofKind: "petConsoleWidget")
            } catch {
                profile = profile
                print(error)
            }

            self.refresh()
        }
    }

    let remoteService = RemoteService()
    let localService = LocalService()

    var profile: Profile? {
        didSet {
            petView.image = profile.flatMap { petImages[$0.progressLevel] }
            descLabel.text = profile?.desc
            profile.map { animateWaterDrops($0.steps) }

            if profile?.desc?.isEmpty ?? true, let oldDesc = oldValue?.desc {
                profile?.desc = oldDesc
                descLabel.text = profile?.desc
            }
        }
    }

    var maxWaterDrops = 0
    var runningWaterDrops = 0
    func animateWaterDrops(_ amount: Int) {
        maxWaterDrops = amount

        for _ in 0 ..< amount {
            let time = TimeInterval(Int.random(in: 0...amount))
            animateWaterDropUntilUnavailable(startedAfter: time)
        }
    }

    func animateWaterDropUntilUnavailable(startedAfter: TimeInterval) {
        Timer
            .publish(every: startedAfter, on: .main, in: .default)
            .autoconnect()
            .first()
            .sink(receiveValue: { [weak self] _ in
                self?.animateWaterDropUntilUnavailable()
            })
            .store(in: &cancellables)
    }

    func animateWaterDropUntilUnavailable() {
        var animateWaterDropUntilUnavailable: (() -> Void)?
        animateWaterDropUntilUnavailable = { [weak self] in
            guard let self else { return }
            animateWaterDrop { [weak self] in
                guard let self else { return }
                if runningWaterDrops <= maxWaterDrops {
                    animateWaterDropUntilUnavailable?()
                    return
                }
                runningWaterDrops -= 1
            }
        }

        self.runningWaterDrops += 1
        animateWaterDropUntilUnavailable?()
    }

    func animateWaterDrop(completion: @escaping () -> Void) {
        let waterDrop: UIView = {
            let url = Bundle.main.url(forResource: "WaterDrop", withExtension: "webp")!
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)!
            let imageView = UIImageView(image: image)
            return imageView
        }()

        let hRange = -80...80
        let vRange = 30...150
        let vGranularity = 5

        view.addSubview(waterDrop)
        waterDrop.isHidden = true

        var vertical: Constraint?
        waterDrop.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerX.equalTo(view).offset(Int.random(in: hRange))
            vertical = make.centerY.equalTo(petView.snp.top).constraint
        }

        let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

        let petHeight = timer
            .map { [petView] _ in Int(petView.frame.height) }
            .removeDuplicates()

        let counter = timer
            .scan(0) { count, _ in count + 1 }

        let offset = Publishers
            .CombineLatest(petHeight, counter)
            .map { petHeight, counter in
                let height = vRange.upperBound-vRange.lowerBound
                let y = vRange.lowerBound
                let offsetFromY = (counter % (height / vGranularity)) * vGranularity
                return y + offsetFromY
            }

        var cancellable: AnyCancellable?
        cancellable = offset
            .sink(receiveValue: { offset in
                guard offset < vRange.upperBound - vGranularity else {
                    waterDrop.removeFromSuperview()
                    cancellable?.cancel()
                    completion()
                    return
                }
                waterDrop.isHidden = false
                vertical?.update(offset: offset)
            })
    }

    var cancellables: [AnyCancellable] = []
}

class Profile: Codable {
    let progressLevel: Int
    let steps: Int
    var desc: String?

    init(progressLevel: Int, steps: Int, desc: String? = nil) {
        self.progressLevel = progressLevel
        self.steps = steps
        self.desc = desc
    }
}

extension Profile {
    convenience init() {
        self.init(progressLevel: 0, steps: 0, desc: nil)
    }

    convenience init(response: RemoteService.Response) {
        self.init(progressLevel: response.progressLevel, steps: response.steps, desc: response.desc)
    }
}

class RemoteService {
    struct Response: Decodable {
        let progressLevel: Int
        let completeness: Double
        let velocity: Double?
        let steps: Int
        let desc: String?
    }

    func getProfile() async throws -> Profile {
        let url = URL(string: "https://sprint-tamagotchi.vercel.app/api/stats?value=8.35")!
        let (data, _) = try await URLSession.shared.data(from: url)
        String(data: data, encoding: .utf8).map { print($0) }
        let response = try JSONDecoder().decode(Response.self, from: data)
        let profile = Profile(response: response)
        return profile
    }

    func updateProfile() async throws -> Profile {
        let url = URL(string: "https://sprint-tamagotchi.vercel.app/api/snapshots?value=8.35")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let (data, _) = try await URLSession.shared.data(for: request)
        String(data: data, encoding: .utf8).map { print($0) }
        let response = try JSONDecoder().decode(Response.self, from: data)
        let profile = Profile(response: response)
        return profile
    }
}

class LocalService {
    let userDefaults = UserDefaults(suiteName: "group.com.joyunhsu.todoTamagotchi")!
    let savedProfileKey = "SavedProfileKey"
    let savedLevelKey = "ProgressLevelIntKey"

    func getProfile() -> Profile? {
        guard let data = userDefaults.data(forKey: savedProfileKey) else { return nil }
        do {
            return try JSONDecoder().decode(Profile.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }

    func updateProfile(_ profile: Profile?) {
        guard let profile, let data = try? JSONEncoder().encode(profile) else {
            userDefaults.removeObject(forKey: savedProfileKey)
            userDefaults.removeObject(forKey: savedLevelKey)
            userDefaults.synchronize()
            return
        }
        userDefaults.set(data, forKey: savedProfileKey)
        userDefaults.setValue(profile.progressLevel, forKey: savedLevelKey)
        userDefaults.synchronize()
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

