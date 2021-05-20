//
//  SignupEmailViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/16.
//

import Foundation
import Combine

struct EmailRepetition: Codable {
    var result: Bool
}

class SingupEmailViewModel: ObservableObject {
    let networkRouter = SignupService()
    var cancellables: Set<AnyCancellable> = []
    //input

    @Published var email = CurrentValueSubject<String, Never>("")

    //output
    @Published var emailValidation = PassthroughSubject<String, Error>()
    @Published var nextButtonValidation = PassthroughSubject<Bool, Error>()

    @Published var checkEmailRepetion = PassthroughSubject<Void, Never>()
    @Published var goToNextPage = PassthroughSubject<Void, Never>()
    init() {

        email.sink { [unowned self ] email in
           let message = isValidEmail(email)
            self.emailValidation.send(message)
            self.nextButtonValidation.send(validationNextButton(email: email, message: message))
        }.store(in: &cancellables)

        checkEmailRepetion.setFailureType(to: APIError.self)
            .compactMap { [unowned self] _ in
                return email.value
            }.flatMap { [unowned self] email in
                self.networkRouter.checkRepetition(email: email)
                    .receive(on: DispatchQueue.main)
            }.sink { _ in

            } receiveValue: { [unowned self] value in
                let message = self.isUniqueEmail(value.result)
                self.emailValidation.send(message)
                if value.result {
                    self.goToNextPage.send()
                }

            }.store(in: &cancellables)

    }

    func validationNextButton( email: String, message: String) -> Bool {

        if email != "" && message == "" {
            return true
        }
        return false
    }

    func isValidEmail(_ email: String) -> String {

        if email.count ==  0 {
            return "이메일을 입력해 주세요."
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) {
            return ""
        } else {
            return "올바른 이메일 형식이 아닙니다."

        }
    }

    func isUniqueEmail(_ unique: Bool) -> String {

        if unique {
           return ""
        } else {
            return "DiGiN에 이미 가입된 이메일이에요!"
        }
    }
}
