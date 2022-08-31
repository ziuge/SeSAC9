//
//  URLSession+Extension.swift
//  SeSAC9
//
//  Created by CHOI on 2022/08/30.
//

import Foundation

extension URLSession {
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func customDataTask(_ endpoint: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    static func request<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError?) -> Void ) {
        
//        URLSession.shared.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>).resume() // 아래와 같은 코드임!
        
        session.customDataTask(endpoint) { data, response, error in
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
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
        }
        
    }
}
