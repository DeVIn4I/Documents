//
//  SecurityViewController.swift
//  Documents
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit
import SnapKit

enum PasswordState {
    case create
    case confirm
    case verify
}

final class SecurityViewController: UIViewController {
    
    private let userSettings = UserSettings.shared
    private var state: PasswordState = .create
    private var tempPassword: String?
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.textColor = .red
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(passwordTextFieldEditing), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать пароль", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(didTapPasswordButton), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField, passwordButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(passwordStackView)
        
        if userSettings.getPassword() == nil {
            passwordButton.setTitle("Создать пароль", for: .normal)
            state = .create
        } else {
            passwordButton.setTitle("Введите пароль", for: .normal)
            state = .verify
        }
    }
    
    private func setConstraints() {
        passwordStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(34)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.12)
        }
    }
    
    private func resetState() {
        tempPassword = nil
        state = .create
        passwordTextField.text = nil
        passwordButton.setTitle("Создать пароль", for: .normal)
        passwordButton.isEnabled = false
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    private func didTapPasswordButton() {
        guard let password = passwordTextField.text else { return }
        
        switch state {
        case .create:
            tempPassword = password
            passwordTextField.text = nil
            passwordButton.isEnabled = false
            state = .confirm
            passwordButton.setTitle("Повторите пароль", for: .normal)
        case .confirm:
            if tempPassword == password {
                userSettings.setPassword(password)
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            } else {
                showAlert(message: "Не удалось подтвердить пароль. Попробуйте еще раз.")
                resetState()
            }
        case .verify:
            if password == userSettings.getPassword() {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            } else {
                showAlert(message: "Введен неверный пароль!")
                passwordTextField.text = nil
                passwordButton.isEnabled = false
            }
        }
    }
    
    @objc
    private func passwordTextFieldEditing(sender: UITextField) {
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
