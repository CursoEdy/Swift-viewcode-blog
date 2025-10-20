//
//  CreatePostViewController.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import UIKit

final class CreatePostViewController: UIViewController {
    private let viewModel: CreatePostViewModel
    var onSaved: (() -> Void)?

    private let titleField = UITextField()
    private let categoriesField = UITextField()
    private let textView = UITextView()
    private let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    private let draftSwitch = UISwitch()

    init(viewModel: CreatePostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Criar material"
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }

    private func setup() {
        navigationItem.rightBarButtonItem = saveButton
        saveButton.target = self
        saveButton.action = #selector(didTapSave)

        [titleField, categoriesField, textView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        titleField.placeholder = "Título"
        titleField.borderStyle = .roundedRect
        categoriesField.placeholder = "Categorias (separadas por vírgula)"
        categoriesField.borderStyle = .roundedRect
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)

        let draftLabel = UILabel()
        draftLabel.text = "Salvar como rascunho"
        draftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(draftLabel)
        draftSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(draftSwitch)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleField.heightAnchor.constraint(equalToConstant: 44),

            categoriesField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 12),
            categoriesField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            categoriesField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            categoriesField.heightAnchor.constraint(equalToConstant: 44),

            draftLabel.topAnchor.constraint(equalTo: categoriesField.bottomAnchor, constant: 12),
            draftLabel.leadingAnchor.constraint(equalTo: categoriesField.leadingAnchor),

            draftSwitch.centerYAnchor.constraint(equalTo: draftLabel.centerYAnchor),
            draftSwitch.leadingAnchor.constraint(equalTo: draftLabel.trailingAnchor, constant: 8),

            textView.topAnchor.constraint(equalTo: draftLabel.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapSave() {
        let title = titleField.text ?? ""
        let content = textView.text ?? ""
        let categories = categoriesField.text?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
        let isDraft = draftSwitch.isOn

        guard !title.isEmpty, !content.isEmpty else {
            showAlert("Erro", message: "Preencha título e conteúdo")
            return
        }

        viewModel.createPost(title: title, content: content, categories: categories, isDraft: isDraft) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    self?.onSaved?()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let err):
                    self?.showAlert("Erro", message: "\(err)")
                }
            }
        }
    }

    private func showAlert(_ t: String, message: String) {
        let a = UIAlertController(title: t, message: message, preferredStyle: .alert)
        a.addAction(.init(title: "OK", style: .default))
        present(a, animated: true)
    }
}

