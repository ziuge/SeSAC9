//
//  PersonAPIManager.swift
//  SeSAC9
//
//  Created by CHOI on 2022/08/30.
//

import Foundation

class PersonAPIManager {
    static func requestPerson(query: String, completion: @escaping (Person?, APIError?) -> Void ) {
//        query.addingPercentEncoding(withAllowedCharacters: ) // 쿼리 인코딩 설정
//        let url = URL(string: "https://api.themoviedb.org/3/search/person?api_key=72f5f5d2610cc79b8aad0e33f4d62e8a&language=en-US&query=\(query)&page=1&include_adult=false&region=ko-KR")!
        
        let scheme = "https"
        let host = "api.themoviedb.org"
        let path = "/3/search/person"
        
        let language = "ko-KR"
        let key = "72f5f5d2610cc79b8aad0e33f4d62e8a"
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "region", value: language)
        ]
        
//        URLSession.request(endpoint: component.url!) { success, fail in
//            <#code#>
//        }
        
        URLSession.shared.dataTask(with: component.url!) { data, response, error in
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
                    let result = try JSONDecoder().decode(Person.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
            
            

        }.resume()
    }
}
