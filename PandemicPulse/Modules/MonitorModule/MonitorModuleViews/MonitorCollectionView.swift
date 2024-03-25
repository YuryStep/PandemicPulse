//
//  MonitorCollectionView.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

protocol MonitorCollectionViewDelegate: AnyObject, UICollectionViewDelegate {
    func getPersonCellDisplayData() -> [MonitorCollectionView.Item]
}

final class MonitorCollectionView: UICollectionView {
    private enum Constants {
        static let timelineHeaderKind = "timelineHeaderKind"
        static let cityItemPadding: CGFloat = 25
        static let cityItemSpacing: CGFloat = 25
        static let cityItemAspectRatio = 0.8
        static let timelineItemPadding: CGFloat = 25
        static let timelineItemSpacing: CGFloat = 25
        static let timelineItemAspectRatio = 0.75
    }

    enum Section: Int {
        case main
    }

    enum Item: Hashable {
        case person(PersonCell.DisplayData)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
//    private typealias MainHeaderRegistration = UICollectionView.SupplementaryRegistration<MainHeaderView>

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

    private func configureDataSource() {
        monitorDataSource = DataSource(collectionView: self) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("Failed to initialize Section in DataSource")
                return UICollectionViewCell()
            }

            switch section {
            case .main:
                let cell = collectionView.reuse(PersonCell.self, indexPath)
                if case let .person(personCellDisplayData) = itemIdentifier {
                    cell.configure(with: personCellDisplayData)
                }
                return cell
            }
        }

//        let supplementaryRegistration = TimelineHeaderRegistration(elementKind: Constants.timelineHeaderKind) { _, _, _ in }

//        monitorDataSource.supplementaryViewProvider = { _, _, index in
//            self.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
//        }
    }

    private func setLayout() {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self, let section = Section(rawValue: sectionIndex) else {
                assertionFailure("Failed to initialize Section in SectionProvider")
                return nil
            }
            switch section {
            case .main: return createMainSectionLayout()
            }
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        collectionViewLayout = layout
    }

//    private func createMainSectionLayout() -> NSCollectionLayoutSection {
//        // Рассчитываем размеры элемента на основе размера родительской области
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        // Создаем группу из трёх элементов
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
//
//        // Создаем раздел и устанавливаем промежутки и отступы
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .none // TODO: SCROLLING
//        section.interGroupSpacing = Constants.timelineItemSpacing
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
//                                                        leading: Constants.timelineItemPadding,
//                                                        bottom: 0,
//                                                        trailing: Constants.timelineItemPadding)
//
//        return section
//    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }


    private func createMainSectionLayout() -> NSCollectionLayoutSection {
        let dynamicSize = getLayoutSizeToFitItems(count: 4,
                                                  padding: Constants.timelineItemPadding,
                                                  spacing: Constants.timelineItemSpacing,
                                                  aspectRatio: Constants.timelineItemAspectRatio)

        let item = NSCollectionLayoutItem(layoutSize: .fitToParent)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: dynamicSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none // TODO: SCROLLING
        section.interGroupSpacing = Constants.timelineItemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: Constants.timelineItemPadding,
                                                        bottom: 0,
                                                        trailing: Constants.timelineItemPadding)

//        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .estimated(44))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: titleSize,
//            elementKind: Constants.timelineHeaderKind,
//            alignment: .topLeading
//        )
//        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    func applySnapshot(animatingDifferences: Bool) {
        let personItem = monitorCollectionViewDelegate.getPersonCellDisplayData()

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(personItem, toSection: .main)

        monitorDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayoutSizeToFitItems(count itemsCount: CGFloat, padding: CGFloat, spacing: CGFloat, aspectRatio: CGFloat) -> NSCollectionLayoutSize {
        let width = (frame.width - spacing) / itemsCount - padding
        let height = width / aspectRatio
        let size = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        return size
    }
}
