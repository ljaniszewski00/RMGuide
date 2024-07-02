import Foundation

final class EpisodeDetailsViewModel: ObservableObject {
    @Inject private var getRMEpisodeDetailsInteractor: GetRMEpisodeDetailsInteracting
    @Inject private var episodeDetailsCacheManager: EpisodeDetailsCacheManager
    
    @Published var episode: RMEpisode?
    
    @Published var showLoadingModal: Bool = false
    @Published var showErrorModal: Bool = false
    @Published var errorText: String = ""
    
    let episodeNumberString: String
    
    init(episodeNumberString: String) {
        self.episodeNumberString = episodeNumberString
        
        fetchEpisodeDetailsFromCache()
    }
    
    func onRefresh() async {
        await fetchEpisodeDetailsFromAPI()
    }
    
    private func fetchEpisodeDetailsFromCache() {
        guard let episode = episodeDetailsCacheManager.getRMEpisodeDetailsFromCache(episodeNumberString: episodeNumberString) else {
            Task {
                await fetchEpisodeDetailsFromAPI()
            }
            
            return
        }
        
        self.episode = episode
    }
    
    @MainActor
    private func fetchEpisodeDetailsFromAPI() async {
        self.episodeDetailsCacheManager.removeRMEpisodeDetailsFromCache(episodeNumberString: episodeNumberString)
        
        let getEpisodeDetailsResult = await getRMEpisodeDetailsInteractor.getRMEpisodeDetails(episodeNumberString: episodeNumberString)
        
        switch getEpisodeDetailsResult {
        case .success(let episode):
            self.episode = episode
            self.episodeDetailsCacheManager.addRMEpisodeDetailsToCache(episode, episodeNumberString: episodeNumberString)
        case .failure(let error):
            self.errorText = error.localizedDescription
            self.showErrorModal = true
        }
    }
}
