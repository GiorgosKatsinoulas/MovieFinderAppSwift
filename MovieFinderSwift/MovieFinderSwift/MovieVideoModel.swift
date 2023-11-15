//
//  MovieVideoModel.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 15/11/23.
//

import Foundation

struct MovieVideo: Codable {
    let id: Int
    let results: [Results]
}

struct Results: Codable, Identifiable {
    let id: String
    let key: String
    let type: String
    let official: Bool
}
