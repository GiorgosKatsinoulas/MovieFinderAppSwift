//
//  MovieDetailView.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 8/11/23.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject private var movieViewModel = MovieViewModel()
    @State private var isLoading = false

    var movieId: Int

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Movie Details...")
            } else {
                Text(" \(movieViewModel.movieDetail.title)")
                    .font(.title)
                Text(" \(movieViewModel.movieDetail.title)")
                    .font(.title)
            }
        }
        .onAppear {
            findMovieDetail(movieId)
        }
    }

    private func findMovieDetail(_ id: Int) {
        isLoading = true
        Task {
            do {
                try await movieViewModel.fetchMovieDetail(movieId: id)
                // Handle successful result
            } catch NetworkError.invalidURL {
                // Handle invalid URL error
//                isShowingErrorAlert = true
//                alertMessage = "Oops! Something went wrong with the URL. Please try again later."
                print("error with URL")
            } catch NetworkError.requestFailed {
                // Handle network request error
//                isShowingErrorAlert = true
//                alertMessage = "We encountered a network issue. Please check your internet connection and try again."
                print("error with request!1111")
            } catch NetworkError.decodingError {
                // Handle decoding error
//                isShowingErrorAlert = true
//                alertMessage = "We had trouble processing the data. Please try again later."
                print("error with decoding")
            } catch {
//                isShowingErrorAlert = true
//                alertMessage = "Oops! Something unexpected happened. Please try again later."
                print("error general")
            }
            isLoading = false
        }
    }
}

#Preview {
    MovieDetailView(movieId: 0)
}
