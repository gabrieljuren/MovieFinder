//
//  CustomTableViewCell.swift
//  MovieFinder
//
//  Created by Gabriel Juren on 26/11/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    private let _imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "teste"
        return label
    }()
    
    private let labelYear: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(labelYear)
        contentView.addSubview(_imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: MovieFinder.ViewController.Movie) {
        label.text = model.Title
        labelYear.text = model.Year
        
        if let data = try? Data(contentsOf: URL(string: model.Poster)!) {
            _imageView.image = UIImage(data: data)
        }
    }
    
    func setLayout() {
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        _imageView.heightAnchor.constraint(equalToConstant: 322).isActive = true
        _imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        _imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 115).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        labelYear.translatesAutoresizingMaskIntoConstraints = false
        labelYear.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        labelYear.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
    }
}
