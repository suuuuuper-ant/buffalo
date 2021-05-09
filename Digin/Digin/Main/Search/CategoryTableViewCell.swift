//
//  CategoryTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/03.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var actionClosure: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

//TODO: 서버통신
// MARK: - CollectionView
extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.titleLabel.text = "에너지"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //print(indexPath.item)
        self.actionClosure?(indexPath.item)
    }

}
