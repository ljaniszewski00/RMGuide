import Swinject

class CharactersListAssembly: Assembly {

    func assemble(container: Container) {
        container.registerAPIClient(EmptyRequestInput.self, RMCharacterResponse.self)
        
        container.register(GetRMCharactersInteracting.self) { resolver in
            GetRMCharactersInteractor(
                apiClient: resolver.resolve(
                    AnyAPIClient<EmptyRequestInput, RMCharacterResponse>.self
                )!
            )
        }
    }
}
