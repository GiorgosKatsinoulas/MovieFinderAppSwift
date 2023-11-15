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

@MainActor
class MovieViewModel: ObservableObject {
    private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OGZkYTNiNWQ2MGQ3MDcxZGVjMmYwMTJmOGIzZjhlYSIsInN1YiI6IjViZTA0OGY1OTI1MTQxMzdlMjAzOWMzMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oICeWRa64ArFMWlM29iII5HkSzqJKW2tjmuY20d32HM"
    ]
    @Published var movies: [Movie] = []

    @Published var movieDetail: MovieDetail
    @Published var movieVideo: MovieVideo

    init() {
        movies = []
        movieDetail = MovieDetail(
            id: 0,
            adult: false,
            backdropPath: "",
            budget: 0,
            homepage: "",
            originalLanguage: "",
            originalTitle: "",
            overview: "",
            popularity: 0.0,
            posterPath: "",
            releaseDate: "",
            revenue: 0,
            runtime: 0,
            status: "",
            tagline: "",
            title: "",
            video: false,
            vote_average: 0.0,
            vote_count: 0
        )
        movieVideo = MovieVideo(
            id: 0,
            results: []
        )
    }

    func fetchMovieDetail(movieId: Int) async throws {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?language=en-US&api_key=48fda3b5d60d7071dec2f012f8b3f8ea") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
//            print("JSON on movie detail Data:", String(data: data, encoding: .utf8) ?? "test")
//            let decodedResult = try JSONDecoder().decode(MovieDetail.self, from: data)
            do {
                let decodedResult = try JSONDecoder().decode(MovieDetail.self, from: data)
                // Use decodedResult here
//                print("values on movie detail :", decodedResult)
//                movieDetail = decodedResult
                movieDetail = decodedResult

            } catch {
                print("Error decoding MovieDetail:", error)
            }

        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed
        }
    }

    func fetchMovieVideo(movieId: Int) async throws {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?language=en-US&api_key=48fda3b5d60d7071dec2f012f8b3f8ea") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
            do {
                let decodedResult = try JSONDecoder().decode(MovieVideo.self, from: data)
                movieVideo = decodedResult

            } catch {
                print("Error decoding video:", error)
            }

        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed
        }
    }

    func fetchMovies(searchText: String) async throws {
//        DispatchQueue.main.async { self.movies.removeAll() }
        // New Way
        await MainActor.run(body: { self.movies.removeAll() })
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(searchText)&api_key=48fda3b5d60d7071dec2f012f8b3f8ea") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
//            print("JSON Data:", String(data: data, encoding: .utf8) ?? "test")
            let decodedResult = try JSONDecoder().decode(MovieResult.self, from: data)
//            print("values :", decodedResult)
//            DispatchQueue.main.async {
//                self.movies.append(contentsOf: decodedResult.results)
//            }
            // New Way
            await MainActor.run(body: { self.movies.append(contentsOf: decodedResult.results) })
        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed
        }
    }
}
