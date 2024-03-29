import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var detailViewDelegate : WebViewControllerdelegate?
    
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
    
    @IBOutlet var webView : WKWebView! { didSet {
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }}
    @IBOutlet var goBackBarbutton : UIBarButtonItem! { didSet {
    }}
    @IBOutlet var goForwardBarbutton : UIBarButtonItem! { didSet {
    }}
    
    
    func detect() {
        print("few")
        if !webView.canGoBack {
            goBackBarbutton.isEnabled = false
        } else {
            goBackBarbutton.isEnabled = true
        }
        if !webView.canGoForward {
            goForwardBarbutton.isEnabled = false
        } else {
            goForwardBarbutton.isEnabled = true
        }
    }

    
    var WebString : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: WebString) {
            let request = URLRequest(url: url)
            webView.load(request)
            
        }
        goForwardBarbutton.isEnabled = false
        goBackBarbutton.isEnabled = false
        goForwardBarbutton.target = webView.goForward()
        goBackBarbutton.target = webView.goBack()
    }
    @IBAction func dismissSelf( _ sender : Any ) {
        self.dismiss(animated: true)
        detailViewDelegate?.playCurrentPlayer()
    }

}
