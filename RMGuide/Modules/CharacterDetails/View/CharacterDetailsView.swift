import SwiftUI

struct CharacterDetailsView: View {
    @StateObject private var characterDetailsViewModel: CharacterDetailsViewModel
    
    init(character: RMCharacter) {
        self._characterDetailsViewModel = StateObject(wrappedValue: CharacterDetailsViewModel(character: character))
    }
    
    var body: some View {
        let character = characterDetailsViewModel.character
        
        VStack(alignment: .leading,
               spacing: Views.Constants.mainVStackSpacing) {
            AsyncImage(url: URL(string: characterDetailsViewModel.character.image)) { image in
                image
            } placeholder: {
                Image(systemName: Views.Constants.imagePlaceholderName)
            }
            
            Text(character.name)
            
            Text(character.status.rawValue)
            
            Text(character.gender.rawValue)
            
            Text(character.origin.name)
            
            Text(character.location.name)
            
            List {
                ForEach(character.episode, id: \.self) { episodeURLString in
                    if let episodeLabel = getEpisodeLabel(from: episodeURLString) {
                        NavigationLink {
                            EpisodeDetailsView(
                                episodeLabel: episodeLabel,
                                episodeURLString: episodeURLString
                            )
                        } label: {
                            Text(episodeLabel)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle(characterDetailsViewModel.character.name)
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
    
    private func getEpisodeLabel(from episodeURLString: String) -> String? {
        guard let episodeNumberString = episodeURLString.components(separatedBy: "/").last else {
            return nil
        }
        
        return Views.Constants.episodePrefix + " " + episodeNumberString
    }
}

#Preview {
    CharacterDetailsView(character: .sampleCharacter)
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 10
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let episodePrefix: String = "Episode"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
    }
}
