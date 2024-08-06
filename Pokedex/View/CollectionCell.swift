//
//  CollectionCell.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/5/24.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(pokemonImageView)
        
        pokemonImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().offset(0) // Add insets if desired
            make.height.equalTo(pokemonImageView.snp.width)
        }
        
    }
    
    func configure(with pokemon: Pokemon) {
        let id = pokemon.url.split(separator: "/").last ?? ""
        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        // Load image from URL
        loadImage(from: imageURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self?.pokemonImageView.image = image
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

