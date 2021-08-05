//
//  HomeHorizontalGridCellCollectionViewCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/27.
//

import UIKit
import Combine

class HomeHorizontalGridCell: UITableViewCell {
    private var cancellables: Set<AnyCancellable> = []
    @Published var didSelectItem: IndexPath?
    let cellSize = CGSize(width: 335, height: 412)
    var companeis: [HomeUpdatedCompany] = []
    var currentIndex: CGFloat = 0
    var isOneStepPaging = true
    var previousIndex = 0
    lazy var collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 335, height: 410)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(named: "home_background")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HomeGridCell.self, forCellWithReuseIdentifier: HomeGridCell.reuseIdentifier)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let backContenView = UIView()

    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        control.pageIndicatorTintColor = UIColor.init(named: "main_color")?.withAlphaComponent(0.2)
        control.currentPageIndicatorTintColor = UIColor.init(named: "main_color")
        return control
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([backContenView])
        addConstraints()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)

    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if newValue.width == 0 { return }
            super.frame = newValue
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews(_ views: [UIView]) {
        for  view  in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        backContenView.backgroundColor = UIColor.init(named: "home_background")
        backContenView.addSubview(collectionView)
        backContenView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addConstraints() {

        backContenView.fittingView(self.contentView)

        collectionView.leadingAnchor.constraint(equalTo: backContenView.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: backContenView.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: backContenView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 430).isActive = true

        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: backContenView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 5).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: backContenView.bottomAnchor, constant: 0).isActive = true
    }

    func configure(with model: [HomeUpdatedCompany], parentViewModel: HomeViewModel) {

        companeis = model
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.pageControl.numberOfPages = self.companeis.count < 5 ? self.companeis.count : 5
            self.collectionView.reloadData()
        }

        $didSelectItem.sink(receiveValue: { indexPath in parentViewModel.moveToDetailPage(indexPath)}).store(in: &cancellables)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables =  []
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem = indexPath

    }

}

extension HomeHorizontalGridCell: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let scrollOffset: CGFloat = scrollView.contentOffset.x
        var offset = targetContentOffset.pointee

        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        //320 : 셀사이즈
        let cellWidthIncludingSpacing = cellSize.width + layout.minimumLineSpacing

        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let index2 = (scrollOffset + scrollView.contentInset.left) / cellWidthIncludingSpacing
        if index2 >= CGFloat(companeis.count - 1) {
            return
        }

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
            self.pageControl.currentPage =  Int(roundedIndex)
            return  targetContentOffset.pointee = offset
        }

        offset = CGPoint(x: (roundedIndex * cellWidthIncludingSpacing) - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        self.pageControl.currentPage =  Int(roundedIndex)

    }

}
