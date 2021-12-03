//
//  SignupInterestingInterator.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/18.
//

import Foundation
import Combine

protocol SignupInterestingInterator {
    func validation(nickname: String) -> String
    func validationNextButton( nickname: String, message: String) -> Bool
    func checkString(newText: String, filter: String) -> Bool
    func getCompanies()
    var signup: PassthroughSubject<Void, Never> { get }
    var flowViewController: SignupFlowViewController? { get set }
    var goToMain: PassthroughSubject<Void, Never> { get }
    var presenter: SignupInterestingViewControllerPresenter? { get set }

}

class SignupInterestingInteratorImpl: SignupInterestingInterator, ObservableObject {
    internal weak var presenter: SignupInterestingViewControllerPresenter?
    var simpleCompanyRepository: SimpleCompanyRepository
    var flowViewController: SignupFlowViewController?
    var cancellables: Set<AnyCancellable> = []
    let networkRouter = SignupService()
    //input

    @Published var signup = PassthroughSubject<Void, Never>()
    var goToMain = PassthroughSubject<Void, Never>()
    //output

    init(simpleCompanyRepository: SimpleCompanyRepository) {
        self.simpleCompanyRepository = simpleCompanyRepository
        signup
            .setFailureType(to: APIError.self)
            .compactMap({ [unowned self] _ in
                return self.flowViewController?.temporaryUserInfo
            })
            .tryMap({ userInfo in
                try userInfo.asDictionary()
            }).mapError({ error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }

            })
            .flatMap { useInfo in
            return self.networkRouter.signupDigin(param: useInfo)
        }
            .sink { completion in

                print(completion)
        } receiveValue: { [unowned self] _ in
            print("Signup!")
            self.goToMain.send()
        }.store(in: &cancellables)
    }

    func validation(nickname: String) -> String {

        if checkString(newText: nickname) == false {
            return "특수문자는 사용할 수 없어요."
        }

        if nickname.count > 12 {
            return "20자 미만의 닉네임을 입력해 주세요."
        }

        if nickname.count < 2 {
            return "2자 이상의 닉네임을 입력해 주세요."
        }

        return ""
    }

    func validationNextButton( nickname: String, message: String) -> Bool {

        if nickname != "" && message == "" {
            return true
        }
        return false

    }

    func checkString(newText: String, filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]") -> Bool {

        guard  let regex = try? NSRegularExpression(pattern: filter, options: []) else { return false }

        let list = regex.matches(in: newText, options: [], range: NSRange.init(location: 0, length: newText.count))

        if list.count != newText.count {

            return false

        }
        return true
    }

    func getCompanies() {
        simpleCompanyRepository.fetch().sink { _ in

        } receiveValue: { [weak self] data in
            let info = data.result.map({ Interesting.init(image: $0.imageUrl, interesting: $0.shortName, tiker: $0.stockCode)})
            self?.presenter?.updateCompanies(companies: info)
        }.store(in: &cancellables)

    }
}
