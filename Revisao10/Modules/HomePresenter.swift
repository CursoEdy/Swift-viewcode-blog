//
//  HomePresenter.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import Foundation

final class HomePresenter {
    weak var view: ViewController?
    weak var coordinator: HomeCoordinator?
    
    init(view: ViewController?, coordinator: HomeCoordinator?){
        self.view = view
        self.coordinator = coordinator
    }
    
    func performPresenter() {
        print("Presenter")
        coordinator?.performCoordinator()
    }
}
