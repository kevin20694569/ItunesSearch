import UIKit

class DataManager  {
    static let shared = DataManager()
    

    func fetchMusic(by keyword:String , offset: Int, completeHandler: @escaping (ItunesSearchResults)->Void  ) {
        let keyword = keyword.replacingOccurrences(of: " ", with: "+")
        if let urlStr = "https://itunes.apple.com/search?term=\(keyword)&media=music&offset=\(offset)&limit=20&country=tw".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let albumData = try decoder.decode(ItunesSearchResults.self, from: data)
                    completeHandler(albumData)
                }
                catch {
                    print(error)
                }
            }.resume()
        }
    }
    
    func fetchByTrackID(id : Int, completeHandler: @escaping (ItunesSearchResults) -> Void) {
        if let urlStr = "https://itunes.apple.com/lookup?id=\(id)" .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let albumData = try decoder.decode(ItunesSearchResults.self, from: data)
                    completeHandler(albumData)
                }
                catch {
                    print(error)
                }
            }.resume()
        }
    }
}
