import UIKit
import WebKit
import CoreImage
import AVFoundation
import AVFAudio
protocol WebViewControllerdelegate {
    func playCurrentPlayer()
}

class DetailViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, WebViewControllerdelegate {
    
    var timeObserverToken : Any?
    
    var playerRestartObserverToken : Any?
    
    var player : AVPlayer!
    
    var playerIsPlaying : Bool! = true
    
    @IBOutlet var progressSlider : UISlider!
    
    @IBOutlet var AlbumImageView : UIImageView! {didSet {
        AlbumImageView.layer.borderColor = UIColor.darkGray.cgColor
        AlbumImageView.layer.borderWidth = 2
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
    }}
    
    @IBOutlet var WebAlbumButton : UIButton! { didSet {
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(named: "music-album")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFill
        WebAlbumButton.configuration = configuration
        WebAlbumButton.tag = 2
    }}
    var completeAnuimated : Bool! = false
    
    var Song : MusicEnity!

    weak var MainViewDelegate : DetailViewControllerDelegate!
    
    var Albumimage : UIImage!
    
    var webViewTopAnchor : NSLayoutConstraint!
    
    func configure() {
        AlbumImageView.image = Albumimage
        SongNameLabel.text = Song.trackName
        SingerNameLabel.text = Song.artistName
        AlbumNameLabel.text = Song.collectionName
        AlbumReleaseDate.text = "Release on " + Song.releaseDate
    }
    
    @IBAction func dismissSelf(_ sender : UIButton) {
        if self.completeAnuimated {
            self.dismiss(animated: true)
        }
    }
    
    @objc func showWebView(_ sender : UIButton) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "navWebViewController") as! UINavigationController
        let controller = nav.viewControllers.first as! WebViewController
        nav.modalPresentationStyle  = .custom
        nav.transitioningDelegate = self
        switch sender.tag {
        case 0 :
            controller.detailViewDelegate = self
            controller.WebString =
            Song.artistViewUrl
            self.player.pause()
        case 1:
            if !playerIsPlaying {
                player.play()
                playerIsPlaying = true
                WebPlayButton.configuration?.background.image = UIImage(systemName: "pause")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            } else {
                player.pause()
                playerIsPlaying = false
                WebPlayButton.configuration?.background.image = UIImage(systemName: "play")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            }
            return
        case 2 :
            controller.detailViewDelegate = self
            controller.WebString = Song.collectionViewUrl
            self.player.pause()
        default:
            return
        }
        self.show(nav, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        progressSlider.value = 0
        if let url = URL(string: Song.previewUrl) {
            player = AVPlayer(url: url)
        }
        [WebArtistButton, WebAlbumButton, WebPlayButton].forEach {
            $0?.addTarget(self, action: #selector(showWebView(_ :)), for: .touchUpInside)
        }
        progressSlider.addTarget(self, action: #selector(changeCurrentTime ( _ : )), for: .touchDragInside)
        progressSlider.addTarget(self, action: #selector(sliderTouchCompletion( _ : )), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderTouchCompletion( _ : )), for: .touchUpOutside)
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(systemName: "play")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFill
        WebPlayButton.configuration = configuration
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addPeriodicTimeObserver()
        self.addPlayerRestartObserverToken()
        playCurrentPlayer()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MainViewDelegate.updateImageView(image: Albumimage)
        removePlayerRestartObserverToken()
        removePeriodicTimeObserver()
    }
    

    
}

extension DetailViewController : UIViewControllerTransitioningDelegate {
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let Animator = WebViewControllerZoominAnimator()
        return Animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let Animator = WebViewControllerZoomOutAnimator()
        return Animator
    }
}

extension DetailViewController {
    
    @objc func changeCurrentTime(_ slider : UISlider) {
        self.player.pause()
        let targetTime: CMTime =  CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: 600)
        player.seek(to: targetTime)

        WebPlayButton.configuration?.background.image = UIImage(systemName: "pause")?.withTintColor(.label, renderingMode: .alwaysOriginal)
    }
    
    @objc func sliderTouchCompletion(_ UISlider : UISlider) {
        self.player.play()
        playerIsPlaying = true
    }
    
    func formatConversion(time: Float) -> String {
        let songLength = Int(time)
        let minutes = Int(songLength / 60)
        let seconds = Int(songLength % 60)
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        } else {
            time = "\(minutes)"
        }
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time += "\(seconds)"
        }
        return time
    }
    
    func addPeriodicTimeObserver() {
        self.removePeriodicTimeObserver()
        guard timeObserverToken == nil else {
            return
        }
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.001, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else {
                return
            }
            let songCurrentTime = player.currentTime()
            let seconds = CMTimeGetSeconds(songCurrentTime)
            self.progressSlider.value = Float(seconds)
        }
        Task { [weak self] in
            guard let self = self else {
                return
            }
            let duration = try await player.currentItem?.asset.load(.duration)
            let second = CMTimeGetSeconds(duration!)
            self.progressSlider.maximumValue = Float(second)
            
        }
        progressSlider.minimumValue = 0

        progressSlider.isContinuous = true
    }
    
    
    func addPlayerRestartObserverToken() {
        guard playerRestartObserverToken == nil else {
            return
        }
        if let playerItem = self.player?.currentItem {
            playerRestartObserverToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { _ in
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
            }
        }

    }
    
    func removePlayerRestartObserverToken() {
        if let token = playerRestartObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
        playerRestartObserverToken = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.pause()
    }
    
    func removePeriodicTimeObserver() {
        self.timeObserverToken = nil
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
        }
    }
    
    @objc func playCurrentPlayer() {
        if playerIsPlaying {
            player.play()
            playerIsPlaying = true
            WebPlayButton.configuration?.background.image = UIImage(systemName: "pause")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        } else {
            player.pause()
            playerIsPlaying = false
            WebPlayButton.configuration?.background.image = UIImage(systemName: "play")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
    }
}


