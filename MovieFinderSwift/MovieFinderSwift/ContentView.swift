//
//  ContentView.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 23/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = "Iron man"
    @State private var path = NavigationPath()
    @ObservedObject private var movieViewModel = MovieViewModel()
    @State private var isShowingErrorAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()

                Button("Search") {
                    findMovie(searchText)
                }
            }
            .padding()
            Divider()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 350) {
                    ForEach(movieViewModel.movies) { movie in
                        MovieContainer(title: movie.title, posterPath: movie.poster_path ?? "url", movieId: movie.id, path: $path).padding()
                    }
                    Spacer() // Add Spacer to distribute remaining space
                }
            }
            .padding()
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
    }

    private func findMovie(_ searchMovie: String) {
        Task {
            do {
                try await movieViewModel.fetchMovies(searchText: searchMovie)
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
                print("error with request")
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
        }
    }
}

#Preview {
    ContentView()
}
