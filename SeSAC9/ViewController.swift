//
//  ViewController.swift
//  SeSAC9
//
//  Created by CHOI on 2022/08/30.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { // 데이터 바인딩
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var lottoLabel: UILabel!
    
    private var viewModel = PersonViewModel()
    
//    var list: Person = Person(page: 0, totalPages: 0, totalResults: 0, results: []) // 배열이 아닌 이유? 모델 안에 선언해주었기 때문! // -> PersonViewModel로 코드 이동
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.fetchPerson(query: "kim")
        
        viewModel.list.bind { person in
            print("viewcontroller bind")
            self.tableView.reloadData()
        }
        
//         LottoAPIManager.requestLotto(drwNo: 1011) { lotto, error in
//            guard let lotto = lotto else {
//                return
//            }
//            self.lottoLabel.text = lotto.drwNoDate
//
//        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.results.count
        return viewModel.numberOfRowsInSection // 연산 프로퍼티이기 때문에 함수 호출 연산자()는 사용하지 않음!!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
//        let data = list.results[indexPath.row]
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.textLabel!.text = data.name
        cell.detailTextLabel?.text = data.knownForDepartment
        return cell
    }
}
