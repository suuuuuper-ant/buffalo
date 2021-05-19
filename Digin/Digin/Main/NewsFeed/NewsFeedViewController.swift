//
//  NewsFeedViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit
import Foundation

// MARK: 뉴스피드 카테고리 타입
enum CategoryType: Int {
    case ALL = 0
    case FAVORITES = 1
}

class NewsFeedViewController: UIViewController, APIServie {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var feedTableView: UITableView!

    //skeleton
    var isLoad = true
    var isFirstLoad = true

    var viewType: Int = 0
    var selectedIndex = 0 //관심기업 index

    //network data
    var allNewsData = NewsfeedResult()
    var companyList = [CompanyResult]()
    var companyNewsData = NewsfeedResult()

    //tableview data
    var section0Contents: [NewsfeedContent] = [NewsfeedContent]()
    var section1Contents: [NewsfeedContent] = [NewsfeedContent]()
    var section2Contents: [NewsfeedContent] = [NewsfeedContent]()
    var contents: [NewsfeedContent] = [NewsfeedContent]()

    //Paging
    var currentPage = 0
    var hasNextPage = true
    var isPaging = false

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        getAllNews()
        getCompanyList()

        initRefresh()
    }

    func setup() {

        //CollectioonView 세팅
        if viewType == CategoryType.ALL.rawValue {
            collectionViewHeight.constant = 0
        } else {
            menuCollectionView.delegate = self
            menuCollectionView.dataSource = self
            collectionViewHeight.constant = 50
        }

        //TableView 세팅
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.tableFooterView = UIView(frame: .zero)

        //loading cell
        let nibName = UINib(nibName: LoadingTableViewCell.reuseIdentifier, bundle: nil)
        feedTableView.register(nibName, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)

        feedTableView.reloadData()
    }

    func initRefresh() {
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    // MARK: 새로고침 메소드 - 스켈레톤 처리
    @objc func refresh() {
        refreshControl.endRefreshing()
        resetData()
        if viewType == 0 || selectedIndex == 0 { getAllNews() } else { getCompanyNews() }
        getCompanyList()
    }
}

// MARK: - CollectionView
extension NewsFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }

            if indexPath.item == 0 {
                cell.titleLabel.text = "전체"
            } else {
                cell.titleLabel.text = companyList[indexPath.row].name
            }

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
        resetData() //데이터 초기화
        selectedIndex = indexPath.item //선택 기업 갱신

        if indexPath.item == 0 { getAllNews() } else { getCompanyNews() }

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.reloadData()
    }

    func resetData() {
        section0Contents.removeAll()
        section1Contents.removeAll()
        section2Contents.removeAll()
        contents.removeAll()

        currentPage = 0
        hasNextPage = true
    }
}

// MARK: - TableView
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 { return section0Contents.count } // 1
        if section == 1 { return section1Contents.count } // 2
        if section == 2 { return section2Contents.count } // 6
        if section == 3 { return contents.count }
        if section == 4 && isPaging && hasNextPage { return 1 }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell1.reuseIdentifier, for: indexPath) as? FeedTableViewCell1 else { return UITableViewCell() }

            if !isLoad {
                setSkeleton(sender: cell.dateLabel)
                setSkeleton(sender: cell.titleLabel)
                setSkeleton(sender: cell.contentsLabel)
            } else {
                cell.dateLabel.text = section0Contents[indexPath.row].createdAt
                cell.titleLabel.text = section0Contents[indexPath.row].title
                cell.contentsLabel.text = section0Contents[indexPath.row].description
            }

            return cell

        case 1:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell2.reuseIdentifier, for: indexPath) as? FeedTableViewCell2 else { return UITableViewCell() }

            if !isLoad {
                setSkeleton(sender: cell.titleLabel)
                setSkeleton(sender: cell.contentsLabel)
            } else {
                cell.titleLabel.text = section1Contents[indexPath.row].title
                cell.contentsLabel.text = section1Contents[indexPath.row].description
            }

            return cell

        case 2:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell3.reuseIdentifier, for: indexPath) as? FeedTableViewCell3 else { return UITableViewCell() }

            if !isLoad {
                setSkeleton(sender: cell.titleLabel)
            } else {
                cell.titleLabel.text = section2Contents[indexPath.row].title
            }

            return cell

        case 3:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell4.reuseIdentifier, for: indexPath) as? FeedTableViewCell4 else { return UITableViewCell() }

            if !isLoad {
                setSkeleton(sender: cell.dateLabel)
                setSkeleton(sender: cell.titleLabel)
            } else {
                cell.dateLabel.text = contents[indexPath.row].createdAt
                cell.titleLabel.text = contents[indexPath.row].title
            }

            return cell

        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }

            cell.start()

            return cell

        default:
            return UITableViewCell()
        }
    }

    //섹션마다 매칭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController

        if indexPath.section == 0 { webVC.newsURL = section0Contents[indexPath.row].link }
        if indexPath.section == 1 { webVC.newsURL = section1Contents[indexPath.row].link }
        if indexPath.section == 2 { webVC.newsURL = section2Contents[indexPath.row].link }
        if indexPath.section == 3 { webVC.newsURL = contents[indexPath.row].link }

        webVC.modalPresentationStyle = .formSheet
        self.present(webVC, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage {
                currentPage += 1
                beginPaging()
            }
        }
    }

    func beginPaging() {
        isPaging = true // 현재 페이징이 진행 되는 것을 표시

        // Section 1을 reload하여 로딩 셀을 보여줌 (페이징 진행 중인 것을 확인할 수 있도록)
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }

        // 페이징 메소드 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getAllNews()
        }
    }
}

// MARK: - Networking API
extension NewsFeedViewController {

    // GET - /news (전체 뉴스)
    func getAllNews() {
        NewsfeedService.getNewsData(pageNumber: currentPage) { (result) in

            print(result.pageable.pageNumber)
            if result.first { //첫 페이지
                self.allNewsData = result

                // - 고정 데이터
                self.section0Contents.append(result.content[0]) //섹션0
                for index in 1..<3 { //섹션1
                    self.section1Contents.append(result.content[index])
                }
                for index in 3..<9 { //섹션2
                    self.section2Contents.append(result.content[index])
                }
                // - 페이징 데이터
                for index in 9..<result.content.count {
                    self.contents.append(result.content[index])
                }

            } else {
                for index in 0..<result.content.count {
                    self.contents.append(result.content[index])
                }
            }

            if result.last { self.hasNextPage = false } //페이징 종료

            DispatchQueue.main.async(execute: {
                self.isPaging = false
                self.feedTableView.reloadData()
            })
        }
    }

    // GET - /accounts/favorites (관심 기업)
    func getCompanyList() {
        NewsfeedService.getFavorites { (result) in
            self.companyList = result

            DispatchQueue.main.async(execute: {
                self.menuCollectionView.reloadData()
            })
        }
    }

    // GET - /companies/{stockCode}/news (기업 뉴스)
    func getCompanyNews() {
        NewsfeedService.getCompanyNews(stockCode: companyList[selectedIndex].stockCode, pageNumber: currentPage) { (result) in

            print(result.pageable.pageNumber)

            if result.first { //첫 페이지
                self.allNewsData = result

                // - 고정 데이터
                self.section0Contents.append(result.content[0]) //섹션0

                for index in 1..<3 { //섹션1
                    self.section1Contents.append(result.content[index])
                }

                for index in 3..<9 { //섹션2
                    self.section2Contents.append(result.content[index])
                }

                // - 페이징 데이터
                for index in 9..<result.content.count {
                    self.contents.append(result.content[index])
                }
            } else {
                for index in 0..<result.content.count {
                    self.contents.append(result.content[index])
                }
            }

            if result.last { self.hasNextPage = false } //페이징 종료

            //처음 섹션만 뜨는거 고치기
            DispatchQueue.main.async(execute: {
                self.isPaging = false
                self.feedTableView.reloadData()
            })
        }
    }

}

// MARK: - Skeleton Cell
extension NewsFeedViewController: SkeletonLoadable {

    func setSkeleton(sender: AnyObject) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        sender.layer.addSublayer(gradientLayer)

        if isFirstLoad {
            guard let width = sender.bounds?.width else { return }
            guard let height = sender.bounds?.height else { return }
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width - 39, height: height)
        } else {
            gradientLayer.frame = sender.bounds
        }

        let group = makeAnimationGroup()
        group.beginTime = 0.0
        gradientLayer.add(group, forKey: "backgroundColor")

        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
}
