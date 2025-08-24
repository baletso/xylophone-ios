//
//  LaunchViewController.swift
//  Xylophone
//
//  Created by Bárbara Letelier on 22-08-25.
//

import UIKit

final class LaunchViewController: UIViewController {
    private let minDisplayTime: TimeInterval = 1.0

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "BrandBackground") ?? .systemBlue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // opcional: también aquí, por redundancia
        view.backgroundColor = UIColor(named: "BrandBackground") ?? .systemBlue
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + minDisplayTime) { [weak self] in
            self?.performSegue(withIdentifier: "goXylophone", sender: nil)
        }
    }
}
