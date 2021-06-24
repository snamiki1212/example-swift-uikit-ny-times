//
//  DetailViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    var item: Article
    
    lazy var shareButton: UIBarButtonItem = {
        let img = UIImage(systemName: "square.and.arrow.up")
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(onClickShareButton))
        return btn
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var link: UILabel = {
        let ui = UILabel()
        ui.text = " Goto Page "
        ui.translatesAutoresizingMaskIntoConstraints = false
        
        // for onClick
        let onTap = UITapGestureRecognizer(target: self, action: #selector(onClickLinkButton))
        ui.isUserInteractionEnabled = true
        ui.addGestureRecognizer(onTap)

        return ui
    }()
    
    let thumbnail: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let snippet: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let list = [titleLable, thumbnail, snippet, link]
        let stack = UIStackView(arrangedSubviews: list)
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func updateUI(){
        titleLable.text = item.headline.main
        if let url = item.imageUrl {
            thumbnail.load(url: url)
        }
        snippet.text = item.snippet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // styles
        view.backgroundColor = .white
        
        // for views
        view.addSubview(vStack)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            vStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            vStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
        
        // for nav
        navigationItem.rightBarButtonItem = shareButton
    }
    
    init(item: Article) {
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

    @objc func onClickShareButton (){
        let items = [item.webUrl]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }
}
