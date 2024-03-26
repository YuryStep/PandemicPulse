//
//  MonitorViewController.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

protocol MonitorViewProtocol: AnyObject {
    func renderUserInterface()
}

final class MonitorViewController: UIViewController {
    private enum Constants {
        static let navigationItemTitleText = "Симуляция эпидемии"
    }

    var presenter: MonitorPresenterProtocol!

    private lazy var headerView: MonitorHeaderView = {
        let headerView = MonitorHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var collectionView: MonitorCollectionView = {
        let collectionView = MonitorCollectionView(frame: .zero, delegate: self)
        return collectionView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemPink
        activityIndicator.style = .large
        return activityIndicator
    }()

    deinit {
        print("😀")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }

    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationItemTitleText
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        presenter.backButtonTapped()
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubviews([headerView, collectionView, loadingIndicator])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: guide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showLoadingIndicator() {
        collectionView.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        collectionView.isHidden = false
    }
}

extension MonitorViewController: MonitorViewProtocol {
    func renderUserInterface() {
        collectionView.applySnapshot(animatingDifferences: false)
    }
}

extension MonitorViewController: MonitorCollectionViewDelegate {
    func getNumberOfSections() -> Int {
        presenter.getNumberOfSections()
    }

    func getSectionType(for sectionIndex: Int) -> MonitorCollectionView.Section {
        presenter.getSectionType(for: sectionIndex)
    }

    func getItemsForSection(at sectionIndex: Int) -> [MonitorCollectionView.Item] {
        presenter.getItemsForSection(at: sectionIndex)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapOnElement(at: indexPath)
    }

    func getNumberOfElementsInRow() -> Int {
        presenter.getNumberOfElementsInRow()
    }
}
