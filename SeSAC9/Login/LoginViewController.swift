//
//  LoginViewController.swift
//  SeSAC9
//
//  Created by CHOI on 2022/09/01.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.name.bind { text in
            self.nameTextField.text = text // 왜 굳이 한번 더 넣어주지??
        }
        
        viewModel.password.bind { text in
            self.passwordTextField.text = text
        }

        viewModel.email.bind { text in
            self.emailTextField.text = text
        }
        
        viewModel.isValid.bind { bool in
            self.loginButton.isEnabled = bool
            self.loginButton.backgroundColor = bool ? .systemMint : .gray
        }
        
    }
    
    @IBAction func nameTextFieldTextChanged(_ sender: UITextField) {
        viewModel.name.value = nameTextField.text!
        viewModel.checkValidation()
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        viewModel.password.value = passwordTextField.text!
        viewModel.checkValidation()
    }
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        viewModel.email.value = emailTextField.text!
        viewModel.checkValidation()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        
    }
    

}
