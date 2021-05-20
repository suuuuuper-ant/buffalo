//
//  DetailsCategoryTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit

class DetailsCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var actionClosure: ((CategoryResult) -> Void)?

    // - 카테고리
    var categoryData = [CategoryResult]()

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self

        getCategoryData()
    }

}

//TODO: 서버통신
// MARK: - CollectionView
extension DetailsCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailsCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.titleLabel.text = categoryData[indexPath.row].name
        cell.logoImageView.image = UIImage(named: categoryData[indexPath.row].img)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //print(indexPath.item)
        self.actionClosure?(categoryData[indexPath.item])
    }

}

// MARK: - Networking
extension DetailsCategoryTableViewCell {

    //카테고리 데이터 로드
    func getCategoryData() {

        CategoryService.getCategory { (result) in
            self.categoryData = result
            self.collectionView.reloadData()
        }
    }
}
