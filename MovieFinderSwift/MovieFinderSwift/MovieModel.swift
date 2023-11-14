//
//  MovieModel.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 23/10/23.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let backdrop_path: String?
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let vote_average: Double
    let vote_count: Int
}

struct MovieResult: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
