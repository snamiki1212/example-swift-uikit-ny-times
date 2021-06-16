//
//  DetailViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    var item: ArticleResponse {
        didSet {
            titleLable.text = item.headline.main
        }
    }
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.text = "OK"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let link: UIButton = {
        let btn = UIButton()
        btn.setTitle("Goto Page", for: .normal)
        btn.addTarget(self, action: #selector(onClickLinkButton), for: .touchUpInside)
        return btn
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLable, link])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // styles
        view.backgroundColor = .white
        
        // for views
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    init(item: ArticleResponse) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClickLinkButton (){
        let vc = SFSafariViewController(url: item.webUrl!)
        present(vc, animated: true, completion: nil)
    }

}
