//
//  CommentCell.swift
//  CommentCell
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class CommentCell: UITableViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    static let cellReuseId = "CommentCell"
    
    let spacing: CGFloat = 10
    let titleSpacing: CGFloat = 50

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * spacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * spacing),
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            bodyLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        titleLabel.text = comment.name
        bodyLabel.text = comment.body
    }
}

