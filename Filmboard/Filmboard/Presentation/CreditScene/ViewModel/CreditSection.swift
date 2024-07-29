//
//  CreditSection.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/29/24.
//

import Foundation

struct ExternalLink {
    
    // MARK: - Static
    
    static let data = [
        ExternalLink(imageName: "developer", titleText: "Developer GitHub", detailText: "Developer information", url: "https://github.com/Hoon94"),
        ExternalLink(imageName: "github", titleText: "GitHub Repository", detailText: "Project repository is public on GitHub", url: "https://github.com/Hoon94/Filmboard"),
        ExternalLink(imageName: "figma", titleText: "Design Reference", detailText: "Design inspired by figma community", url: "https://www.figma.com/community/file/1006119758184707289/Movie-Streaming-App")
    ]
    
    // MARK: - Properties
    
    let imageName: String
    let titleText: String
    let detailText: String
    let url: String
}

enum CreditSection: Int, CaseIterable {
    
    // MARK: - Cases
    
    case reference
    case techStack
    case dataSource
    
    // MARK: - Properties
    
    var numberOfRows: Int {
        switch self {
        case .reference:
            return ExternalLink.data.count
        case .techStack:
            return 1
        case .dataSource:
            return 1
        }
    }
    
    var data: Any {
        switch self {
        case .reference:
            return ExternalLink.data
        case .techStack:
            return ["Tech Stack", """
                    - RxSwift
                    - MVVM
                    - UIKit(SnapKit, Then)
                    - RxDataSources
                    """]
        case .dataSource:
            return ["Movie Data", "The Movie DB API v3"]
        }
    }
}
