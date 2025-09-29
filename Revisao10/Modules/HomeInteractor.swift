//
//  HomeInteractor.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import Foundation

final class HomeInteractor {
    var presenter: HomePresenter?
    
    func performInteractor() {
        print("Interactor")
        presenter?.performPresenter()
    }
}
