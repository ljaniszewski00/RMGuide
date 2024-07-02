import Foundation

final class CharactersListViewModel: ObservableObject {
    @Inject private var getRMCharactersInteractor: GetRMCharactersInteracting
    @Inject private var favoriteCharactersManager: UserDefaultsManager<[Int]>
    
    @Published var characters: [RMCharacter] = []
    @Published var searchText: String = ""
    @Published var displayOnlyFavoriteCharacters: Bool = false
    @Published var favoriteCharactersIds: [Int] = []
    
    @Published var displayCharactersList: Bool = false
    @Published var displayMode: CharactersListDisplayMode = .grid
    @Published var displayCharacterDetailsView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    @Published var showErrorModal: Bool = false
    @Published var errorText: String = ""
    
    var charactersToDisplay: [RMCharacter] {
        var charactersToDisplay = characters
        
        if !searchText.isEmpty {
            charactersToDisplay = charactersToDisplay
                .filter {
                    $0.name.contains(searchText)
                }
        }
        
        if displayOnlyFavoriteCharacters {
            guard let favoriteCharactersIds = favoriteCharactersManager.getData() else {
                return charactersToDisplay
            }
            
            charactersToDisplay = charactersToDisplay
                .filter { characterToDisplay in
                    favoriteCharactersIds.contains(characterToDisplay.id)
                }
        }
        
        return charactersToDisplay
    }
    
    init() {
        Task {
            await fetchCharacters()
        }
    }
    
    func onAppear() {
        fetchFavoriteCharacters()
    }
    
    func onRefresh() async {
        await fetchCharacters()
    }
    
    func fetchFavoriteCharacters() {
        self.favoriteCharactersIds = favoriteCharactersManager.getData() ?? []
    }
    
    func toggleDisplayMode() {
        if displayMode == .grid {
            displayMode = .list
        } else {
            displayMode = .grid
        }
    }
    
    func manageCharacterToBeFavorite(characterId: Int) {
        var favoriteCharactersToBeAdded = favoriteCharactersIds
        
        if let characterIndex = favoriteCharactersToBeAdded.firstIndex(of: characterId) {
            favoriteCharactersToBeAdded.remove(at: characterIndex)
        } else {
            favoriteCharactersToBeAdded.append(characterId)
        }
        
        self.favoriteCharactersIds = favoriteCharactersToBeAdded
        favoriteCharactersManager.addData(favoriteCharactersToBeAdded)
    }
    
    func isCharacterFavorite(characterId: Int) -> Bool {
        favoriteCharactersIds.contains(characterId)
    }
    
    @MainActor
    private func fetchCharacters() async {
        let getCharactersResult = await getRMCharactersInteractor.getRMCharacters()
        
        switch getCharactersResult {
        case .success(let characters):
            self.characters = characters
        case .failure(let error):
            self.errorText = error.localizedDescription
            self.showErrorModal = true
        }
    }
}
