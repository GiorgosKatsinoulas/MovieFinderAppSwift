//
//  MovieDetailsModel.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 8/11/23.
//

import Foundation

struct MovieDetail: Codable, Hashable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let homepage: String
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Double?
    let vote_count: Int?
}
