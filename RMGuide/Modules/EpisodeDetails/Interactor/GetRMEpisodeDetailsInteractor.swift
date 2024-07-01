final class GetRMEpisodeDetailsInteractor: GetRMEpisodeDetailsInteracting {

    init(apiClient: AnyAPIClient<RMEpisodeRequestInput, RMEpisode>) {
        self.apiClient = apiClient
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<RMEpisodeRequestInput, RMEpisode>

    // MARK: - GetCharactersInteracting

    func getRMEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error> {
        let requestInput = RMEpisodeRequestInput(episodeNumberString: episodeNumberString)
        
        do {
            return try await apiClient
                .request(RickAndMortyEndpoints.episode,
                         requestInput: requestInput)
        } catch(let error) {
            return .failure(error)
        }
    }
}

protocol GetRMEpisodeDetailsInteracting {
    func getRMEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error>
}
