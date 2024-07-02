import SwiftUI

struct CharacterDetailsView: View {
    @StateObject private var characterDetailsViewModel: CharacterDetailsViewModel
    
    init(character: RMCharacter) {
        self._characterDetailsViewModel = StateObject(wrappedValue: CharacterDetailsViewModel(character: character))
    }
    
    var body: some View {
        let character = characterDetailsViewModel.character
        
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom,
                       spacing: Views.Constants.mainVStackSpacing) {
                    AsyncImage(url: URL(string: characterDetailsViewModel.character.image)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: Views.Constants.imagePlaceholderName)
                            .resizable()
                    }
                    .frame(width: Views.Constants.imageFrameSize,
                           height: Views.Constants.imageFrameSize)
                    .clipShape(Capsule())
                    
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .padding(.bottom)
                
                HStack(spacing: Views.Constants.characterPropertiesHStackSpacing) {
                    VStack(alignment: .leading,
                           spacing: Views.Constants.characterPropertiesColumnVStackSpacing) {
                        VStack(alignment: .leading, 
                               spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                            Text(Views.Constants.characterPropertyNameStatus)
                                .characterPropertyNameTextModifier()
                            Text(character.status.rawValue)
                                .font(.body)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                            Text(Views.Constants.characterPropertyNameOrigin)
                                .characterPropertyNameTextModifier()
                            Text(character.origin.name)
                                .font(.body)
                        }
                    }
                    
                    VStack(alignment: .leading,
                           spacing: Views.Constants.characterPropertiesColumnVStackSpacing) {
                        VStack(alignment: .leading,
                               spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                            Text(Views.Constants.characterPropertyNameGender)
                                .characterPropertyNameTextModifier()
                            Text(character.gender.rawValue)
                                .font(.body)
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                            Text(Views.Constants.characterPropertyNameLocation)
                                .characterPropertyNameTextModifier()
                            Text(character.location.name)
                                .font(.body)
                        }
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .padding(.vertical, Views.Constants.dividerVerticalPadding)
                
                VStack(alignment: .leading) {
                    Text(Views.Constants.episodesLabel)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Views.EpisodesGrid(episodes: character.episode)
                        .environmentObject(characterDetailsViewModel)
                }
            }
            .padding()
        }
        .navigationTitle(characterDetailsViewModel.character.name.components(separatedBy: " ").first ?? "")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let isFavorite: Bool = characterDetailsViewModel.isCharacterFavorite
                Button {
                    characterDetailsViewModel.manageCharacterToBeFavorite()
                } label: {
                    Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                        .foregroundStyle(
                            .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                        )
                }
            }
        }
    }
}

#Preview {
    CharacterDetailsView(character: .sampleCharacter)
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 10
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let imageFrameSize: CGFloat = 200
        static let characterPropertiesHStackSpacing: CGFloat = 40
        static let characterPropertiesColumnVStackSpacing: CGFloat = 15
        static let characterPropertiesNameValueSpacing: CGFloat = 7
        static let characterPropertyNameStatus: String = "Status"
        static let characterPropertyNameOrigin: String = "Origin"
        static let characterPropertyNameGender: String = "Gender"
        static let characterPropertyNameLocation: String = "Location"
        static let dividerVerticalPadding: CGFloat = 20
        static let gridItemMinimumSize: CGFloat = 50
        static let gridItemBackgroundPadding: CGFloat = 15
        static let episodesLabel: String = "Episodes"
        static let episodePrefix: String = "Episode"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
    }
    
    struct EpisodesGrid: View {
        @EnvironmentObject private var characterDetailsViewModel: CharacterDetailsViewModel
        let episodes: [String]
        
        private let columns = [
            GridItem(.adaptive(minimum: Views.Constants.gridItemMinimumSize))
        ]
        
        var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(episodes, id: \.self) { episodeURLString in
                    if let episodeNumber = getEpisodeNumber(from: episodeURLString) {
                        let episodeLabel = getEpisodeLabel(from: episodeNumber)
                        
                        Button {
                            characterDetailsViewModel.displayEpisodeDetailsView = true
                        } label: {
                            Text(episodeNumber)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(Views.Constants.gridItemBackgroundPadding)
                                .background(
                                    .ultraThinMaterial,
                                    in: Circle()
                                )
                        }
                        .halfSheet(showSheet: $characterDetailsViewModel.displayEpisodeDetailsView) {
                            EpisodeDetailsView(
                                episodeLabel: episodeLabel,
                                episodeURLString: episodeURLString
                            )
                        }
                    }
                }
            }
        }
        
        private func getEpisodeNumber(from episodeURLString: String) -> String? {
            episodeURLString.components(separatedBy: "/").last
        }
        
        private func getEpisodeLabel(from episodeNumber: String) -> String {
            Views.Constants.episodePrefix + " " + episodeNumber
        }
    }
}

private extension Text {
    func characterPropertyNameTextModifier() -> some View {
        self.font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.gray)
    }
}
