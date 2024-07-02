import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject private var episodeDetailsViewModel: EpisodeDetailsViewModel
    
    init(episodeNumberString: String) {
        self._episodeDetailsViewModel = StateObject(
            wrappedValue: EpisodeDetailsViewModel(
                episodeNumberString: episodeNumberString
            )
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let episode = episodeDetailsViewModel.episode {
                    let episodeLabel = Views.Constants.episodeLabelPrefix + " " + episodeDetailsViewModel.episodeNumberString
                    
                    Text(episodeLabel)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Divider()
                        .padding(.bottom)
                    
                    VStack(alignment: .leading,
                           spacing: Views.Constants.episodePropertiesColumnVStackSpacing) {
                        VStack(alignment: .leading,
                               spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                            Text(Views.Constants.episodePropertyNameTitle)
                                .episodePropertyNameTextModifier()
                            Text(episode.name)
                                .font(.body)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                            Text(Views.Constants.episodePropertyNameAirDate)
                                .episodePropertyNameTextModifier()
                            Text(episode.airDate)
                                .font(.body)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                            Text(Views.Constants.episodePropertyNameEpisode)
                                .episodePropertyNameTextModifier()
                            Text(episode.episode)
                                .font(.body)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                            Text(Views.Constants.episodePropertyNameCharactersCount)
                                .episodePropertyNameTextModifier()
                            Text(String(episode.characters.count))
                                .font(.body)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .padding(.top)
            
            Spacer()
        }
        .modifier(LoadingIndicatorModal(isPresented: $episodeDetailsViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $episodeDetailsViewModel.showErrorModal,
                             errorDescription: episodeDetailsViewModel.errorText))
    }
}

#Preview {
    EpisodeDetailsView(episodeNumberString: "2")
}

private extension Views {
    struct Constants {
        static let episodeLabelPrefix: String = "Episode"
        static let episodePropertiesColumnVStackSpacing: CGFloat = 15
        static let episodePropertiesNameValueSpacing: CGFloat = 7
        static let episodePropertyNameTitle: String = "Title"
        static let episodePropertyNameAirDate: String = "Air Date"
        static let episodePropertyNameEpisode: String = "Episode"
        static let episodePropertyNameCharactersCount: String = "Characters Count"
        static let episodePropertyTextColorOpacity: CGFloat = 0.8
    }
}

private extension Text {
    func episodePropertyNameTextModifier() -> some View {
        self.font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.red.opacity(Views.Constants.episodePropertyTextColorOpacity))
    }
}
