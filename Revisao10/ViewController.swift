//
//  ViewController.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    var interactor: HomeInteractor?
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Print", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "Home Coordinator"
        view.backgroundColor = .systemBackground
        
        button.addTarget(self, action: #selector(handlePrint), for: .touchUpInside)
        
        [button].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func handlePrint(){
        print("Chamando handle")
        interactor?.performInteractor()
    }
}

