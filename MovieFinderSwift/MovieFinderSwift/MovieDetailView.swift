//
//  MovieDetailView.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 8/11/23.
//

import SwiftUI
import WebKit

struct MovieDetailView: View {
    @ObservedObject private var movieViewModel = MovieViewModel()
    @State private var isLoading = false
    @State private var isShowingErrorAlert = false
    @State private var alertMessage: String = ""

    var movieId: Int

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Movie Details...")
            } else {
                fullList
            }
        }
        .onAppear {
            findMovieVideo(movieId)
            findMovieDetail(movieId)
        }
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    var fullList: some View {
        List {
            Text(" \(movieViewModel.movieDetail.title)")
                .font(.title)

            if let url = URL(string: movieViewModel.movieDetail.homepage) {
                Button {
                    // Action to perform when the button is tapped
                    UIApplication.shared.open(url)
                } label: {
                    Text(movieViewModel.movieDetail.homepage)
                        .foregroundColor(.blue)
                        .underline()
                }
            }

            if let originalLanguage = movieViewModel.movieDetail.originalLanguage, !originalLanguage.isEmpty {
                Text(originalLanguage)
            } else {
                EmptyView()
            }
            Text(" \(movieViewModel.movieDetail.overview)")
            Text("popularity : \(movieViewModel.movieDetail.popularity)")
            if let releaseDate = movieViewModel.movieDetail.releaseDate, !releaseDate.isEmpty {
                Text(releaseDate)
            } else {
                EmptyView()
            }
            Text("revenue :  \(movieViewModel.movieDetail.revenue)$")
            Text("runtime :  \(movieViewModel.movieDetail.runtime) minutes")
            if let voteAverage = movieViewModel.movieDetail.vote_average {
                let formattedString = String(format: "%.1f", voteAverage)
                let trimmedString = formattedString.trimmingCharacters(in: ["0", "."])
                Text("Vote Average: \(trimmedString)")
            }

            if let voteCount = movieViewModel.movieDetail.vote_count {
                Text("Vote Count: \(voteCount)")
            }

            ForEach(movieViewModel.movieVideo.results, id: \.id) { video in
                if video.type == "Trailer" || video.type == "Teaser" {
                    Text(video.type)
                    EmbedView(videoId: video.key)
                        .frame(width: 300, height: 150, alignment: .leading)
                        .cornerRadius(15)
                        .padding(.horizontal, 24)
                }
            }
        }
    }

    private func test() {
        movieViewModel.movieVideo.results.forEach { video in
            print("Video ID: \(video.id)")
            print("Video Key: \(video.key)")
            print("Video Type: \(video.type)")
            print("Official: \(video.official)")

            print("----")
//            print(video)
            // Add more properties as needed
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
                isShowingErrorAlert = true
                alertMessage = "Oops! Something went wrong with the URL. Please try again later."
                print("error with URL")
            } catch NetworkError.requestFailed {
                // Handle network request error
                isShowingErrorAlert = true
                alertMessage = "We encountered a network issue. Please check your internet connection and try again."
                print("error with request!1111")
            } catch NetworkError.decodingError {
                // Handle decoding error
                isShowingErrorAlert = true
                alertMessage = "We had trouble processing the data. Please try again later."
                print("error with decoding")
            } catch {
                isShowingErrorAlert = true
                alertMessage = "Oops! Something unexpected happened. Please try again later."
                print("error general")
            }
            isLoading = false
        }
    }

    private func findMovieVideo(_ id: Int) {
        isLoading = true
        Task {
            do {
                try await movieViewModel.fetchMovieVideo(movieId: id)
                // Handle successful result
            } catch NetworkError.invalidURL {
                // Handle invalid URL error
                isShowingErrorAlert = true
                alertMessage = "Oops! Something went wrong with the URL. Please try again later."
                print("error with URL")
            } catch NetworkError.requestFailed {
                // Handle network request error
                isShowingErrorAlert = true
                alertMessage = "We encountered a network issue. Please check your internet connection and try again."
                print("error with request!1111")
            } catch NetworkError.decodingError {
                // Handle decoding error
                isShowingErrorAlert = true
                alertMessage = "We had trouble processing the data. Please try again later."
                print("error with decoding")
            } catch {
                isShowingErrorAlert = true
                alertMessage = "Oops! Something unexpected happened. Please try again later."
                print("error general")
            }
            isLoading = false
            test()
        }
    }
}

struct EmbedView: UIViewRepresentable {
    let videoId: String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}

#Preview {
    MovieDetailView(movieId: 0)
}
