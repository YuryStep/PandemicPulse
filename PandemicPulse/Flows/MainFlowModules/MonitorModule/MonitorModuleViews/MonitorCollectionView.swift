//
//  MonitorCollectionView.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

protocol MonitorCollectionViewDelegate: AnyObject, UICollectionViewDelegate {
    func getNumberOfSections() -> Int
    func getSectionType(for sectionIndex: Int) -> MonitorCollectionView.Section
    func getItemsForSection(at sectionIndex: Int) -> [MonitorCollectionView.Item]
    func getNumberOfElementsInRow() -> Int
}

final class MonitorCollectionView: UICollectionView {
    enum Section: Hashable {
        case main(id: Int)
    }

    enum Item: Hashable {
        case person(PersonCell.DisplayData)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var monitorDataSource: DataSource!
    private var monitorCollectionViewDelegate: MonitorCollectionViewDelegate!

    init(frame: CGRect, delegate: MonitorCollectionViewDelegate) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        monitorCollectionViewDelegate = delegate
        setupCollection()
        setLayout()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollection() {
        register(PersonCell.self)
        delegate = monitorCollectionViewDelegate
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentInsetAdjustmentBehavior = .never
    }

    private func setLayout() {
        let itemsInRowCount = CGFloat(monitorCollectionViewDelegate.getNumberOfElementsInRow())

        let itemSize = getLayoutSizeToFitItems(count: itemsInRowCount)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)

        collectionViewLayout = layout
    }

    private func configureDataSource() {
        monitorDataSource = DataSource(collectionView: self) { collectionView, indexPath, itemIdentifier in
            let section = self.monitorDataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .main:
                let cell = collectionView.reuse(PersonCell.self, indexPath)
                if case let .person(personCellDisplayData) = itemIdentifier {
                    cell.configure(with: personCellDisplayData)
                }
                return cell
            }
        }
    }

    func applySnapshot(animatingDifferences: Bool) {
        var snapshot = Snapshot()
        let numberOfSections = monitorCollectionViewDelegate.getNumberOfSections()

        for sectionIndex in 0 ..< numberOfSections {
            let sectionType = monitorCollectionViewDelegate.getSectionType(for: sectionIndex)
            snapshot.appendSections([sectionType])

            let itemsForSection = monitorCollectionViewDelegate.getItemsForSection(at: sectionIndex)
            snapshot.appendItems(itemsForSection, toSection: sectionType)
        }
        monitorDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayoutSizeToFitItems(count itemsCount: CGFloat, aspectRatio: CGFloat = 1) -> NSCollectionLayoutSize {
        let screenSize = UIScreen.main.bounds.width
        let width = screenSize / itemsCount
        let height = width / aspectRatio
        let size = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        return size
    }
}
