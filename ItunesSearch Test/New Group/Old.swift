
/*import UIKit
enum Section {
    case Main
}

class MainViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate, UISearchControllerDelegate{
    
    @IBOutlet var TitleLabel: UILabel! { didSet {
        
    }}
    
    @IBOutlet var NavBar : UINavigationBar!
    var isCollectionViewShown = true
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    var previousOffsetY :CGFloat = 0
    @IBOutlet var HeaderView: UIView!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                Task {
                    await Search(searchText, offset: 0) {
                        array in
                        self.SongArray = array
                       self.applySnapshot()
                        print("search")
                    }
                }
            }
        }
    var HeaderTopLayoutanchor : NSLayoutConstraint!
    var NavbarViewToplayoutanchor : NSLayoutConstraint!
    var navstick : NSLayoutConstraint!

    
   /* @IBOutlet var SearchBar: UISearchBar! { didSet {

    }}*/

    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previousOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diffY = scrollView.contentOffset.y - previousOffsetY
        var newY: CGFloat = HeaderTopLayoutanchor.constant - diffY
        let persent : Float =  Float(newY / (HeaderView.frame.height - UIApplication.shared.statusBarFrame.height) + 1.0)
        if scrollView.contentOffset.y <= 0 {
            return
        }
        if diffY < 0 {
            newY = min(newY, 0.0)
            print("下拉")
            if newY >= -(HeaderView.frame.height - view.safeAreaInsets.top) {
                NSLayoutConstraint.activate([
                    NavbarViewToplayoutanchor
                ])
                NSLayoutConstraint.deactivate([
                    navstick
                ])
            }
        } else {
        
            newY = max(-HeaderView.frame.height, newY )
            print("總長\(-HeaderView.frame.height)")
            print(newY)
            if newY <= -(HeaderView.frame.height - view.safeAreaInsets.top ) {
                NSLayoutConstraint.activate([
                navstick
                ])
                NSLayoutConstraint.deactivate([
                    NavbarViewToplayoutanchor
                ])
            }
          print("上拉")
        }
        print(newY)
        HeaderView.layer.opacity = persent
        HeaderTopLayoutanchor.constant = newY
        previousOffsetY = scrollView.contentOffset.y
    }
    
    func initlayout() {
       
        MusicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        HeaderView.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NavBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            HeaderView.heightAnchor.constraint(equalToConstant: 150),
            HeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            HeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            NavBar.topAnchor.constraint(equalTo: HeaderView.topAnchor, constant: 150),
            NavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            NavBar.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
            HeaderTopLayoutanchor,
           MusicCollectionView.topAnchor.constraint(equalTo: NavBar.bottomAnchor),
            MusicCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MusicCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MusicCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            NavbarViewToplayoutanchor,
         //   NavBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            //CollectionTopLayoutnachor,

           // SearchController.searchBar.bottomAnchor.constraint(equalTo: HeaderView.bottomAnchor, constant: 0),
           // SearchController.searchBar.trailingAnchor.constraint(equalTo: HeaderView.trailingAnchor, constant: -12),
           // SearchController.searchBar.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
           /* TitleLabel.bottomAnchor.constraint(equalTo: HeaderView.bottomAnchor, constant: -8),
            TitleLabel.leadingAnchor.constraint(equalTo: HeaderView.leadingAnchor, constant: 12)*/
        ])
        NSLayoutConstraint.deactivate([
            navstick
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        navstick = NavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        HeaderTopLayoutanchor = HeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        NavbarViewToplayoutanchor = NavBar.topAnchor.constraint(equalTo: HeaderView.bottomAnchor)
        initlayout()
        Task {
            await Search("Boy Pablo", offset: 0) { [self] array in
                self.SongArray = array
                applySnapshot()
            }
        }
        MusicCollectionView.delegate = self
        MusicCollectionView.dataSource = datasource
   //    SearchBar.searchBarStyle = .minimal
     //   SearchBar.placeholder = "搜尋..."
    
    }

    var CurrentSearchWord : String?
    @IBOutlet weak var MusicCollectionView : UICollectionView! { didSet  {
        MusicCollectionView.contentInsetAdjustmentBehavior = .never
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.width / 2 + 50)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
       // flow.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
      // flow.sectionHeadersPinToVisibleBounds = true
        MusicCollectionView.collectionViewLayout = flow
    }}
    lazy var datasource = configureDataSource()
    var SongArray: [MusicEnity] = []
}

extension MainViewController {
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, MusicEnity> {
        let cellIdentifier = "MainCell"
        let dataSource = UICollectionViewDiffableDataSource<Section, MusicEnity>(collectionView: MusicCollectionView , cellProvider: { colletionview, indexPath, Track in
            let cell = colletionview.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MainCell
            cell.CurrentMusicTrack = Track
            cell.configure(Music: Track)
            return cell
        })
        
       /* dataSource.supplementaryViewProvider = { (collectionView, kind, indexpath ) in
            let nib = UINib(nibName: "MainHeaderView", bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: "MainHeaderView")
            let HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainHeaderView", for: indexpath) as! MainHeaderView
            
            return HeaderView
        }*/
        return dataSource
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task {
            if self.SongArray.count - indexPath.row == 10 {
                await self.Search(CurrentSearchWord ?? "tom misch", offset: SongArray.count) { [self] array in
                    self.SongArray.append(contentsOf: array)
                    applySnapshot()
                }
            }
        }
    }
}

extension MainViewController {
    func Search(_ forString : String , offset: Int, Completion: @escaping ([MusicEnity]) -> () ) async  {
        DataManager.shared.fetchMusic(by: forString, offset: offset ) { Albumdatas in
            Task {
                var Array = Array(repeating: MusicEnity(), count: Albumdatas.results.count)
                await withTaskGroup(of: (index: Int, Album : MusicEnity).self) {
                    group in
                    for (i,albumdata) in Albumdatas.results.enumerated() {
                        group.addTask {
                            do {
                                return try await (i,MusicEnity(AlbumData: albumdata))
                            } catch {
                                print("error")
                            }
                            return (i, MusicEnity())
                        }
                    }
                    for await result in group {
                        Array[result.index] = result.Album
                    }
                }
                Completion(Array)
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicEnity>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(self.SongArray, toSection: .Main)
        self.datasource.apply(snapshot)
    }
}*/

