//
//  HomeCollectionViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

typealias Response = SearchResponse

class HomeCollectionViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    var dataSource: DataSource!
    var sections = [HomeSection]()
    var response: Response?

    override func viewDidLoad() {
        super.viewDidLoad()

        // styles
        collectionView.backgroundColor = .white
        
        // configures
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(
            HomeTopCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTopCollectionViewCell.reuseIdentifier
        )
        configureDataSource()
     
        // async processes
        fetch()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection in
            
            // styles
            // TODO: alot...
            
            let section = self.sections[sectionIndex]
            switch section {
            case .header:
                return self.createHeaderSectionLayout()
            case .body:
                return self.createBodySectionLayout()
            }
        }
        return layout
    }
    
    private func createHeaderSectionLayout() -> NSCollectionLayoutSection {
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
    }
    
    private func createBodySectionLayout() -> NSCollectionLayoutSection {
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
    
    private func fetch (){
        SearchRequest().fetch { result in
            self.response = {
                switch result {
                case .success(let res):
                    return res
                case .failure:
                    return nil
                }
            }()
            DispatchQueue.main.async {
                self.configureDataSource()
            }
        }
    }
    
    private func configureDataSource(){
        // for sections
        let snapshot = createSnapshot()
        sections = snapshot.sectionIdentifiers
        
        // for dataSource
        dataSource = createDataSource()
        dataSource.apply(snapshot)
    }
    
    private func createDataSource () -> DataSource{
        let dataSource = DataSource.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
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
        
        return dataSource
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<HomeSection, HomeItem>{
        var ss = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        
        guard let fetchedList = self.response?.response.docs else { return ss }
        let list = createSectionItemSetList(list: fetchedList)
        for (section, items) in list {
            ss.appendSections([section])
            ss.appendItems(items, toSection: section)
        }
        return ss
    }
    
    private func createSectionItemSetList(list: [HomeItem]) -> [(HomeSection, Array<HomeItem>)] {
        let headerList = [list[0]]
        let bodyList = Array(list[1...])
        
        let set = [
            (HomeSection.header, headerList),
            (HomeSection.body, bodyList),
        ]
        return set
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
