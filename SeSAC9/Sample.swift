//
//  Sample.swift
//  SeSAC9
//
//  Created by CHOI on 2022/09/01.
//

import Foundation

class User<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ completionHandler: @escaping (T) -> Void ) {
        completionHandler(value)
        listener = completionHandler
    }
    
}
