//
//  APIKey.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import Foundation

extension Bundle {
    var APIKey: String {
        guard let url = self.url(forResource: "TMDBInfo", withExtension: "plist") else { return "⛔️ API KEY를 가져오는데 실패하였습니다." }
        guard let data = try? Data(contentsOf: url) else { return "⛔️ API KEY를 가져오는데 실패하였습니다." }
        guard let resource = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String] else { return "⛔️ API KEY를 가져오는데 실패하였습니다." }
        guard let key = resource["API_KEY"] else { fatalError("TMDBInfo.plist에 API_KEY를 설정해 주세요.") }
        
        return key
    }
}
