//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Ivan Pryhara on 9.02.22.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CurrencyCell"
    
    let label: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "SF Compact Display", size: 40)
        
        label.textColor = .systemGray
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder hasn't been initialized")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    func configure(with currency: Currency) {
        label.text = currency.code.rawValue
    }
}
