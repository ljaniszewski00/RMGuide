import Foundation

final class CharactersViewModel: ObservableObject {
    @Inject private var getRMCharactersInteractor: GetRMCharactersInteracting
    
    @Published var characters: [RMCharacter] = []
    
    @Published var showLoadingModal: Bool = false
    @Published var showErrorModal: Bool = false
    @Published var errorText: String = ""
    
    init() {
        Task {
            await fetchCharacters()
        }
    }
    
    func onRefresh() async {
        await fetchCharacters()
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
