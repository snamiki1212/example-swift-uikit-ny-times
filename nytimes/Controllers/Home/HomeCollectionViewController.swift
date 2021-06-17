//
//  HomeCollectionViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

typealias Response = SearchEntireResponse

class HomeCollectionViewController: UICollectionViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    var sections = [HomeSection]()
    var response: Response?

    override func viewDidLoad() {
        super.viewDidLoad()

        // styles
        collectionView.backgroundColor = .white
        
        // configures
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(HomeTopCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopCollectionViewCell.reuseIdentifier)
        configureDataSource()
     
        // async processes
        fetchRemote()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection in
            
            // styles
            // TODO: alot...
            
            let section = self.sections[sectionIndex]
            switch section {
            case .header:
                let item: NSCollectionLayoutItem = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                    let item: NSCollectionLayoutItem = {
                        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                        let padding = CGFloat(10)
                        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                        return item
                    }()
                    return item
                }()
                
                let section: NSCollectionLayoutSection = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:  .fractionalWidth(1))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                }()
                return section
            case .body:
                let item: NSCollectionLayoutItem = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1))
                    let item: NSCollectionLayoutItem = {
                        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                        let padding = CGFloat(10)
                        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                        return item
                    }()
                    return item
                }()
                
                let section: NSCollectionLayoutSection = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                }()
                return section
            }
        }
        return layout
    }
    
    private func fetchRemote (){
        ArticleSearchRequest().send { result in
            switch result {
            case .success(let res):
                self.response = res
            case .failure:
                self.response = nil
            }
            DispatchQueue.main.async {
                self.configureDataSource()
            }
        }
    }
    
    private func configureDataSource(){
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            let section = self.sections[indexPath.section]
            switch section {
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeTopCollectionViewCell
                cell.item = item
                return cell
            
            case .body:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeTopCollectionViewCell
                cell.item = item
                return cell
            
            }
        })
        
        let snapshot: NSDiffableDataSourceSnapshot<HomeSection, HomeItem> = {
            var ss = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
            
            guard let exampleList = self.response?.response.docs else { return ss }
            let headerList = [exampleList[0]]
            let bodyList = Array(exampleList[1...])
            
            let list: [(HomeSection, Array<HomeItem>)] = [
                (HomeSection.header, headerList),
                (HomeSection.body, bodyList),
            ]
            
            for (section, items) in list {
                ss.appendSections([section])
                ss.appendItems(items, toSection: section)
            }
            
            return ss
        }()
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
