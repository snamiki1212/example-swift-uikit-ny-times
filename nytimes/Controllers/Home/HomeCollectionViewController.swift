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
    
    enum SupplementaryViewKind {
        // static let header = "header"
        static let topLine = "topLine"
        // static let bottomLine = "bottomLine"
    }

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
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        configureDataSource()
     
        // async processes
        fetch()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeCollectionViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection in
            
            // styles
            // TODO: alot...
            
            let section = self.sections[sectionIndex]
            switch section {
            case .header:
                return self.createTopLayout()
            case .body:
                return self.createBodyLayout()
            }
        }
        return layout
    }
    
    private func createTopLayout() -> NSCollectionLayoutSection {
        let height = NSCollectionLayoutDimension.absolute(210)
        
        let item: NSCollectionLayoutItem = {
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: height
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let padding = CGFloat(10)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: padding,
                bottom: 0,
                trailing: padding
            )
            return item
        }()
        
        let supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = {
            let lineItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40)
            )
            let topLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: lineItemSize,
                elementKind: SupplementaryViewKind.topLine,
                alignment: .top
            )
            topLineItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
            return [topLineItem]
        }()
        
        let section: NSCollectionLayoutSection = {
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: height
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryItems
            return section
        }()
        
        return section
    }
    
    private func createBodyLayout() -> NSCollectionLayoutSection {
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

extension HomeCollectionViewController {
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
}

extension HomeCollectionViewController {
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
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.topLine:
                let sv = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                sv.setTitle("News")
                return sv
            default:
              return nil
            }
          }
        
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
}
