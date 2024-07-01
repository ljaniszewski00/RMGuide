final class GetRMCharactersInteractor: GetRMCharactersInteracting {

    init(apiClient: AnyAPIClient<EmptyRequestInput, RMCharacterResponse>) {
        self.apiClient = apiClient
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<EmptyRequestInput, RMCharacterResponse>

    // MARK: - GetCharactersInteracting

    func getRMCharacters() async -> Result<[RMCharacter], Error> {
        do {
            return try await apiClient
                .request(RickAndMortyEndpoints.character,
                         requestInput: EmptyRequestInput())
                .map {
                    $0.results
                }
        } catch(let error) {
            return .failure(error)
        }
    }
}

protocol GetRMCharactersInteracting {
    func getRMCharacters() async -> Result<[RMCharacter], Error>
}
