import Foundation

final class CharacterDetailsViewModel: ObservableObject {
    @Inject private var favoriteCharactersManager: UserDefaultsManager<[Int]>
    
    let character: RMCharacter
    
    @Published var favoriteCharactersIds: [Int] = []
    @Published var displayEpisodeDetailsView: Bool = false
    
    var isCharacterFavorite: Bool {
        favoriteCharactersIds.contains(character.id)
    }
    
    init(character: RMCharacter) {
        self.character = character
        fetchFavoriteCharacters()
    }
    
    func onAppear() {
        fetchFavoriteCharacters()
    }
    
    func fetchFavoriteCharacters() {
        self.favoriteCharactersIds = favoriteCharactersManager.getData() ?? []
    }
    
    func manageCharacterToBeFavorite() {
        var favoriteCharactersToBeAdded = favoriteCharactersIds
        
        if let characterIndex = favoriteCharactersToBeAdded.firstIndex(of: character.id) {
            favoriteCharactersToBeAdded.remove(at: characterIndex)
        } else {
            favoriteCharactersToBeAdded.append(character.id)
        }
        
        self.favoriteCharactersIds = favoriteCharactersToBeAdded
        favoriteCharactersManager.addData(favoriteCharactersToBeAdded)
    }
}
