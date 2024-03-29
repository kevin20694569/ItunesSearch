
import UIKit

class TopDetailViewCell: UITableViewCell {
    
    
    @IBOutlet var AlbumImageView : UIImageView! {didSet {
        AlbumImageView.layer.cornerRadius = 10.0
        AlbumImageView.clipsToBounds = true
    }}
    @IBOutlet var SongNameLabel : UILabel! { didSet {
        SongNameLabel.numberOfLines = 0
        SongNameLabel.lineBreakMode = .byWordWrapping
    }}
    
    @IBOutlet var SingerNameLabel: UILabel!
    @IBOutlet var AlbumNameLabel : UILabel! { didSet {
        AlbumNameLabel.numberOfLines = 0
        AlbumNameLabel.lineBreakMode = .byWordWrapping
    }}
    @IBOutlet var AlbumReleaseDate : UILabel!
    
    @IBOutlet var WebArtistButton : UIButton! { didSet {
        WebArtistButton.tag = 0
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(named: "artist")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFill
        WebArtistButton.configuration = configuration
    }}
    @IBOutlet var WebPlayButton : UIButton! { didSet {
        WebPlayButton.tag = 1
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(systemName: "play")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFill
        WebPlayButton.configuration = configuration
    }}
    
    @IBOutlet var WebAlbumButton : UIButton! { didSet {
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(named: "music-album")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFill
        WebAlbumButton.configuration = configuration
        WebAlbumButton.tag = 2
    }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

}
