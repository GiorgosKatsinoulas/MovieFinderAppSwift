//
//  MovieViewModel.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 23/10/23.
//

import Combine
import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

class MovieViewModel: ObservableObject {
    private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OGZkYTNiNWQ2MGQ3MDcxZGVjMmYwMTJmOGIzZjhlYSIsInN1YiI6IjViZTA0OGY1OTI1MTQxMzdlMjAzOWMzMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oICeWRa64ArFMWlM29iII5HkSzqJKW2tjmuY20d32HM"
    ]
    @Published var movies: [Movie] = []

    func fetchMovies(searchText: String) async throws {
        movies.removeAll()
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(searchText)&api_key=48fda3b5d60d7071dec2f012f8b3f8ea") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
            print("JSON Data:", String(data: data, encoding: .utf8) ?? "test")
            let decodedResult = try JSONDecoder().decode(MovieResult.self, from: data)
            print("values :", decodedResult)
            movies.append(contentsOf: decodedResult.results)
        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed
        }
    }
}
