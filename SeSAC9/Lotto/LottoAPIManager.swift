//
//  LottoAPIManager.swift
//  SeSAC9
//
//  Created by CHOI on 2022/08/30.
//

import Foundation

// shared - 단순한. 커스텀X. 응답은 클로저로 전달받음. (중간에 응답받을 수 있는 delegate는 사용X). 백그라운드 전송X.
// default configuration - shared와 유사한 형태. 커스텀O. 응답 클로저로도, delegate로도 가능

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class LottoAPIManager {
    static func requestLotto(drwNo: Int, completion: @escaping (Lotto?, APIError?) -> Void ) { // 성공할 경우 Lotto, 실패할 경우 APIError
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else { // nil이 아닐 경우 에러가 나므로 return
                    print("Faild Request")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else { // nil일 경우 문제가 있는 것이므로 return
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else { // 타입캐스팅(URLResponse -> HTTPURLResponse) 문제 없는지 판단
                    print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else { // statusCode 꺼내기 위해 guard let 구문 사용
                    print("Failed Response")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Lotto.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
            
            

        }.resume()
    }
    
}


