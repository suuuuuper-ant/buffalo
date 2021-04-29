//
//  NewsFeedViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

// MARK: 뉴스피드 카테고리 타입
enum CategoryType: Int {
    case ALL = 0
    case FAVORITES = 1
}

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    @IBOutlet weak var feedTableView: UITableView!
    var refreshControl = UIRefreshControl()

    var type: Int = 0 //카테고리 타입
    var isLoaded = false { //통신 여부
        didSet {
            self.refreshContents()
        }
    }
    var selectedArray = [String]() //카테고리에 알맞는 데이터
    var selectedIndex = 0 //관심기업 index

    //FIXME: 임시 데이터
    let arr = ["전체", "네이버", "카카오", "라인", "쿠팡", "배민", "삼성", "LG"] //관심 기업 데이터
    var tableArr = [["전체", "Japan", "Korea"], //뉴스 피드 데이터
                    ["네이버", "Sudan", "South Africa"],
                    ["카카오", "Netherlands", "France"],
                    ["라인", "Netherlands", "France"],
                    ["쿠팡", "Netherlands", "France"],
                    ["배민", "Netherlands", "France"],
                    ["삼성", "Netherlands", "France"],
                    ["LG", "Netherlands", "France"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().sync {
            setup()

            //FIXME: 동작 테스트 (추후 삭제)
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                self.isLoaded = true
            })
        }
    }

    func setup() {
        selectedArray = tableArr[selectedIndex] //초기화

        //CollectioonView 세팅
        if type == CategoryType.ALL.rawValue {
            collectionViewHeight.constant = 0
        } else {
            menuCollectionView.delegate = self
            menuCollectionView.dataSource = self
            collectionViewHeight.constant = 50
        }

        //TableView 세팅
        feedTableView.delegate = self
        feedTableView.dataSource = self

        //RefreshControl
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        feedTableView.reloadData()
    }

    // MARK: 새로고침 메소드 - 스켈레톤 처리
    @objc func refresh() {
        self.isLoaded = false //초기화

        //FIXME: 동작 테스트 (추후 삭제)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.isLoaded = true
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            //loadServer()
        }
    }

    // MARK: 카테고리별 뉴스피드 갱신 메소드
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

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }

            cell.titleLabel.text = arr[indexPath.row]
            cell.makeRounded(cornerRadius: 20)

            if indexPath.item == selectedIndex {
                cell.titleLabel.textColor = UIColor.appColor(.white)
                cell.backView.backgroundColor = UIColor.appColor(.mainBlue)
            } else {
                cell.titleLabel.textColor = UIColor.appColor(.darkGrey2)
                cell.backView.backgroundColor = UIColor.appColor(.bgPurple)
            }

            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isLoaded = false //초기화
        selectedIndex = indexPath.item

        //FIXME: 동작 테스트 (추후 삭제)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.isLoaded = true
        })

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.reloadData()
    }

}

// MARK: - TableView
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    //FIXME: 추후 JSON 데이터에 맞게 수정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 6
        case 3:
            return 2
        default:
            return 0
        }
    }

    //FIXME: 추후 JSON 데이터에 맞게 수정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:

        if isLoaded {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell1.reuseIdentifier, for: indexPath) as? FeedTableViewCell1 else { return UITableViewCell() }

            cell.dateLabel.text = "연합뉴스 | 04. 17. 19:14"
            cell.titleLabel.text = "[단독] 세상엔 재밌는 것이 너무 많아요"
            cell.contentsLabel.text = "이지안(15개월.여)씨가 밥솥에 앞에서 투쟁을 벌이고 있..."

            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedSkeletonTableViewCell1.reuseIdentifier, for: indexPath) as? FeedSkeletonTableViewCell1 else { return UITableViewCell() }
            return cell
        }

        case 1:

            if isLoaded {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell2.reuseIdentifier, for: indexPath) as? FeedTableViewCell2 else { return UITableViewCell() }

                cell.titleLabel.text = "[단독] 세상엔 재밌는 것이 너무 많아요"
                cell.contentsLabel.text = "이지안(15개월.여)씨가 밥솥에 앞에서 투쟁을 벌이고 있..."

                return cell

            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedSkeletonTableViewCell2.reuseIdentifier, for: indexPath) as? FeedSkeletonTableViewCell2 else { return UITableViewCell() }
                return cell
            }

        case 2:

            if isLoaded {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell3.reuseIdentifier, for: indexPath) as? FeedTableViewCell3 else { return UITableViewCell() }

                cell.titleLabel.text = "쌍용차 10년만에 또 회생절차...”M&A 서두를 것”"

                return cell

            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedSkeletonTableViewCell3.reuseIdentifier, for: indexPath) as? FeedSkeletonTableViewCell3 else { return UITableViewCell() }
                return cell
            }

        case 3:

            if isLoaded {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell4.reuseIdentifier, for: indexPath) as? FeedTableViewCell4 else { return UITableViewCell() }

                cell.dateLabel.text = "연합뉴스 | 04. 17. 19:14"
                cell.titleLabel.text = "[단독] 세상엔 재밌는 것이 너무 많아요"

                return cell

            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedSkeletonTableViewCell4.reuseIdentifier, for: indexPath) as? FeedSkeletonTableViewCell4 else { return UITableViewCell() }
                return cell
            }

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier)

        detailVC.modalPresentationStyle = .formSheet

        self.present(detailVC, animated: true, completion: nil)
    }

}
