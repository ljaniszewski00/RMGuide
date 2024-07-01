final class GetRMEpisodeDetailsInteractor: GetRMEpisodeDetailsInteracting {

    init(apiClient: AnyAPIClient<EmptyRequestInput, RMEpisode>) {
        self.apiClient = apiClient
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<EmptyRequestInput, RMEpisode>

    // MARK: - GetCharactersInteracting

    func getRMEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error> {
        do {
            return try await apiClient
                .request(RickAndMortyEndpoints.episode,
                         requestInput: EmptyRequestInput(),
                         additionalPathContent: episodeNumberString)
        } catch(let error) {
            return .failure(error)
        }
    }
}

protocol GetRMEpisodeDetailsInteracting {
    func getRMEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error>
}
