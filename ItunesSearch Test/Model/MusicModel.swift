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
    var artistViewUrl : String!
    var collectionViewUrl : String!
    var previewUrl : String!
  //  var artistId : Int!
 //   var collectionId : Int!
    
    
    enum MusicTrackCodingKeys: String ,CodingKey {
        case artworkUrl100 = "artworkUrl100"
        case collectionName = "collectionName"
        case artistName = "artistName"
        case trackName = "trackName"
        case releaseDate = "releaseDate"
        case artistViewUrl = "artistViewUrl"
        case collectionViewUrl = "collectionViewUrl"
        case previewUrl = "previewUrl"
        case trackId = "trackId"
     //   case artistId = "artistId"
      //  case collectionId = "collectionId"
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
            previewUrl = try rootContainer.decode(String.self, forKey: .previewUrl)
            artistViewUrl = try rootContainer.decode(String.self, forKey: .artistViewUrl)
            collectionViewUrl = try rootContainer.decode(String.self, forKey: .collectionViewUrl)
            //   artistId = try rootContainer.decode(Int.self, forKey: .artistId)
            //    collectionId = try rootContainer.decode(Int.self, forKey: .collectionId)
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
    var releaseDate : String! //發行日期 (releaseDate, 格式:⻄元年/月/日)
    var trackId : Int!
   // var collectionId : Int!
  //  var artistId : Int!
    var artistViewUrl : String!
    var collectionViewUrl : String!
    var previewUrl : String!
    
    
    init(AlbumData: MusicTrackData) async throws {
        
        do {
            let url = transformImageURL(url: AlbumData.artworkUrl100)
            self.artworkUrl100 = try await downloadImage(from: url).0
            self.collectionName = AlbumData.collectionName
            self.artistName = AlbumData.artistName
            self.trackName = AlbumData.trackName
            self.releaseDate = self.parseDate(from: AlbumData.releaseDate)
            self.trackId = AlbumData.trackId
            self.artistViewUrl = AlbumData.artistViewUrl
            self.collectionViewUrl = AlbumData.collectionViewUrl
            self.previewUrl = AlbumData.previewUrl
        } catch BuildingError.downloadImageFail {
            throw BuildingError.downloadImageFail
        }
    }
    
    private func transformImageURL(url: URL) -> URL {
        let string = url.absoluteString.replacingOccurrences(of: "100x100", with: "500x500")
        return URL(string: string) ?? url
    }
    
    private func downloadImage(from url: URL) async throws -> (UIImage?, Error?) {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw BuildingError.downloadImageFail
        }
        return (image, nil)
        
     }
     private func parseDate(from dateString: String) -> String? {
         let inputDateFormatter = DateFormatter()
         inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
         if let date = inputDateFormatter.date(from: dateString) {
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy/MM/dd"
             return dateFormatter.string(from: date)
         }
         print("解析錯誤")
         return nil
     }
    
    init() {
        
    }
}



