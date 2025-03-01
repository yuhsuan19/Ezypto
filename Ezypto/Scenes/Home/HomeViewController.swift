//
//  HomeViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    

}

// MARK: - Private functions
extension HomeViewController {
    private func setUpViews() {
        view.backgroundColor = .white
        title = "Home"
    }
}
