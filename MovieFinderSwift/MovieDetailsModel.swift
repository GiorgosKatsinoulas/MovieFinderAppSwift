//
//  MovieDetailsModel.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 8/11/23.
//

import Foundation

struct MovieDetailsResult: Codable {
    let id: Int
    let results: [MovieVideo]
}

struct MovieVideo: Codable {
//    let iso6391: String
//    let iso31661: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
}
