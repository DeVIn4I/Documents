//
//  ChangePasswordViewController.swift
//  Documents
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit

final class ChangePasswordViewController: UIViewController {
    
    private let userSettings = UserSettings.shared
    
    private lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.textColor = .red
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(newPasswordTextFieldEditing), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Новый пароль", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(didTapPasswordButton), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newPasswordTextField, passwordButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(passwordStackView)
        
        passwordStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(34)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.12)
        }
    }
    
    @objc
    private func didTapPasswordButton() {
        guard let password = newPasswordTextField.text else { return }
        
        userSettings.setPassword(password)
        newPasswordTextField.text = nil
        passwordButton.isEnabled = false
        
        dismiss(animated: true)
    }
    
    @objc
    private func newPasswordTextFieldEditing(sender: UITextField) {
        if let text = sender.text,
           text.count >= 4 {
            sender.textColor = .label
            passwordButton.isEnabled = true
        } else {
            sender.textColor = .red
            passwordButton.isEnabled = false
        }
    }
}
