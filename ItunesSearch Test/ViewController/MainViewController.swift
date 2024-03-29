import UIKit
enum Section {
    case Main
}
class MainViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, UISearchControllerDelegate, UITextFieldDelegate, MainViewdelegate,
                          DetailViewControllerDelegate {
    
    var currentIndexPath : IndexPath?
    let HeaderViewHeight : CGFloat = 130
    @IBAction func changePresent(_ sender : UIButton) {
        if MainpresentedView.Status == .collectionView {
            self.MainpresentedView.Status = .tableView
            sender.setImage(UIImage(systemName: "tablecells"), for: .normal)
        } else {
            self.MainpresentedView.Status = .collectionView
            sender.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        }
    }
    @IBOutlet var HeaderView: UIView!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var SearchBar : UISearchBar! { didSet {
        SearchBar.delegate = self
        SearchBar.delegate = self
        SearchBar.searchBarStyle = .minimal
        SearchBar.placeholder = "搜尋..."
        SearchBar.returnKeyType = .search
        SearchBar.backgroundColor = .clear
        SearchBar.showsCancelButton = false
    }}
    var previousOffsetY :CGFloat = 0
    var HeaderTopLayoutanchor : NSLayoutConstraint!
    var SearchBarViewToplayoutanchor : NSLayoutConstraint!
    var navstick : NSLayoutConstraint!
    var MainpresentedView : PresentedView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MainpresentedView = PresentedView()
        MainpresentedView.MainViewdelegate = self

        navstick = SearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        HeaderTopLayoutanchor = HeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        SearchBarViewToplayoutanchor = SearchBar.topAnchor.constraint(equalTo: HeaderView.bottomAnchor)
        initlayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SearchBar.endEditing(true)
    }
}

extension MainViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        SearchBar.endEditing(true)
        previousOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let tableViewHeight = scrollView.bounds.size.height
        if offsetY > contentHeight - tableViewHeight {
            return
        }
        let diffY = offsetY - previousOffsetY
        var newY: CGFloat = HeaderTopLayoutanchor.constant - diffY
        let persent : Float =  Float(newY / (HeaderView.frame.height - UIApplication.shared.statusBarFrame.height) + 1.0)
        if scrollView.contentOffset.y <= 0 {
            HeaderView.layer.opacity = 1
            UIView.animate(withDuration: 0.1, animations: {
                self.HeaderTopLayoutanchor.constant = 0
            })
            previousOffsetY = scrollView.contentOffset.y
            return
        }
        if diffY < 0 {
            newY = min(newY, 0.0)
            if newY >= -(HeaderViewHeight - view.safeAreaInsets.top) {
                NSLayoutConstraint.activate([
                    SearchBarViewToplayoutanchor
                ])
                NSLayoutConstraint.deactivate([
                    navstick
                ])
            }
        } else {
        
            newY = max(-HeaderViewHeight , newY )
            if newY <= -(HeaderView.frame.height - view.safeAreaInsets.top ) {
                NSLayoutConstraint.activate([
                navstick
                ])
                NSLayoutConstraint.deactivate([
                    SearchBarViewToplayoutanchor
                ])
            }
        }
        HeaderView.layer.opacity = persent
        HeaderTopLayoutanchor.constant = newY
        previousOffsetY = scrollView.contentOffset.y
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            Task {
                await self.MainpresentedView.Search(searchText ,offset: nil, IsnewSearch: true)
            }
        }
    }

    
    func initlayout() {
        SearchBar.backgroundColor = .clear
        SearchBar.text = "Boy Pablo"
        SearchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(MainpresentedView)
        HeaderView.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        SearchBar.translatesAutoresizingMaskIntoConstraints = false
        MainpresentedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            HeaderView.heightAnchor.constraint(equalToConstant: HeaderViewHeight),
            HeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            HeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            SearchBar.topAnchor.constraint(equalTo: HeaderView.bottomAnchor),
            SearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SearchBar.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
            HeaderTopLayoutanchor,
            MainpresentedView.topAnchor.constraint(equalTo: SearchBar.bottomAnchor),
            MainpresentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MainpresentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MainpresentedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            SearchBarViewToplayoutanchor,
        ])
        NSLayoutConstraint.deactivate([
            navstick
        ])
    }
}

extension MainViewController {
    func tableviewcellEnterDetailView(Song : MusicEnity, indexPath : IndexPath) {
        self.currentIndexPath = indexPath
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewcontroller.Albumimage = Song.artworkUrl100
        viewcontroller.Song = Song
        viewcontroller.MainViewDelegate = self
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.present(viewcontroller, animated: true)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func updateImageView(image: UIImage) {
        let cell = self.MainpresentedView.tableView.cellForRow(at: currentIndexPath!) as! MaintableViewCell
        cell.AlbumImageView.image = image
        cell.AlbumImageView.setNeedsLayout()
        cell.AlbumImageView.layoutIfNeeded()
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let viewcontroller = source as! MainViewController
        let cell = viewcontroller.MainpresentedView.tableView.cellForRow(at: viewcontroller.MainpresentedView.tableView.indexPathForSelectedRow!) as! MaintableViewCell
        let imageview = cell.AlbumImageView
        let startpoint = cell.AlbumImageView.convert(cell.AlbumImageView.bounds, to: self.view)
        let Animator = DetailViewControllerZoominAnimator(startpoint: startpoint, image: cell.AlbumImageView.image!)
        cell.AlbumImageView.image = nil
        return Animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cell = MainpresentedView.tableView.cellForRow(at: currentIndexPath!) as! MaintableViewCell
        let viewcontroller = dismissed as! DetailViewController
        let startpoint = cell.AlbumImageView.convert(cell.AlbumImageView.bounds, to: self.view)
        let Animator = DetailViewControllerZoomOutAnimator(image: viewcontroller.Albumimage, startpoint: startpoint)
        return Animator
    }
}

