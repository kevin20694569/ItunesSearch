import UIKit
enum BuildingError: Error {
    case decodeFail
    case downloadImageFail
}

struct MusicTrackData :Codable {
    var artworkUrl100 : URL! //專輯封面圖示 (artworkUrl100)
    var collectionName : String! //專輯名稱 (collectionName)
    var artistName : String! //歌手 (artistName)
    var trackName : String! //歌曲名稱 (trackName)
    var releaseDate : String! //發行日期 (releaseDate, 格式:⻄元年/月/日)
    var trackId : Int!
    
    
    enum MusicTrackCodingKeys: String ,CodingKey {
        case artworkUrl100 = "artworkUrl100"
        case collectionName = "collectionName"
        case artistName = "artistName"
        case trackName = "trackName"
        case releaseDate = "releaseDate"
        case trackId = "trackId"
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MusicTrackCodingKeys.self)
        do {
            artworkUrl100 = try rootContainer.decode(URL.self, forKey: .artworkUrl100)
            collectionName = try rootContainer.decode(String.self, forKey: .collectionName)
            artistName = try rootContainer.decode(String.self, forKey: .artistName)
            trackName = try rootContainer.decode(String.self, forKey: .trackName)
            releaseDate = try rootContainer.decode(String.self, forKey: .releaseDate)
            trackId = try rootContainer.decode(Int.self, forKey: .trackId)
        } catch {
          print("decode出現錯誤")
            throw BuildingError.decodeFail
        }
    }
    

}
struct ItunesSearchResults : Codable {
    var resultCount : Int
    var results : [MusicTrackData]
    
    enum ItunesSearchResultsCodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    

}

struct MusicEnity : Hashable{
    
    var artworkUrl100 : UIImage! //專輯封面圖示 (artworkUrl100)
    var collectionName : String! //專輯名稱 (collectionName)
    var artistName : String! //歌手 (artistName)
    var trackName : String! //歌曲名稱 (trackName)
    var releaseDate : Date! //發行日期 (releaseDate, 格式:⻄元年/月/日)
    var trackId : Int!
    
    
    init(AlbumData: MusicTrackData) async throws {
        do {
            self.artworkUrl100 = try await downloadImage(from: AlbumData.artworkUrl100).0
            self.collectionName = AlbumData.collectionName
            self.artistName = AlbumData.artistName
            self.trackName = AlbumData.trackName
            self.releaseDate  = self.parseDate(from: AlbumData.releaseDate)
            self.trackId = AlbumData.trackId
        } catch BuildingError.downloadImageFail {
            throw BuildingError.downloadImageFail
        }
    }
    
    private func downloadImage(from url: URL) async throws -> (UIImage?, Error?) {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw BuildingError.downloadImageFail
        }
        return (image, nil)
        
     }
     private func parseDate(from dateString: String) -> Date? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy/MM/dd"
         return dateFormatter.date(from: dateString)
     }
    
    init() {
        
    }
}



