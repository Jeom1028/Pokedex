import UIKit
import RxSwift
import RxCocoa

class PokemonCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    var imageTapped = PublishSubject<Pokemon>()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(pokemonImageView)
        pokemonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        let tapGesture = UITapGestureRecognizer()
        pokemonImageView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                guard let self = self, let pokemon = self.pokemon else { return }
                self.imageTapped.onNext(pokemon)
            })
            .disposed(by: disposeBag)
    }
    
    var pokemon: Pokemon? {
        didSet {
            if let pokemon = pokemon {
                // Update the image view with the Pokemon image URL
                let id = pokemon.url.split(separator: "/").last ?? ""
                let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
                
                if let url = URL(string: imageURL) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.pokemonImageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(with pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
