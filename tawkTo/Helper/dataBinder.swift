//
//  dataBinder.swift
//  iFollow
//
//  Created by Ayush Pathak on 01/03/21.
//

import Foundation

class DataBinder<T> {
    typealias Listener = (T) -> ()
    
    // MARK:- variables for the binder
    var value: T {
        didSet {
            listener?(value)
        }
    }

    var listener: Listener?
    
    // MARK:- initializers for the binder
    init(_ value: T) {
        self.value = value
    }
    
    // MARK:- functions for the binder
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
