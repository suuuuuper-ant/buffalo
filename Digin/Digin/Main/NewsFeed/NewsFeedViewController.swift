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

class NewsFeedViewController: UIViewController, APIServie {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var feedTableView: UITableView!

    //skeleton
    var isLoad = false

    var viewType: Int = 0//카테고리
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
    private var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        initRefresh()

        DispatchQueue.global(qos: .utility).async {
            self.getAllNews()
            self.getCompanyList()
        }
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

        let nibName1 = UINib(nibName: LoadingTableViewCell.reuseIdentifier, bundle: nil)
        feedTableView.register(nibName1, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)

        let nibName2 = UINib(nibName: NoneResultTableViewCell.reuseIdentifier, bundle: nil)
        feedTableView.register(nibName2, forCellReuseIdentifier: NoneResultTableViewCell.reuseIdentifier)
    }

    // MARK: 새로고침 메소드
    func initRefresh() {
        feedTableView.refreshControl = refreshControl
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc func refresh() {
        resetData()

        if viewType == 0 || selectedIndex == 0 {
            getAllNews()
        } else { getCompanyNews() }

        getCompanyList()
        refreshControl.endRefreshing()
    }

    private func resetData() {
        isLoad = false
        section0Contents.removeAll()
        section1Contents.removeAll()
        section2Contents.removeAll()
        contents.removeAll()

        currentPage = 0
        hasNextPage = true
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
                cell.titleLabel.text = companyList[indexPath.row - 1].name
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

        if indexPath.item == 0 {
            getAllNews()
        } else { getCompanyNews() }

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.reloadData()
    }
}

// MARK: - TableView
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        if !isLoad {
            return 1
        }

        switch allNewsData.empty {
        case true:
            return 1
        case false:
            return 5
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if !isLoad {
            return 1
        }

        switch allNewsData.empty {
        case true: //뉴스 피드 컨텐츠가 없을 때
            return 1

        case false:
            if section == 0 { return section0Contents.count } // 1
            if section == 1 { return section1Contents.count } // 2
            if section == 2 { return section2Contents.count } // 6
            if section == 3 { return contents.count }
            if section == 4 && isPaging && hasNextPage { return 1 }

            return 0
        }
    }

    // swiftlint:disable all
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if !isLoad {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier, for: indexPath) as? LoadingTableViewCell else { return UITableViewCell() }
            cell.start()
            return cell
        }

        if allNewsData.empty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoneResultTableViewCell.reuseIdentifier) as? NoneResultTableViewCell else { return UITableViewCell() }
            cell.contentLabel.text = "해당 기업의 뉴스가 없어요!"
            return cell
        }

        switch indexPath.section {
        case 0:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell1.reuseIdentifier, for: indexPath) as? FeedTableViewCell1 else { return UITableViewCell() }

            cell.dateLabel.text = section0Contents[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")
            cell.titleLabel.text = section0Contents[indexPath.row].title
            cell.contentsLabel.text = section0Contents[indexPath.row].description

            if section0Contents[indexPath.row].imageUrl != "" {
                let url = URL(string: section0Contents[indexPath.row].imageUrl)
//                cell.newsImageView.kf.setImage(with: url, placeholder: UIImage())
                cell.opImageView.alpha = 0.5
                cell.opImageView.backgroundColor = .black
            }
            
            return cell

        case 1:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell2.reuseIdentifier, for: indexPath) as? FeedTableViewCell2 else { return UITableViewCell() }
            
            cell.titleLabel.text = section1Contents[indexPath.row].title
            cell.contentsLabel.text = section1Contents[indexPath.row].description

            if section1Contents[indexPath.row].imageUrl != "" {
                let url = URL(string: section1Contents[indexPath.row].imageUrl)
//                cell.newsImageView.kf.setImage(with: url, placeholder: UIImage())
            }
            
            return cell

        case 2:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell3.reuseIdentifier, for: indexPath) as? FeedTableViewCell3 else { return UITableViewCell() }
            cell.titleLabel.text = section2Contents[indexPath.row].title
            return cell

        case 3:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell4.reuseIdentifier, for: indexPath) as? FeedTableViewCell4 else { return UITableViewCell() }
                cell.dateLabel.text = contents[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")
                cell.titleLabel.text = contents[indexPath.row].title

                if contents[indexPath.row].imageUrl != "" {
                    let url = URL(string: contents[indexPath.row].imageUrl)
//                    cell.newsImageView.kf.setImage(with: url, placeholder: UIImage())
                    cell.opImageView.alpha = 0.5
                    cell.opImageView.backgroundColor = .black
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
    // swiftlint:enable all

    //섹션마다 매칭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController

        if !allNewsData.empty {
            if indexPath.section == 0 { webVC.newsURL = section0Contents[indexPath.row].link }
            if indexPath.section == 1 { webVC.newsURL = section1Contents[indexPath.row].link }
            if indexPath.section == 2 { webVC.newsURL = section2Contents[indexPath.row].link }
            if indexPath.section == 3 { webVC.newsURL = contents[indexPath.row].link }

            webVC.modalPresentationStyle = .formSheet
            self.present(webVC, animated: true, completion: nil)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.height

        if (self.lastContentOffset > offsetY) {
            // move up
        } else if (self.lastContentOffset < offsetY) {
            if isPaging == false && hasNextPage {
                currentPage += 1
                beginPaging()
            }
        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y

        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
//        if offsetY > (contentHeight - height) {
//            if isPaging == false && hasNextPage {
//                currentPage += 1
//                beginPaging()
//                print("AFDFAF")
//            }
//        }
    }

    func beginPaging() {
        isPaging = true // 현재 페이징이 진행 되는 것을 표시

        // Section 1을 reload하여 로딩 셀을 보여줌 (페이징 진행 중인 것을 확인할 수 있도록)
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }

        // 페이징 메소드 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.viewType == 0 || self.selectedIndex == 0 {
                self.getAllNews()
            } else { self.getCompanyNews() }

        }
    }
}

// MARK: - Networking API
extension NewsFeedViewController {

    // GET - /news (전체 뉴스)
    func getAllNews() {

        NewsfeedService.getNewsData(pageNumber: self.currentPage) { (result) in

            if result.empty {
                self.allNewsData = result
            } else if result.first { //첫 페이지
                self.allNewsData = result

                // - 고정 데이터
                self.section0Contents.append(result.content[0]) //섹션0
//                self.section0Contents[0].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[0].link, tag: "image")
//                self.section0Contents[0].description = OpenGraphParser.getStringFromHtml(urlString: result.content[0].link, tag: "description")

                //var idx = 0
                for index in 1..<3 { //섹션1
                    self.section1Contents.append(result.content[index])
//                    self.section1Contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
//                    self.section1Contents[idx].description = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "description")
                    //idx += 1
                }

                //idx = 0
                for index in 3..<9 { //섹션2
                    self.section2Contents.append(result.content[index])
//                    self.section2Contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
                    //idx += 1
                }

                //idx = 0
                // - 페이징 데이터
                for index in 9..<result.content.count {
                    self.contents.append(result.content[index])
//                    self.contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
                    //idx += 1
                }

            } else {

                //var idx = self.contents.count
                for index in 0..<result.content.count {
                    self.contents.append(result.content[index])
//                    self.contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
                    //idx += 1
                }
            }

            if result.last { self.hasNextPage = false } //페이징 종료

            DispatchQueue.main.async {
                self.isLoad = true
                self.isPaging = false
                self.feedTableView.reloadData()
            }

        }
    }

    // GET - /accounts/favorites (관심 기업)
    func getCompanyList() {
        NewsfeedService.getFavorites { (result) in
            self.companyList = result

            DispatchQueue.main.async {
                self.menuCollectionView.reloadData()
            }
        }
    }

    // GET - /companies/{stockCode}/news (기업 뉴스)
    func getCompanyNews() {
        NewsfeedService.getCompanyNews(stockCode: companyList[selectedIndex - 1].stockCode, pageNumber: currentPage) { (result) in

            if result.empty {
                self.allNewsData = result
            } else if result.first { //첫 페이지
                self.allNewsData = result

                // - 고정 데이터
                self.section0Contents.append(result.content[0]) //섹션0
//                self.section0Contents[0].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[0].link, tag: "image")
//                self.section0Contents[0].description = OpenGraphParser.getStringFromHtml(urlString: result.content[0].link, tag: "description")

                //var idx = 0
                for index in 1..<3 { //섹션1
                    self.section1Contents.append(result.content[index])
//                    self.section1Contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
//                    self.section1Contents[idx].description = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "description")
//                    idx += 1
                }

                //idx = 0
                for index in 3..<9 { //섹션2
                    self.section2Contents.append(result.content[index])
//                    self.section2Contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
//                    idx += 1
                }

                //idx = 0
                // - 페이징 데이터
                for index in 9..<result.content.count {
                    self.contents.append(result.content[index])
//                    self.contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
//                    idx += 1
                }

            } else {

                //var idx = self.contents.count
                for index in 0..<result.content.count {
                    self.contents.append(result.content[index])
//                    self.contents[idx].imageUrl = OpenGraphParser.getStringFromHtml(urlString: result.content[index].link, tag: "image")
//                    idx += 1
                }
            }

            if result.last { self.hasNextPage = false } //페이징 종료

            DispatchQueue.main.async {
                self.isLoad = true
                self.isPaging = false
                self.feedTableView.reloadData()
            }
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

//        if isFirstLoad {
//            guard let width = sender.bounds?.width else { return }
//            guard let height = sender.bounds?.height else { return }
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: width - 39, height: height)
//        } else {
//            gradientLayer.frame = sender.bounds
//        }

        let group = makeAnimationGroup()
        group.beginTime = 0.0
        gradientLayer.add(group, forKey: "backgroundColor")

        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
}
