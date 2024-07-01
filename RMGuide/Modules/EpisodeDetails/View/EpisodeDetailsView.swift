import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject private var episodeDetailsViewModel: EpisodeDetailsViewModel
    
    init(episodeLabel: String, episodeURLString: String) {
        self._episodeDetailsViewModel = StateObject(
            wrappedValue: EpisodeDetailsViewModel(
                episodeLabel: episodeLabel,
                episodeURLString: episodeURLString
            )
        )
    }
    
    var body: some View {
        VStack {
            if let episode = episodeDetailsViewModel.episode {
                Text(episode.name)
                
                if let episodeAirDate = episode.formattedAirDate {
                    Text(episodeAirDate.description)
                }
                
                Text(episode.episode)
            }
        }
        .modifier(LoadingIndicatorModal(isPresented: $episodeDetailsViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $episodeDetailsViewModel.showErrorModal,
                             errorDescription: episodeDetailsViewModel.errorText))
        .navigationTitle(episodeDetailsViewModel.episodeLabel)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EpisodeDetailsView(episodeLabel: "2", episodeURLString: "")
}

private extension Views {
    struct Constants {
        static let navigationTitlePrefix: String = "Episode"
    }
}
