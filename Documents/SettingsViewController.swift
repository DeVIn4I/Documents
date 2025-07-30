//
//  SettingsViewController.swift
//  Documents
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let userSettings = UserSettings.shared
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сортировка"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Обратный/Алфавитный"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switchSort: UISwitch = {
        let switchSort = UISwitch()
        switchSort.addTarget(self, action: #selector(switchSortChanged), for: .valueChanged)
        switchSort.translatesAutoresizingMaskIntoConstraints = false
        return switchSort
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить пароль", for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapChangePasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        [
            titleLabel, sortLabel,
            switchSort, changePasswordButton
        ].forEach { view.addSubview($0) }
        
        switchSort.isOn = userSettings.isAscendingSort()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        sortLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        switchSort.snp.makeConstraints {
            $0.centerY.equalTo(sortLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        changePasswordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(48)
            $0.height.equalTo(44)
        }
    }
    
    @objc
    private func switchSortChanged() {
        if switchSort.isOn {
            userSettings.setAscendingSort(true)
        } else {
            userSettings.setAscendingSort(false)
        }
    }
    
    @objc
    private func didTapChangePasswordButton() {
        let vc = ChangePasswordViewController()
        present(vc, animated: true)
    }
}
