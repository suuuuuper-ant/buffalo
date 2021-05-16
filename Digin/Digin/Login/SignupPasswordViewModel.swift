//
//  SignupPasswordViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/16.
//

import UIKit
import Combine

class SingupPasswordViewModel: ObservableObject {

    var cancellables: Set<AnyCancellable> = []
    //input

    @Published var password = CurrentValueSubject<String, Never>("")

    //output
    @Published var passwordValidation = PassthroughSubject<String, Error>()
    @Published var nextButtonValidation = PassthroughSubject<Bool, Error>()
    @Published var passwordDescriptionColor = PassthroughSubject<Bool, Error>()

    init() {

        password.sink { [unowned self ] password in
           let message = validation(password)
            self.passwordValidation.send(message.0)
            self.passwordDescriptionColor.send(message.1)
            self.nextButtonValidation.send(message.1)

        }.store(in: &cancellables)
    }

    func validationNextButton( password: String, message: String) -> Bool {

        if password != "" && message == "" {
            return true
        }
        return false
    }

    func validation(_ password: String) -> (String, Bool) {

        if password.count == 0 {
            return ("비밀번호를 입력해 주세요.", false)
        }

        let pwRegEx = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,20}"

        let passwordPred = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
        if passwordPred.evaluate(with: password) {
            return ("영문+숫자 6자리 이상 입력해 주세요.", true)
        } else {
            return ("영문+숫자 6자리 이상 입력해 주세요.", false)
        }
    }
}
