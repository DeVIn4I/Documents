//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Razumov Pavel on 09.07.2025.
//

import UIKit
import Photos

final class DocumentsViewController: UIViewController {
    
    private var documentsManager = DocumentsManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.tableHeaderView = UIView(frame: .zero)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "document.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addNewFile)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
        
        let image = UIImage(systemName: "document.badge.plus")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(addNewFile)
        )
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            fatalError()
        }
    }
    
    @objc
    private func addNewFile() {
        checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.present(picker, animated: true)
            } else {
                let alert = UIAlertController(
                    title: "Нет доступа к галерее",
                    message: "Разрешите доступ в настройках приложения",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "ОK", style: .default))
                alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                })
                self?.present(alert, animated: true)
            }
        }
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documentsManager.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let document = documentsManager.documents[indexPath.row]
        var config = UIListContentConfiguration.cell()
        
        config.text = document
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentConfiguration = config
        return cell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            if let fileName = self?.documentsManager.documents[indexPath.row] {
                self?.documentsManager.deleteImage(at: fileName)
            }
            tableView.reloadData()
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        defer {
            tableView.reloadData()
            dismiss(animated: true)
        }
        
        if let image = info[.originalImage] as? UIImage {
            documentsManager.saveImage(image)
        }
    }
}
