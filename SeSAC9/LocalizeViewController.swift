//
//  LocalizeViewController.swift
//  SeSAC9
//
//  Created by CHOI on 2022/09/06.
//

import UIKit
//import CoreLocation
import MessageUI // 메일로 문의 보내기(디바이스로 테스트하기, 아이폰 메일 계정 등록되어있어야 함)

class LocalizeViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sampleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "navigation_title".localized
//        NSLocalizedString("navigation_title", comment: "제목")
        
//        myLabel.text = String(format: NSLocalizedString("introduce", comment: ""), "고래밥")
        myLabel.text = "introduce".localized(with: "래밥래밥")
        
        searchBar.placeholder = "search_placeholder".localized
        
//        inputTextField.placeholder = "main_age_placeholder".localized
//        inputTextField.placeholder = String(format: NSLocalizedString("number_test", comment: ""), 11)
        inputTextField.placeholder = "main_age_placeholder".localized(number: 112)
        
        sampleButton.setTitle("common_cancel".localized, for: .normal)
        
//        CLLocationManager().requestWhenInUseAuthorization()
    }
    
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["xwcjwwd@gmail.com"])
            mail.setSubject("고래밥 다이어리 문의사항") // 제목
            mail.mailComposeDelegate = self
            self.present(mail, animated: true)
        } else {
            // alert. 메일 등록, jack@jack.com으로 문의주세요
            print("ALERT")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            <#code#>
        case .saved:
            <#code#>
        case .sent:
            <#code#>
        case .failed:
            <#code#>
        }
        controller.dismiss(animated: true)
    }

}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
    
    // <T>로 대응할 수 있을 것!!
}
