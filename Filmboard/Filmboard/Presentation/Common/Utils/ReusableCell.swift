//
//  ReusableCell.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import Foundation

protocol ReusableCell {
    
    // MARK: - Static
    
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
