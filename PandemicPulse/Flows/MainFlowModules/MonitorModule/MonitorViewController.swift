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
        headerView.configure(with: presenter.getHeaderDisplayData())
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var collectionView: MonitorCollectionView = {
        let collectionView = MonitorCollectionView(frame: .zero, delegate: self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }

    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationItemTitleText
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(didTapOnBackButton))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func didTapOnBackButton() {
        presenter.didTapOnBackButton()
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubviews([headerView, collectionView])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: guide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MonitorViewController: MonitorViewProtocol {
    func renderUserInterface() {
        collectionView.applySnapshot(animatingDifferences: false)
        headerView.configure(with: presenter.getHeaderDisplayData())
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
