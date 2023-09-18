import UIKit

class MainCollectionViewCell : UICollectionViewCell {
    
    var CurrentMusicTrack : MusicEnity!
    
    let ImageSize : CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    @IBOutlet var AlbumImageView: UIImageView! { didSet {
        AlbumImageView.contentMode = .scaleAspectFill
    }}
    @IBOutlet var AlbumNameLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet var SingerNameLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet var SongNameLabel : UILabel! {
        didSet {
            SongNameLabel.numberOfLines = 2
            SongNameLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    func configure(Music: MusicEnity) {
        AlbumImageView.image = Music.artworkUrl100
        AlbumNameLabel.text = CurrentMusicTrack.collectionName
        SingerNameLabel.text = CurrentMusicTrack.artistName
        SongNameLabel.text =  CurrentMusicTrack.trackName
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 0.5
       // contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        
    }
    
    
    
}
