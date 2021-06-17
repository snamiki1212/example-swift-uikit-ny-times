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
        label.backgroundColor = .red
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let link: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        btn.setTitle("Goto Page", for: .normal)
        btn.addTarget(self, action: #selector(onClickLinkButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        return btn
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
            vStack.topAnchor.constraint(equalTo: safeArea.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
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
