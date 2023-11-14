import SwiftUI
struct MovieContainer: View {
    var title: String
    var posterPath: String
    var movieId: Int
    @State private var isLoading = true
    @Binding var path: NavigationPath
    @State private var imageUrl: URL?

    func setupImageUrl() {
        if !posterPath.isEmpty {
            imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 10) {
                Text(title)
                    .font(.title)
                    .padding()

                if let imageUrl = imageUrl {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Show a loading indicator while the image is loading
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.9, height: 200) // Set the desired image size
                                .onAppear {
                                    isLoading = false
                                }
                        case .failure:
                            Image(systemName: "xmark.circle") // Show an error icon if image loading fails
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.red)
                                .frame(width: geometry.size.width * 0.9, height: 200) // Set the desired image size
                                .onAppear {
                                    isLoading = false
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Text("Poster not available")
                }
                NavigationLink("More info", destination: MovieDetailView(movieId: movieId))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoading)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
        }

        .onAppear {
            setupImageUrl()
        }
    }
}
