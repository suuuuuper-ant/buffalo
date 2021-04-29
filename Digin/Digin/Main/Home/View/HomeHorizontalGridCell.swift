//
//  HomeHorizontalGridCellCollectionViewCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/27.
//

import UIKit

class HomeHorizontalGridCell: UITableViewCell {
    let cellSize = CGSize(width: 335, height: 410)

    var companeis: [Company] = []
    var currentIndex: CGFloat = 0
    var isOneStepPaging = true
    var previousIndex = 0
    lazy var collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 335, height: 420)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(HomeGridCell.self, forCellWithReuseIdentifier: HomeGridCell.reuseIdentifier)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([collectionView])
        addConstraints()
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews(_ views: [UIView]) {
        for  view  in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
    }

    private func addConstraints() {

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func configure(with model: [Company]) {

        companeis = model
        DispatchQueue.main.async { [weak self] in

            self?.collectionView.reloadData()
        }

    }

}

extension HomeHorizontalGridCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companeis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGridCell.reuseIdentifier, for: indexPath) as? HomeGridCell
        let model = companeis[indexPath.row]
        cell?.configure(model: model)
        return cell ?? UICollectionViewCell()
    }
}

extension HomeHorizontalGridCell: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("pointee: \(targetContentOffset.pointee), offset: \(scrollView.contentOffset.x)")

        let scrollOffset: CGFloat = scrollView.contentOffset.x
        var offset = targetContentOffset.pointee

        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        //320 : 셀사이즈
        let cellWidthIncludingSpacing = cellSize.width + layout.minimumLineSpacing

        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        print("index: \(index)")
        let index2 = (scrollOffset + scrollView.contentInset.left) / cellWidthIncludingSpacing
        if index2 >= CGFloat(companeis.count - 1) {
            return
        }
        print("index2:\(index2), count : \(companeis.count)")
        var roundedIndex = round(index)
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)

        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {

            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }

        if currentIndex > roundedIndex {

            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {

            currentIndex += 1
            roundedIndex = currentIndex
        }

        if roundedIndex >= 1 {
            offset = CGPoint(x: (roundedIndex * cellWidthIncludingSpacing) - scrollView.contentInset.left - 5, y: -scrollView.contentInset.top)
            return  targetContentOffset.pointee = offset
        }

        offset = CGPoint(x: (roundedIndex * cellWidthIncludingSpacing) - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset

    }

}
