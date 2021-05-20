//
//  ServiceInfoConditionViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/20.
//

import UIKit

class ServiceInfoConditionViewController: UIViewController, ViewType {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var previousButton: UIButton = {

        let previous = UIButton(type: .custom)
        previous.setImage( UIImage(named: "icon_navigation_back"), for: .normal)

        return previous
    }()

    lazy var titleLabel: UILabel = {

       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        return title
    }()

    lazy var detailTitleLabel: UILabel = {

       let detail = UILabel()
        detail.text = "개인정보 수집이용"
        detail.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        detail.textColor = .black
        return detail
    }()

    lazy var detailTextView: UITextView = {

       let detailText = UITextView()
        detailText.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detailText.textColor = .black
        return detailText
    }()

    override var title: String? {
        didSet {
            titleLabel.text = title
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationItem.titleView = nil

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let cancelBarButton = UIBarButtonItem(customView: previousButton)
        let titleLabelBarButton = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItems = [cancelBarButton, titleLabelBarButton]
        detailTextView.text = "보는 청춘의 얼마나 보라. 가지에 현저하게 생생하며, 하는 길을 원대하고, 뜨고, 사막이다. 이상의 이상의 길을 이상의 되려니와, 사는가 바이며, 동산에는 사막이다. 물방아 것은 않는 장식하는 이상의 힘있다. 있는 하여도 실현에 것은 구하지 그러므로 안고, 사랑의 이상 철환하였는가? 그들에게 소담스러운 앞이 반짝이는 아름답고 장식하는 가치를 인간이 사막이다. 군영과 피는 인생에 끝에 생명을 무엇을 싶이 위하여서, 곳이 칼이다. 몸이 얼음에 보이는 위하여 이상을 새가 피가 그리하였는가? 구할 때까지 용기가 역사를 힘차게 인도하겠다는 봄바람이다.있으며, 귀는 이상의 못할 피고 황금시대를 사막이다. 없으면 낙원을 놀이 피다. 발휘하기 우리는 이것을 능히 예수는 따뜻한 바이며, 위하여서. 돋고, 품고 어디 살 위하여서, 듣는다. 트고, 새 것은 풀밭에 미묘한 사는가 이것이다. 바로 반짝이는 두손을 이것이다. 없으면, 뭇 것이다.보라, 피가 불어 철환하였는가? 가지에 귀는 속잎나고, 크고 그들을 주는 가슴이 오직 봄날의 힘있다. 낙원을 얼음과 평화스러운 이것이다.들어 창공에 그것은 있는 어디 아름다우냐? 창공에 가치를 원질이 봄바람이다. 곧 할지니, 얼마나 피부가 얼음과 청춘이 있을 것이다. 청춘 우리의 인간이 힘차게 꽃이 풀이 만천하의 때에, 있으랴? 품에 이상은 너의 그들에게 뛰노는 되려니와, 이것이다. 인생을 충분히 새 방황하였으며, 것이다. 위하여, 품으며, 평화스러운 오아이스도 불러 싹이 그들의 것이다. 꾸며 위하여서, 그들에게 소금이라 듣는다. 이것을 보는 꽃 뿐이다. 그러므로 듣기만 소금이라 열락의 얼마나 청춘을 위하여서, 가치를 약동하다. 동력은 석가는 설산에서 따뜻한 대한 있다.보는 청춘의 얼마나 보라. 가지에 현저하게 생생하며, 하는 길을 원대하고, 뜨고, 사막이다. 이상의 이상의 길을 이상의 되려니와, 사는가 바이며, 동산에는 사막이다. 물방아 것은 않는 장식하는 이상의 힘있다. 있는 하여도 실현에 것은 구하지 그러므로 안고, 사랑의 이상 철환하였는가? 그들에게 소담스러운 앞이 반짝이는 아름답고 장식하는 가치를 인간이 사막이다. 군영과 피는 인생에 끝에 생명을 무엇을 싶이 위하여서, 곳이 칼이다. 몸이 얼음에 보이는 위하여 이상을 새가 피가 그리하였는가? 구할 때까지 용기가 역사를 힘차게 인도하겠다는 봄바람이다.있으며, 귀는 이상의 못할 피고 황금시대를 사막이다. 없으면 낙원을 놀이 피다. 발휘하기 우리는 이것을 능히 예수는 따뜻한 바이며, 위하여서. 돋고, 품고 어디 살 위하여서, 듣는다. 트고, 새 것은 풀밭에 미묘한 사는가 이것이다. 바로 반짝이는 두손을 이것이다. 없으면, 뭇 것이다.보라, 피가 불어 철환하였는가? 가지에 귀는 속잎나고, 크고 그들을 주는 가슴이 오직 봄날의 힘있다. 낙원을 얼음과 평화스러운 이것이다.들어 창공에 그것은 있는 어디 아름다우냐? 창공에 가치를 원질이 봄바람이다. 곧 할지니, 얼마나 피부가 얼음과 청춘이 있을 것이다. 청춘 우리의 인간이 힘차게 꽃이 풀이 만천하의 때에, 있으랴? 품에 이상은 너의 그들에게 뛰노는 되려니와, 이것이다. 인생을 충분히 새 방황하였으며, 것이다. 위하여, 품으며, 평화스러운 오아이스도 불러 싹이 그들의 것이다. 꾸며 위하여서, 그들에게 소금이라 듣는다. 이것을 보는 꽃 뿐이다. 그러므로 듣기만 소금이라 열락의 얼마나 청춘을 위하여서, 가치를 약동하다. 동력은 석가는 설산에서 따뜻한 대한 있다"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupUI() {

        previousButton.translatesAutoresizingMaskIntoConstraints = false
        [detailTitleLabel, detailTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func setupConstraint() {
        previousButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

        detailTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        detailTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true

        detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        detailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        detailTextView.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 20).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
