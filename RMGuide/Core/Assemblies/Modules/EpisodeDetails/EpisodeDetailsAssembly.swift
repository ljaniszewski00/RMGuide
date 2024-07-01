import Swinject

class EpisodeDetailsAssembly: Assembly {

    func assemble(container: Container) {
        container.registerAPIClient(RMEpisodeRequestInput.self, RMEpisode.self)
        
        container.register(GetRMEpisodeDetailsInteracting.self) { resolver in
            GetRMEpisodeDetailsInteractor(
                apiClient: resolver.resolve(
                    AnyAPIClient<RMEpisodeRequestInput, RMEpisode>.self
                )!
            )
        }
    }
}
