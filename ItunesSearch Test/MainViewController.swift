import UIKit
enum Section {
    case Main
}

class MainViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, UISearchControllerDelegate, UITextFieldDelegate, MainViewdelegate{
    let HeaderViewHeight : CGFloat = 130
    @IBAction func changepresent(_ sender : UIButton) {
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
    var MainpresentedView : presentedSongView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MainpresentedView = presentedSongView()
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
        let diffY = scrollView.contentOffset.y - previousOffsetY
        var newY: CGFloat = HeaderTopLayoutanchor.constant - diffY
        let persent : Float =  Float(newY / (HeaderView.frame.height - UIApplication.shared.statusBarFrame.height) + 1.0)
        if scrollView.contentOffset.y <= 0 {
            previousOffsetY = scrollView.contentOffset.y
            return
        }
        if diffY < 0 {
            newY = min(newY, 0.0)
           // print("上滑")
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
          //print("下滑")
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

