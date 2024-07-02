import Foundation

final class EpisodeDetailsCacheManager {
    
    private init() {}

    // MARK: - Properties

    private let cache = NSCache<NSString, RMEpisodeObject>()
    
    static let shared: EpisodeDetailsCacheManager = {
        EpisodeDetailsCacheManager()
    }()

    func getRMEpisodeDetailsFromCache(episodeNumberString: String) -> RMEpisode? {
        cache.object(forKey: episodeNumberString as NSString)?.toModel()
    }
    
    func addRMEpisodeDetailsToCache(_ episode: RMEpisode, episodeNumberString: String) {
        cache.setObject(episode.toObject(), forKey: episodeNumberString as NSString)
    }
    
    func removeRMEpisodeDetailsFromCache(episodeNumberString: String) {
        cache.removeObject(forKey: episodeNumberString as NSString)
    }
}
