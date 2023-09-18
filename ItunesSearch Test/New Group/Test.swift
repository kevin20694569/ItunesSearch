//
//  Test.swift
//  ItunesSearch Test
//
//  Created by 黃楷程 on 2023/9/15.
//

import UIKit

class Test: UIViewController {

    let array : [String] = ["2", "5" ,"6"]
    
    @IBOutlet var colletionview: UICollectionView!
    
    var datasource :  UICollectionViewDiffableDataSource<Section,String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = configure()
        colletionview.dataSource = datasource
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(array, toSection: .Main)
        datasource.apply(snapshot)
    }
    
    
    func configure() ->  UICollectionViewDiffableDataSource<Section,String> {
        var datasource = UICollectionViewDiffableDataSource<Section,String>(collectionView: colletionview, cellProvider: {
            (colletionview, indexPath, string) in
            let cell = colletionview.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
           // cell.backgroundColor = .blue
            return cell
            
        })
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
                print("Header view created for section: \(indexPath.section)")
                return headerView
            } else {
                // 处理其他种类的补充视图，如果有的话
                return UICollectionReusableView()
            }
        }
        return datasource
            
        }
    }


