//
//  NewsFeedViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    var selectedArray = [String]()
    var selectedIndex = 0

    @IBOutlet weak var feedTableView: UITableView!
    var isLoaded = false {
        didSet {
            self.refreshContents()
        }
    }

    //FIXME: 임시 데이터
    let arr = ["전체", "네이버", "카카오", "라인", "쿠팡", "배민", "삼성", "LG"]

    var tableArr = [["전체", "Japan", "Korea"],
                    ["네이버", "Sudan", "South Africa"],
                    ["카카오", "Netherlands", "France"],
                    ["라인", "Netherlands", "France"],
                    ["쿠팡", "Netherlands", "France"],
                    ["배민", "Netherlands", "France"],
                    ["삼성", "Netherlands", "France"],
                    ["LG", "Netherlands", "France"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        selectedArray = tableArr[selectedIndex] //초기화

        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        feedTableView.delegate = self
        feedTableView.dataSource = self

        //FIXME: 동작 테스트 (추후 삭제)
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
            print("FIRE!!!")
            self.isLoaded = true

        })
    }

    //카테고리에 알맞는 뉴스피드 갱신 메소드
    private func refreshContents() {
        selectedArray = tableArr[selectedIndex]
        feedTableView.reloadData()
    }

}

// MARK: - CollectionView
extension NewsFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }

            cell.titleLabel.text = arr[indexPath.row]
            return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.isLoaded = false //초기화
        selectedIndex = indexPath.item

        //FIXME: 동작 테스트 (추후 삭제)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            print("FIRE!!!")
            self.isLoaded = true
            self.refreshContents()

        })

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

}

// MARK: - TableView
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isLoaded {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }

            cell.titleLabel.text = selectedArray[indexPath.row]
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.reuseIdentifier, for: indexPath) as? SkeletonTableViewCell else { return UITableViewCell() }

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier)

        detailVC.modalPresentationStyle = .formSheet

        self.present(detailVC, animated: true, completion: nil)
    }

}
