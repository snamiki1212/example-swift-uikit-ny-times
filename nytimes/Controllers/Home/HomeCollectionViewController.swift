//
//  HomeCollectionViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

// MARK: - ViewModel ---------
enum Section {
    case header
    case body
}

typealias Item = ArticleResponse
extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func == (lhs: ArticleResponse, rhs: ArticleResponse) -> Bool {
        lhs._id == rhs._id
    }
}

extension Item {
    static func createExample() -> ArticleResponse {
        let id = UUID.init().uuidString
        return ArticleResponse(_id: id, web_url: "WEB_URL" + id)
    }
    
    static func createExampleList() -> [Item] {
        return [
            Item.createExample(),
            Item.createExample(),
            Item.createExample(),
            Item.createExample(),
            Item.createExample(),
            Item.createExample(),
            Item.createExample(),
        ]
    }
}


//------------------------------------------------------------

class HomeCollectionViewController: UICollectionViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(HomeTopCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection in
            
            // styles
            // TODO: alot...
            
            let section = self.sections[sectionIndex]
            switch section {
            case .header:
                let item: NSCollectionLayoutItem = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
                    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                    return item
                }()
                
                let section: NSCollectionLayoutSection = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:  .fractionalWidth(1/3))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                }()
                return section
            case .body:
                let item: NSCollectionLayoutItem = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1/4))
                    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                    return item
                }()
                
                let section: NSCollectionLayoutSection = {
                    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                }()
                return section
            }
        }
        return layout
    }
    
    func configureDataSource(){
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
        
        let snapshot: NSDiffableDataSourceSnapshot<Section, Item> = {
            var ss = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let exampleList = Item.createExampleList()
            let headerList = [exampleList[0]]
            let bodyList = Array(exampleList[1...])
            
            let list: [(Section, Array<Item>)] = [
                (Section.header, headerList),
                (Section.body, bodyList),
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
}
