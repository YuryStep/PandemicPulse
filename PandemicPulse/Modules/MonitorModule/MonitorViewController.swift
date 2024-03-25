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

extension MonitorViewController {
    enum Section {
        case main
    }
}

final class MonitorViewController: UIViewController {

    // MARK: ds
    private var collectionView: UICollectionView!
        private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

        private let numberOfColumns = 4
        private let numberOfRows = 5

    private func configureCollectionView() {
            let layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.backgroundColor = .white
            collectionView.alwaysBounceVertical = true
            collectionView.alwaysBounceHorizontal = true
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(collectionView)

            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            collectionView.addGestureRecognizer(pinchGesture)

            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            collectionView.addGestureRecognizer(panGesture)
        }

        private func configureDataSource() {
            dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                cell.backgroundColor = .systemBlue
                return cell
            }

            var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
            initialSnapshot.appendSections([.main])
            initialSnapshot.appendItems(Array(0..<(numberOfRows * numberOfColumns)))
            dataSource.apply(initialSnapshot, animatingDifferences: false)
        }

        @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
            guard gesture.view != nil else { return }

            if gesture.state == .changed {
                let scale = gesture.scale
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                collectionView.transform = transform
            }
        }

        @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: collectionView)

            if gesture.state == .changed {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x - translation.x, y: collectionView.contentOffset.y - translation.y)
                gesture.setTranslation(.zero, in: collectionView)
            }
        }



    var presenter: MonitorPresenterProtocol!

//    private lazy var collectionView: MonitorCollectionView = {
//        let collectionView = MonitorCollectionView(frame: .zero, delegate: self)
//        return collectionView
//    }()

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemPink
        activityIndicator.style = .large
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
        setupView()
//        showLoadingIndicator()
        hideLoadingIndicator()
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubviews([collectionView, loadingIndicator])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
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
        print("updateSnapshot")
    }
}

extension MonitorViewController: MonitorCollectionViewDelegate {
    func getPersonCellDisplayData() -> [MonitorCollectionView.Item] {
        presenter.getPersonCellDisplayData()
    }
}
