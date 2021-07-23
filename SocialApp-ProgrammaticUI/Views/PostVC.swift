//
//  PostVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostVC: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Comments: "
        return label
    }()

    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let postBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "Author: "
        return label
    }()
    let postAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let commentsTableView = UITableView()
    var commentsTableConstraint = NSLayoutConstraint()
    
    var post: Post!
    var comments = [Comment]()
    
    var netService: NetworkingService!
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        [scrollView, contentView, postTitleLabel, postBodyLabel, authorStackView, commentsLabel, commentsTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
     
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postBodyLabel)
        
        contentView.addSubview(authorStackView)
        authorStackView.addArrangedSubview(authorLabel)
        authorStackView.addArrangedSubview(postAuthorLabel)

        contentView.addSubview(commentsLabel)
        contentView.addSubview(commentsTableView)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            postTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            postTitleLabel.bottomAnchor.constraint(equalTo: postBodyLabel.topAnchor, constant: -20),

            postBodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postBodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            postBodyLabel.bottomAnchor.constraint(equalTo: authorStackView.topAnchor, constant: -20),
            
            authorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorStackView.bottomAnchor.constraint(equalTo: commentsLabel.topAnchor, constant: -20),

            commentsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            commentsLabel.bottomAnchor.constraint(equalTo: commentsTableView.topAnchor, constant: -20),

            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        commentsTableConstraint = NSLayoutConstraint(item: commentsTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        commentsTableConstraint.isActive = true
        commentsTableView.addConstraint(commentsTableConstraint)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPostPressed))
        navigationItem.rightBarButtonItem = editButton
        
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body

        commentsTableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellReuseId)
        commentsTableView.estimatedRowHeight = 80
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        reloadUser()
        reloadComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateScrollViewContentSize()
    }
    
    //MARK: - Methods

    @objc func editPostPressed() {
        let editPostVC = NewPostVC()
        editPostVC.mode = .edit
        editPostVC.post = post
        self.navigationController?.pushViewController(editPostVC, animated: true)
    }
    
    private func updateScrollViewContentSize(){
        
        commentsTableConstraint.constant = commentsTableView.contentSize.height + 20.0
        var heightOfSubViews:CGFloat = 0.0
        contentView.subviews.forEach { subview in
            if let tableView = subview as? UITableView {
                heightOfSubViews += (tableView.contentSize.height + 20.0)
            } else {
                heightOfSubViews += subview.frame.size.height
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: heightOfSubViews)
    }
    
    //MARK: - Network
    
    private func reloadUser() {
        
        netService.loadUsers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let users):
                print("INFO: \(users.count) users received from network")
                guard let user = users.first(where: {
                    $0.id == strongSelf.post.userId
                }) else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.postAuthorLabel.text = user.name
                }
            }
        }
    }
    
    private func reloadComments() {
        
        netService.loadComments { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            let comments: [Comment]
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                return
            case .success(let receivedComments):
                comments = receivedComments
                break
            }
            let commentsForPost = comments.filter {
                $0.postId == strongSelf.post.id
            }
            print("INFO: found \(commentsForPost.count) comments for this post")
            
            DispatchQueue.main.async {
                strongSelf.comments = commentsForPost
                strongSelf.commentsTableView.reloadData()
                strongSelf.commentsTableConstraint.constant = strongSelf.commentsTableView.contentSize.height
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
}


extension PostVC: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !comments.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            commentsTableView.dequeueReusableCell(withIdentifier: CommentCell.cellReuseId, for: indexPath) as! CommentCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
