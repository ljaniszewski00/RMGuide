import SwiftUI

struct CharactersView: View {
    @StateObject private var charactersViewModel: CharactersViewModel = CharactersViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(charactersViewModel.characters, id: \.id) { character in
                    NavigationLink {
                        CharacterDetailsView(character: character)
                    } label: {
                        Text(character.name)
                    }
                }
            }
            .refreshable {
                await charactersViewModel.onRefresh()
            }
        }
        .modifier(LoadingIndicatorModal(isPresented: $charactersViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $charactersViewModel.showErrorModal,
                             errorDescription: charactersViewModel.errorText))
        .navigationTitle(Views.Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CharactersView()
}

private extension Views {
    struct Constants {
        static let navigationTitle: String = "Characters"
    }
}
