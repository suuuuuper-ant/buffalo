//
//  SignupRePasswordViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/17.
//

import Foundation
import Combine

class SingupRePasswordViewModel: ObservableObject {
    var flowViewController: SignupFlowViewController?
    var cancellables: Set<AnyCancellable> = []
    let networkRouter = SignupService()
    //input

    @Published var rePassword = CurrentValueSubject<String, Never>("")

    @Published var signup = PassthroughSubject<Void, Never>()

    //output
    @Published var passwordValidation = PassthroughSubject<String, Error>()
    @Published var nextButtonValidation = PassthroughSubject<Bool, Error>()
    @Published var passwordDescriptionColor = PassthroughSubject<Bool, Error>()

    init() {

        rePassword.sink { [unowned self ] password in
           let message = validation(password)
            self.passwordValidation.send(message.0)
            self.passwordDescriptionColor.send(message.1)
            self.nextButtonValidation.send(message.1)

        }.store(in: &cancellables)

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
            .sink { _ in

        } receiveValue: { _ in
            print("Signup!")

        }.store(in: &cancellables)

    }

//    func validationNextButton( rePassword: String, message: String) -> Bool {
//
//        if rePassword != "" && message == "" {
//            return true
//        }
//        return false
//    }

    func validation(_ rePassword: String) -> (String, Bool) {

        if rePassword.count == 0 {
            return ("비밀번호를 다시 한 번 입력해 주세요.", false)
        }
        if let password = flowViewController?.temporaryUserInfo.password {
            if rePassword == password {
                return ("비밀번호가 일치해요", true)
            } else {
                return ("비밀번호가 일치하지 않아요.", false)
            }
        }

        return ("비밀번호를 다시 한 번 입력해 주세요.", false)
    }

}

struct UserInfo: Decodable {
    var email: String
    var password: String
    var name: String
}

struct Status: Decodable {
    var status: String
}

struct SignupService: APIServie {

    func signupDigin(param: [String: Any]) -> AnyPublisher<Status, APIError> {

        let path = "/auth/sign-up"

      return  NetworkCombineRouter.shared.post(url: SignupService.url(path), params: param, type: Status.self)

//        NetworkCombineRouter.shared
    }

    func checkRepetition(email: String) -> AnyPublisher<EmailRepetition, APIError> {

        let path = "/auth/sign-up/check/email?email=\(email)"

      return  NetworkCombineRouter.shared.get(url: SignupService.url(path), type: EmailRepetition.self)

//        NetworkCombineRouter.shared
    }

}
