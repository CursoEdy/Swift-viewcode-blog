//
//  LoginViewController.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//
import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    var onLoginSuccess: (() -> Void)?

    // UI
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "EducaHub"
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textAlignment = .center
        return l
    }()
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let roleSegment = UISegmentedControl(items: ["Estudante","Professor"])
    private let actionButton = UIButton(type: .system)
    private let toggleButton = UIButton(type: .system)
    private var isRegistering = false

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Login"
    }
    required init?(coder: NSCoder) { fatalError("init(coder:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        configureForLogin()
    }

    private func setupViews() {
        [titleLabel, nameField, emailField, passwordField, roleSegment, actionButton, toggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        nameField.placeholder = "Nome (apenas no cadastro)"
        emailField.placeholder = "Email"
        passwordField.placeholder = "Senha"
        passwordField.isSecureTextEntry = true
        roleSegment.selectedSegmentIndex = 0

        actionButton.setTitle("Entrar", for: .normal)
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        toggleButton.setTitle("Ainda não tem conta? Cadastre-se", for: .normal)
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 44),

            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            roleSegment.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            roleSegment.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            roleSegment.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),

            actionButton.topAnchor.constraint(equalTo: roleSegment.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 48),

            toggleButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 12),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureForLogin() {
        isRegistering = false
        nameField.isHidden = true
        roleSegment.isHidden = true
        actionButton.setTitle("Entrar", for: .normal)
        toggleButton.setTitle("Ainda não tem conta? Cadastre-se", for: .normal)
    }

    private func configureForRegister() {
        isRegistering = true
        nameField.isHidden = false
        roleSegment.isHidden = false
        actionButton.setTitle("Cadastrar", for: .normal)
        toggleButton.setTitle("Já tenho conta", for: .normal)
    }

    @objc private func didTapToggle() {
        isRegistering.toggle()
        if isRegistering { configureForRegister() } else { configureForLogin() }
    }

    @objc private func didTapAction() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""

        if isRegistering {
            let name = nameField.text ?? ""
            let role: Role = roleSegment.selectedSegmentIndex == 1 ? .teacher : .student
            viewModel.register(name: name, email: email, password: password, role: role) { [weak self] res in
                DispatchQueue.main.async {
                    switch res {
                    case .success:
                        self?.onLoginSuccess?()
                    case .failure(let err):
                        self?.showAlert("Erro", message: "\(err)")
                    }
                }
            }
        } else {
            viewModel.login(email: email, password: password) { [weak self] res in
                DispatchQueue.main.async {
                    switch res {
                    case .success:
                        self?.onLoginSuccess?()
                    case .failure:
                        self?.showAlert("Erro", message: "Email ou senha inválidos")
                    }
                }
            }
        }
    }

    private func showAlert(_ title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(.init(title: "OK", style: .default))
        present(a, animated: true)
    }
}
