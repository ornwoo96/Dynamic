//
//  BMOInject.swift
//  Core
//
//  Created by 김동우 on 2022/12/09.
//

import Foundation

public enum BMOInjectError: String, Error {
    case resolveError = "resolveError"
    case registerError = "registerError"
}

public final class BMOInject {
    private var storage: Dictionary<String, AnyObject> = [:]
    
    public func registerValue<Service: AnyObject>(_ key: String,
                                       _ value: Service) {
        storage.updateValue(value, forKey: key)
    }
    
    public func resolveValue<Service>(_ key: String) -> Service? {
        guard let value = storage[key] as? Service else {
            print(BMOInjectError.resolveError)
            return nil
        }
        
        return value
    }
    
    public func removeAllValue() {
        storage.removeAll()
    }
}
