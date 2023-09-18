import UIKit
protocol MainViewdelegate: UICollectionViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
}

enum presentedViewStatus {
    case tableView
    case collectionView
}

class presentedSongView: UIView, UITableViewDelegate, UICollectionViewDelegate {
    
    var MainViewdelegate : MainViewdelegate!
    
    var Status : presentedViewStatus! { didSet {
        changepresented(Status: Status)
        if let collectionView = collectionView {
            DispatchQueue.main.async {
               // self.collectionView.scrollToItem(at: .init(row: 15, section: 0), at: .bottom, animated: false)
            }
            
        }
        if let tableView = tableView {
            DispatchQueue.main.async {
                
               // self.tableView.scrollToRow(at: .init(row: 15, section: 0), at: .bottom, animated: false)
            }
        }
    }}
    
    var tableView: UITableView! { didSet {
        tableView.delegate = self
        tableView.separatorInsetReference = .fromAutomaticInsets
    }}
    var collectionView : UICollectionView! { didSet {
        collectionView.delegate = self
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.width / 2 + 50)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        collectionView.collectionViewLayout = flow
        collectionView.isUserInteractionEnabled = true
    }}
    var collectionViewdatasource : UICollectionViewDiffableDataSource<Section, MusicEnity>?
    var tableViewdatasource  : UITableViewDiffableDataSource<Section, MusicEnity>?
    var CurrentSearchWord : String?
    var SongArray : [MusicEnity] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        tableView = UITableView()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "MainCollectionViewCell")
        tableView.register(UINib(nibName: "MaintableViewCell", bundle: nil), forCellReuseIdentifier: "MaintableViewCell")
        initlayout()
        Task {
            await Search("Boy Pablo", offset: 0, IsnewSearch: true)
            Status = .tableView
            changepresented(Status: Status)
        }
    }
    
    func changepresented(Status : presentedViewStatus) {
            switch Status {
            case .tableView:
                tableView.isHidden = false
                collectionView.isHidden = true
                tableViewdatasource = tableViewDataconfigure()
                if tableViewdatasource == nil {
                    tableViewdatasource = tableViewDataconfigure()
                    tableView.dataSource = self.tableViewdatasource
                }
                
                break
            case .collectionView:
                tableView.isHidden = true
                collectionView.isHidden = false
                if collectionViewdatasource == nil {
                    collectionViewdatasource = collectionViewDataconfigure()
                    collectionView.dataSource = self.collectionViewdatasource
                }
                break
            }
            applySnapshot()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch Status {
        case .tableView:
            MainViewdelegate.scrollViewWillBeginDragging(tableView)
        case .collectionView:
            MainViewdelegate.scrollViewWillBeginDragging(collectionView)
        case .none:
            print("error")
            break
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch Status {
        case .tableView:
            MainViewdelegate.scrollViewDidScroll(tableView)
        case .collectionView:
            MainViewdelegate.scrollViewDidScroll(collectionView)
        case .none:
            print("error")
            break
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initlayout() {
        addSubview(collectionView)
        addSubview(tableView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
extension presentedSongView {
    func collectionViewDataconfigure() -> UICollectionViewDiffableDataSource<Section, MusicEnity> {
            let cellIdentifier = "MainCollectionViewCell"
        let dataSource = UICollectionViewDiffableDataSource<Section, MusicEnity>(collectionView: self.collectionView , cellProvider: { colletionview, indexPath, Track in
                let cell = colletionview.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MainCollectionViewCell
                cell.CurrentMusicTrack = Track
                cell.configure(Music: Track)
                return cell
            })
            return dataSource
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task {
            if self.SongArray.count - indexPath.row == 10 {
                await Search(CurrentSearchWord ?? "tom misch", offset: SongArray.count, IsnewSearch: false)
            }
        }
    }
    
    func tableViewDataconfigure() -> UITableViewDiffableDataSource<Section, MusicEnity> {
            let cellIdentifier = "MaintableViewCell"
        let dataSource = UITableViewDiffableDataSource<Section, MusicEnity>(tableView: tableView, cellProvider: { tableView, indexPath, Track in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MaintableViewCell
                cell.CurrentMusicTrack = Track
                cell.configure(Music: Track)
                return cell
            })
            return dataSource
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        Task {
            if self.SongArray.count - indexPath.row == 10 {
                await Search(CurrentSearchWord ?? "tom misch", offset: SongArray.count, IsnewSearch: false)
            }
        }
    }
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicEnity>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(self.SongArray, toSection: .Main)
            self.collectionViewdatasource?.apply(snapshot)
           // self.collectionView.scrollToItem(at: .init(row: 15, section: 0), at: .bottom, animated: false)
            self.tableViewdatasource?.apply(snapshot)
        
           // self.tableView.scrollToRow(at: .init(row: 15, section: 0), at: .bottom, animated: false)

    }
}

extension presentedSongView {
    func Search(_ forString : String , offset: Int?, IsnewSearch: Bool) async  {
        DataManager.shared.fetchMusic(by: forString, offset: offset ?? 0 ) { Songdatas in
            Task {
                let array = await withTaskGroup(of: (index: Int, Album : MusicEnity).self, returning: [MusicEnity].self) {
                    group in
                    for (i,albumdata) in Songdatas.results.enumerated() {
                        group.addTask {
                            do {
                                return try await (i,MusicEnity(AlbumData: albumdata))
                            } catch {
                                print("error")
                            }
                            return (i, MusicEnity())
                        }
                    }
                    var Array = Array(repeating: MusicEnity(), count: Songdatas.results.count)
                    for await result in group {
                        Array[result.index] = result.Album
                    }
                    return Array
                }
                self.CurrentSearchWord = forString
                if IsnewSearch {
                    self.SongArray = array
                } else {
                    self.SongArray.append(contentsOf: array)
                }
                self.applySnapshot()
            }
        }
    }
}
