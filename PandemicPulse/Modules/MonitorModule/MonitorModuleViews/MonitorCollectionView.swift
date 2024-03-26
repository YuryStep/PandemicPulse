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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(44),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
    
        let padding = (UIScreen.main.bounds.width - (44 * 9)) / 2
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)

        let section = NSCollectionLayoutSection(group: group)

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

        for sectionIndex in 0..<numberOfSections {
            let sectionType = monitorCollectionViewDelegate.getSectionType(for: sectionIndex)
            snapshot.appendSections([sectionType])

            let itemsForSection = monitorCollectionViewDelegate.getItemsForSection(at: sectionIndex)
            snapshot.appendItems(itemsForSection, toSection: sectionType)
        }
        monitorDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayoutSizeToFitItems(count itemsCount: CGFloat, padding: CGFloat, spacing: CGFloat, aspectRatio: CGFloat) -> NSCollectionLayoutSize {
        let width = (frame.width - spacing) / itemsCount - padding
        let height = width / aspectRatio
        let size = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        return size
    }
}
