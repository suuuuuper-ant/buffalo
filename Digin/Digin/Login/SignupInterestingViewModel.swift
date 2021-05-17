//
//  SignupInterestingViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/18.
//

import Foundation
import Combine

class SignupInterestingViewModel: ObservableObject {
    var flowViewController: SignupFlowViewController?
    var cancellables: Set<AnyCancellable> = []
    let networkRouter = SignupService()
    //input

    @Published var signup = PassthroughSubject<Void, Never>()

    //output

    init() {

        signup
            .setFailureType(to: APIError.self)
            .compactMap({ [unowned self] _ in
                return self.flowViewController?.temporaryUserInfo
            })
            .tryMap({ userInfo in
                try userInfo.asDictionary()
            }).mapError({ error in
               return  APIError.apiError(reason: error.localizedDescription)
            })
            .flatMap { useInfo in
            return self.networkRouter.signupDigin(param: useInfo)
        }
            .sink { completion in

                print(completion)
        } receiveValue: { _ in
            print("Signup!")

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
}
