//
//  HomeCoordinator.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import Foundation
import UIKit

class HomeCoordinator {
    var navigation: UINavigationController
    var appCoordinator: AppCoordinator?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let vc = ViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: vc, coordinator: self)
        
        vc.interactor = interactor
        interactor.presenter = presenter
        
        navigation.setViewControllers([vc], animated: false)
    }
    
    func performCoordinator() {
        print("perform coordinator")
    }
}
