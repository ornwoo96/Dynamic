//
//  BMOInject.swift
//  Core
//
//  Created by 김동우 on 2022/12/09.
//

import Foundation

public final class BMOInject {
    private var storage: Dictionary<String, AnyObject> = [:]
    
    public func registerValue<Service>(_ key: String,
                                       _ value: Service) {
        if let value = value as? AnyObject {
            storage.updateValue(value, forKey: key)
        }
    }
    
    public func resolveValue<Service>(_ key: String) -> Service? {
        guard let value = storage[key] as? Service else {
            print("resolve 실패")
            return nil
        }
        return value
    }
    
    public func removeAllValue() {
        storage.removeAll()
    }
}
