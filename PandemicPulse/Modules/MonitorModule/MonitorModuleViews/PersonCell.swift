//
//  PersonCell.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 25.03.2024.
//

import UIKit

final class PersonCell: UICollectionViewCell {
    struct DisplayData: Equatable, Hashable {
        let id = UUID()
        let isInfected: Bool
    }

    private enum Constants {
        static let iconName = "figure.stand"
        static let iconSize: CGFloat = 20
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    func configure(with displayData: DisplayData) {
        let color: UIColor = displayData.isInfected ? .systemRed : .systemGreen
        setIconImage(with: color)
    }

    private func setIconImage(with color: UIColor) {
        let size = Constants.iconSize
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .regular, scale: .default)
        var image = UIImage(systemName: Constants.iconName, withConfiguration: configuration)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        imageView.image = image
    }

    private func setupSubviews() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
