//
//  PostCell.swift
//  PostCell
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    static let cellReuseId = "PostCell"
    
    let spacing: CGFloat = 10
    let titleSpacing: CGFloat = 50

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: titleSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * titleSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -1 * spacing),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * spacing),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * spacing),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}

