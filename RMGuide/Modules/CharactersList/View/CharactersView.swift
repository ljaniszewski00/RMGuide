import SwiftUI

struct CharactersView: View {
    @StateObject private var charactersViewModel: CharactersViewModel = CharactersViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(charactersViewModel.charactersToDisplay, id: \.id) { character in
                    NavigationLink {
                        CharacterDetailsView(character: character)
                    } label: {
                        HStack {
                            let isFavorite: Bool = charactersViewModel.isCharacterFavorite(characterId: character.id)
                            Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    charactersViewModel.manageCharacterToBeFavorite(characterId: character.id)
                                }

                            Text(character.name)
                        }
                    }
                }
            }
            .refreshable {
                await charactersViewModel.onRefresh()
            }
        }
        .searchable(text: $charactersViewModel.searchText)
        .modifier(LoadingIndicatorModal(isPresented: $charactersViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $charactersViewModel.showErrorModal,
                             errorDescription: charactersViewModel.errorText))
        .navigationTitle(Views.Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    charactersViewModel.displayOnlyFavoriteCharacters.toggle()
                } label: {
                    let imageName: String = charactersViewModel.displayOnlyFavoriteCharacters ?
                    Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName
                    Image(systemName: imageName)
                }
            }
        }
        .onAppear {
            charactersViewModel.onAppear()
        }
    }
}

#Preview {
    CharactersView()
}

private extension Views {
    struct Constants {
        static let nonFavoriteImageName: String = "star"
        static let favoriteImageName: String = "star.fill"
        static let navigationTitle: String = "Characters"
    }
}
