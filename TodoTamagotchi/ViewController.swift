//
//  ViewController.swift
//  TodoTamagotchi
//
//  Created by Jo Hsu on 2024/2/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "pixelCat", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView = UIImageView(image: advTimeGif)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
    


}

