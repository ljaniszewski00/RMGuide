import SwiftUI

struct CharacterDetailsView: View {
    private var characterDetailsViewModel: CharacterDetailsViewModel
    
    init(character: RMCharacter) {
        self.characterDetailsViewModel = CharacterDetailsViewModel(character: character)
    }
    
    var body: some View {
        let character = characterDetailsViewModel.character
        
        VStack(alignment: .leading,
               spacing: Views.Constants.mainVStackSpacing) {
            if let url = URL(string: characterDetailsViewModel.character.url) {
                AsyncImage(url: url) { image in
                    image
                } placeholder: {
                    Image(systemName: Views.Constants.imagePlaceholderName)
                }
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
    }
}
