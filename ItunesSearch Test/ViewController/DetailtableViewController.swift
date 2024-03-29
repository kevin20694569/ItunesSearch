import UIKit
import WebKit

protocol DetailViewControllerDelegate : AnyObject {
    func updateImageView(image: UIImage)
}

enum CellSection {
    case main
}

class DetailtableViewController: UIViewController, UITableViewDelegate {
    
    var completeAnuimated : Bool! = false
    
    var Song : MusicEnity!
    
    var MainViewDelegate : DetailViewControllerDelegate!
    
    var Albumimage : UIImage!
    
    @IBOutlet var tableView : UITableView! { didSet {
        tableView.delegate = self

    }}
    
    lazy var dataSource = configure()
    
    
    @IBAction func dismissSelf(_ sender : UIButton) {
        if self.completeAnuimated {
            self.dismiss(animated: true)
        }
    }
    
    func configure() -> UITableViewDiffableDataSource<CellSection, MusicEnity> {
        let datasource = UITableViewDiffableDataSource<CellSection, MusicEnity>(tableView: self.tableView) { tableView, indexPath, itemIdentifier in
            let cell = Bundle.main.loadNibNamed("TopDetailViewCell", owner: self)?.first as! TopDetailViewCell
            cell.AlbumImageView.image = self.Albumimage
            cell.SongNameLabel.text = self.Song.trackName
            cell.SingerNameLabel.text = self.Song.artistName
            cell.AlbumNameLabel.text = self.Song.collectionName
            cell.AlbumReleaseDate.text = "Release on " + self.Song.releaseDate
            return cell
        }
        return datasource
    }
    
    @objc func showWebView(_ sender : UIButton) {
            let controller = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
            switch sender.tag {
            case 0 :
                controller.WebString =
                Song.artistViewUrl
            case 1:
                controller.WebString = Song.previewUrl
            case 2 :
                controller.WebString = Song.collectionViewUrl
            default:
                return
            }
        self.present(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var snapshot = NSDiffableDataSourceSnapshot<CellSection, MusicEnity>()
        snapshot.appendSections([.main])
        snapshot.appendItems([Song], toSection: .main)
        dataSource.apply(snapshot)
        tableView.rowHeight = UIScreen.main.bounds.height
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MainViewDelegate.updateImageView(image: Albumimage)
    }




}
