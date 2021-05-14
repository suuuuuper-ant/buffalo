//
//  LoginViewMdoel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit
import Combine

class LoginViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    @Published var emailValidation = PassthroughSubject<String, Error>()
    @Published var passwordValidation = PassthroughSubject<String, Error>()

    @Published var email = CurrentValueSubject<String, Never>("")
    @Published var password = CurrentValueSubject<String, Never>("")

    init() {
        bindInput()

        email
            .sink { [unowned self] text in
            self.emailValidation.send(isValidEmail(text))
        }.store(in: &cancellables)

        password
            .sink { [unowned self] text in
            self.passwordValidation.send(isValidPassword(text))
        }.store(in: &cancellables)
    }

    func bindInput() {

    }

    func isValidEmail(_ email: String) -> String {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) {
            return ""
        } else {
            return "올바른 이메일 형식이 아닙니다."

        }
    }

    func isValidPassword(_ password: String) -> String {
        if password.count == 0 {
            return "비밀번호를 입력해 주세요."
        } else {
            return ""
        }

    }

}
