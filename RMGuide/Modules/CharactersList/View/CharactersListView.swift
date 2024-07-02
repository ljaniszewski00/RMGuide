import SwiftUI

struct CharactersListView: View {
    @StateObject private var charactersListViewModel: CharactersListViewModel = CharactersListViewModel()
    
    var body: some View {
        VStack {
            if charactersListViewModel.displayCharactersList {
                VStack {
                    List {
                        ForEach(charactersListViewModel.charactersToDisplay, id: \.id) { character in
                            NavigationLink {
                                CharacterDetailsView(character: character)
                            } label: {
                                HStack {
                                    let isFavorite: Bool = charactersListViewModel.isCharacterFavorite(characterId: character.id)
                                    Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                                        .foregroundStyle(
                                            .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                                        )
                                        .onTapGesture {
                                            charactersListViewModel.manageCharacterToBeFavorite(characterId: character.id)
                                        }

                                    Text(character.name)
                                }
                            }
                        }
                    }
                    .refreshable {
                        await charactersListViewModel.onRefresh()
                    }
                }
                .searchable(text: $charactersListViewModel.searchText)
                .modifier(LoadingIndicatorModal(isPresented: $charactersListViewModel.showLoadingModal))
                .modifier(ErrorModal(isPresented: $charactersListViewModel.showErrorModal,
                                     errorDescription: charactersListViewModel.errorText))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            charactersListViewModel.displayOnlyFavoriteCharacters.toggle()
                        } label: {
                            let imageName: String = charactersListViewModel.displayOnlyFavoriteCharacters ?
                            Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName
                            Image(systemName: imageName)
                                .foregroundStyle(
                                    .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                                )
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            charactersListViewModel.displayCharactersList = false
                        } label: {
                            Image(systemName: Views.Constants.exitButtonImageName)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .navigationTitle(Views.Constants.navigationTitleFullList)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Views.StartView()
                    .environmentObject(charactersListViewModel)
            }
        }
        .onAppear {
            charactersListViewModel.onAppear()
        }
    }
}

#Preview {
    CharactersListView()
}

private extension Views {
    struct Constants {
        static let startViewVStackSpacing: CGFloat = 15
        static let guideAppText: String = "Guide App"
        static let guideAppLabelBottomPadding: CGFloat = 20
        static let instructionDescription: String = "Click the button below to display full Rick and Morty characters list."
        static let buttonLabel: String = "Show characters list"
        static let HStackPadding: CGFloat = 10
        static let HStackHorizontalPadding: CGFloat = 10
        
        static let exitButtonImageName: String = "rectangle.portrait.and.arrow.right"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
        static let navigationTitleFullList: String = "Characters"
    }
    
    struct StartView: View {
        @EnvironmentObject private var charactersListViewModel: CharactersListViewModel
        
        var body: some View {
            VStack(spacing: Views.Constants.startViewVStackSpacing) {
                Spacer()
                
                Image(.rickAndMortyLogo)
                    .resizable()
                    .scaledToFit()
                
                Text(Views.Constants.guideAppText)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                    .padding(.bottom, Views.Constants.guideAppLabelBottomPadding)
                
                Text(Views.Constants.instructionDescription)
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Button {
                    charactersListViewModel.displayCharactersList = true
                } label: {
                    HStack {
                        Text(Views.Constants.buttonLabel)
                            .font(.headline)
                    }
                    .padding()
                    .padding(.horizontal)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
