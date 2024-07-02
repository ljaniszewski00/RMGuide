import Swinject

class EpisodeDetailsAssembly: Assembly {

    func assemble(container: Container) {
        container.registerAPIClient(EmptyRequestInput.self, RMEpisode.self)
        
        container.register(GetRMEpisodeDetailsInteracting.self) { resolver in
            GetRMEpisodeDetailsInteractor(
                apiClient: resolver.resolve(
                    AnyAPIClient<EmptyRequestInput, RMEpisode>.self
                )!
            )
        }
        
        container.register(EpisodeDetailsCacheManager.self) { _ in
            .shared
        }
    }
}
