//
//  DetailViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    var item: ArticleResponse
    
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.text = "OK"
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
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLable, link])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func updateUI(){
        titleLable.text = item.headline.main
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
