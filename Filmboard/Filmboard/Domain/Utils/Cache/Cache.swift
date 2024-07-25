//
//  Cache.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    
    // MARK: - Properties
    
    private let data = NSCache<WrappedKey, Entry>()
    
    // MARK: - Helpers
    
    func insertValue(_ value: Value, forKey key: Key) {
        let entry = Entry(value)
        data.setObject(entry, forKey: WrappedKey(key))
    }
    
    func loadValue(forKey key: Key) -> Value? {
        let entry = data.object(forKey: WrappedKey(key))
        
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        data.removeObject(forKey: WrappedKey(key))
    }
}

// MARK: - WrappedKey & Entry Class

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            
            return value.key == key
        }
    }
    
    final class Entry {
        let value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
}
