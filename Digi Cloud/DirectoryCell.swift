//
//  DirectoryCell.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 19/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

final class DirectoryCell: BaseListCell {

    // MARK: - Properties

    var isShared: Bool = false {
        didSet {
            setupSharedLabel()
        }
    }
    
    var isBookmarked: Bool = false {
        didSet {
            setupBookmarkLabel()
        }
    }

    let sharedLabel: UILabelWithPadding = {
        let l = UILabelWithPadding(paddingTop: 2, paddingLeft: 20, paddingBottom: 2, paddingRight: 20)
        l.text = NSLocalizedString("SHARED", comment: "")
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 8)
        l.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
        l.textAlignment = .center
        l.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let bookmarkLabel: UILabelWithPadding = {
        let l = UILabelWithPadding(paddingTop: 4, paddingLeft: 15, paddingBottom: 1, paddingRight: 15)
        l.text = "\u{f006}"
        l.textColor = .white
        l.font = UIFont.fontAwesome(size: 9)
        l.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.1, alpha: 0.6)
        l.textAlignment = .center
        l.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var hasUploadLink: Bool = false

    // MARK: - Overridden Methods and Properties

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconImageView.image = UIImage(named: "FolderIcon")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if self.isEditing { return }

        if highlighted {
            sharedLabel.alpha = 0
        } else {
            sharedLabel.alpha = 1
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sharedLabel.alpha = editing ? 0: 1
    }

    // MARK: - Helper Functions

    private func setupSharedLabel() {

        if isShared {
            contentView.addSubview(sharedLabel)
            NSLayoutConstraint.activate([
                sharedLabel.centerXAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
                sharedLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
            ])
        } else {
            sharedLabel.removeFromSuperview()
        }
    }
    
    
    private func setupBookmarkLabel() {
        if isBookmarked {
            contentView.addSubview(bookmarkLabel)
            NSLayoutConstraint.activate([
                bookmarkLabel.centerXAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
                bookmarkLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
            ])
        } else {
            bookmarkLabel.removeFromSuperview()
        }
    }
}
