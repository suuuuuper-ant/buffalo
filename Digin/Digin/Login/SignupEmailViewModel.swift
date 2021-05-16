//
//  SignupEmailViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/16.
//

import Foundation
import Combine

class SingupEmailViewModel: ObservableObject {

    var cancellables: Set<AnyCancellable> = []
    //input

    @Published var email = CurrentValueSubject<String, Never>("")

    //output
    @Published var emailValidation = PassthroughSubject<String, Error>()
    @Published var nextButtonValidation = PassthroughSubject<Bool, Error>()

    init() {

        email.sink { [unowned self ] email in
           let message = isValidEmail(email)
            self.emailValidation.send(message)
            self.nextButtonValidation.send(validationNextButton(email: email, message: message))
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
}
