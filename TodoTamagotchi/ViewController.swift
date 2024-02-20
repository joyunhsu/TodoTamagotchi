//
//  ViewController.swift
//  TodoTamagotchi
//
//  Created by Jo Hsu on 2024/2/20.
//

import Combine
import UIKit

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

    let petShadowView: UIView = {
        let petShadowView = UIView()
        petShadowView.translatesAutoresizingMaskIntoConstraints = false
        petShadowView.backgroundColor = .black
        petShadowView.alpha = 0.3
        petShadowView.transform = .init(scaleX: 1, y: 0.3)
        petShadowView.widthAnchor.constraint(equalTo: petShadowView.heightAnchor).isActive = true
        return petShadowView
    }()

    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.numberOfLines = 0
        descLabel.text = "Desc"
        descLabel.backgroundColor = .init(white: 1, alpha: 0.7)
        return descLabel
    }()

    let floorView: UIView = {
        let floorView = UIView()
        floorView.translatesAutoresizingMaskIntoConstraints = false
        floorView.backgroundColor = .brown
        return floorView
    }()

    let skyView: UIView = {
        let skyView = UIView()
        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.backgroundColor = .blue
        return skyView
    }()

    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton()
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.backgroundColor = .gray
        refreshBtn.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return refreshBtn
    }()

    let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
        return loadingView
    }()

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()

        view.addSubview(petView)
        petView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        petView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        petView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        petView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        view.addSubview(petShadowView)
        view.sendSubviewToBack(petShadowView)
        petShadowView.centerYAnchor.constraint(equalTo: petView.centerYAnchor, constant: 100).isActive = true
        petShadowView.leadingAnchor.constraint(equalTo: petView.leadingAnchor).isActive = true
        petShadowView.trailingAnchor.constraint(equalTo: petView.trailingAnchor).isActive = true

        view.addSubview(descLabel)
        descLabel.centerXAnchor.constraint(equalTo: petView.centerXAnchor).isActive = true
        descLabel.centerYAnchor.constraint(equalTo: petShadowView.centerYAnchor, constant: 100).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        view.addSubview(floorView)
        view.sendSubviewToBack(floorView)
        floorView.topAnchor.constraint(equalTo: petView.centerYAnchor, constant: 50).isActive = true
        floorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        floorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        floorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(skyView)
        view.sendSubviewToBack(skyView)
        skyView.frame = UIScreen.main.bounds

        view.addSubview(refreshBtn)
        refreshBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        refreshBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true

        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: refreshBtn.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: refreshBtn.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: refreshBtn.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: refreshBtn.trailingAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        petShadowView.layer.cornerRadius = petShadowView.bounds.width / 2
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
                profile = try await remoteService.updateProfile()
                loadingView.stopAnimating()
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
    enum Lifecycle: Decodable {
        case egg
        case crackedEgg
        case chick
        case fledgling
        case grownChicken
        case finishLineChicken

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
            case .finishLineChicken:
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

        switch completeness {
        case 0.7 ..< 1:
            self.lifecycle = .grownChicken
        case 0.5 ..< 0.7:
            self.lifecycle = .fledgling
        case 0.3 ..< 0.5:
            self.lifecycle = .chick
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
        return try JSONDecoder().decode(Profile.self, from: data)
    }

    func updateProfile() async throws -> Profile {
        let url = URL(string: "https://sprint-tamagotchi.vercel.app/api/snapshots?value=8.35")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let (data, _) = try await URLSession.shared.data(for: request)
        String(data: data, encoding: .utf8).map { print($0) }
        return try JSONDecoder().decode(Profile.self, from: data)
    }
}

