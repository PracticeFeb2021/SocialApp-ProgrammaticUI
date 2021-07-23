//
//  NewPostVC.swift
//  SocialApp-MVC
//
//  Created by Oleksandr Bretsko on 22.07.2021.
//

import UIKit

class NewPostVC: UIViewController {
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        return line
    }()

    let postTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 24)
        textField.placeholder = "Enter title"
        return textField
    }()
    
    let postBodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()
    
    var netService: NetworkingService!
    
    enum Mode {
        case new
        case edit
    }
    var mode: Mode = .new
    
    var post: Post?
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [topLabel, lineView, postTitleTextField, postBodyTextView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(topLabel)
        view.addSubview(lineView)
        view.addSubview(postTitleTextField)
        view.addSubview(postBodyTextView)
        
        NSLayoutConstraint.activate([

            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            topLabel.bottomAnchor.constraint(equalTo: postTitleTextField.topAnchor, constant: -20),

            postTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postTitleTextField.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -10),

            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: postBodyTextView.topAnchor, constant: -20),
            
            postBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postBodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        switch mode {
        case .new:
            topLabel.text = "New post"
        case .edit:
            topLabel.text = ""
        }
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton

        if let post = post {
            postTitleTextField.text = post.title
            postBodyTextView.text = post.body
        }
    }
    
    //MARK: - Methods
    
    @objc func doneButtonPressed() {
        switch mode {
        case .new:
            guard validateCurrentPost() else {
                presentAlert()
                return
            }
            //TODO: create post
        case .edit:
            guard validateCurrentPost() else {
                presentAlert()
                return
            }
            var editedPost = post!
            editedPost.title = postTitleTextField.text!
            editedPost.body = postBodyTextView.text!
            //TODO: update post
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Post title and body cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func validateCurrentPost() -> Bool {
        guard let postTitle = postTitleTextField.text, !postTitle.isEmpty,
              let postBody = postBodyTextView.text,
              !postBody.isEmpty else {
                  return false
              }
        return true
    }
}
