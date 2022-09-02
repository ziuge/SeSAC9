//
//  GCDViewController.swift
//  SeSAC9
//
//  Created by CHOI on 2022/09/02.
//

import UIKit

class GCDViewController: UIViewController {
    
    let url1 = URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!
    let url2 = URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!
    let url3 = URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func serialSync(_ sender: UIButton) { // => 쓸 일이 없다!
        print("START", terminator: " ")
        
        for i in 1...100 {
            print(i, terminator: " ")
        }
        
        DispatchQueue.main.sync { // 본인이 해야하므로 무한 대기 상태에 들어갈 수 있음 -> 교착 상태 Deadlock
            for i in 101...200 {
                print(i, terminator: " ")
            }
        }
        
        print("END")
    }
    
    @IBAction func serialAsync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        for i in 1...100 {
            DispatchQueue.main.async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    } // START 101 102 ... 200 END \n 1 2 3 4 ... 100
    
    @IBAction func globalSync(_ sender: UIButton) { // 쓸 일이 없다!!
        print("START", terminator: " ")
        
        DispatchQueue.global().sync {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    } // 순서대로 출력
    
    @IBAction func globalAsync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        for i in 1...100 {
            DispatchQueue.global().async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END \(Thread.isMainThread)")
    }
    
    @IBAction func qos(_ sender: UIButton) {
        
        let customQueue = DispatchQueue(label: "concurrentSeSAC", qos: .userInteractive, attributes: .concurrent)
        
        customQueue.async {
            print("START")
        }
        
        for i in 1...100 {
            DispatchQueue.global(qos: .background).async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            DispatchQueue.global(qos: .background).async {
                print(i, terminator: " ")
            }
        }
        
        for i in 201...300 {
            DispatchQueue.global(qos: .background).async {
                print(i, terminator: " ")
            }
        }
    }
    
    @IBAction func dispatchGroup(_ sender: UIButton) { // 모든 dispatchQueue의 작업이 끝난 후에 어떤 코드를 실행시키고 싶은 경우
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            for i in 101...200 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            for i in 201...300 {
                print(i, terminator: " ")
            }
        }
        
        group.notify(queue: .main) { // 끝났다는 신호를 받는다
            print("끝") // tableView.reload 와 같은 코드 여기에 와야 함
        }
        
    }
    
    func request(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(UIImage(systemName: "star"))
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image)
            
        }.resume()
    }
    
    @IBAction func dispatchGroupNASA(_ sender: UIButton) {
//        request(url: url1) { image in
//            print("1")
//            self.request(url: self.url2) { image in
//                print("2")
//                self.request(url: self.url3) { image in
//                    print("3")
//                    print("끝")
//                }
//            }
//        }
        
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url1) { image in
                print("1")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url2) { image in
                print("2")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url3) { image in
                print("3")
            }
        }
        
        group.notify(queue: .main) {
            print("끝. 완료.")
        }
    }
    
    @IBAction func enterLeave(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var imageList: [UIImage] = []
        
        group.enter()
        request(url: url1) { image in
            print("1")
            imageList.append(image!)
            group.leave()
        }
        
        group.enter()
        request(url: url2) { image in
            print("2")
            imageList.append(image!)
            group.leave()
        }
        
        group.enter()
        request(url: url3) { image in
            print("3")
            imageList.append(image!)
            group.leave()
        }
        
        group.notify(queue: .main) { // 사진 한번에 보임!
            self.imageFirst.image = imageList[0]
            self.imageSecond.image = imageList[1]
            self.imageThird.image = imageList[2]
        }
    }
    
    @IBAction func raceCondition(_ sender: UIButton) {
        
        let group = DispatchGroup()
        var nickname = "SeSAC"
        
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "고래밥"
            print("first: \(nickname)")
        }
        
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "칙촉"
            print("second: \(nickname)")
        }
        DispatchQueue.global(qos: .userInteractive).async(group: group) {
            nickname = "올라프"
            print("third: \(nickname)")
        }
        
        group.notify(queue: .main) {
            print("result: \(nickname)")
        }
        
    }
    
    
}
