//
//  Observable.swift
//  SeSAC9
//
//  Created by CHOI on 2022/08/31.
//

import Foundation

class Observable<T> { // 데이터 담아주는 역할을 할 것. 양방향 바인딩 가능하게끔 만들 것
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didset", value)
            listener?(value) // 3. didSet에서 업데이트
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        print(#function)
        closure(value) // 1. 코드 실행 후
        listener = closure // 2. 같은 코드가 계속 실행될 수 있도록 listener에 담아주고
    }
}


class User {
    private var listener: ((String) -> Void)?
    
    var value: String {
        didSet {
            print("데이터 바뀜!")
        listener?(value)
        }
    }
    
    init(_ value: String) {
        self.value = value
    }
}
