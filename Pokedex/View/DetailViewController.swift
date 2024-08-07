import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    var pokemon: Pokemon?
    
    private let disposeBag = DisposeBag()
    private let viewModel = DetailViewModel()
    
    let subImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.darkRed
        image.layer.cornerRadius = 10
        return image
    }()
    
    let pokemonImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.darkRed
        return image
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "NO."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "타입:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "무게:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainRed
        configure()
        setupBindings()
        
        if let pokemon = pokemon {
            let id = pokemon.url.split(separator: "/").last ?? ""
            viewModel.fetchPokemonDetails(for: String(id))
            setupPokemonImage(id: String(id))
        }
    }
    
    private func configure() {
        [subImage, pokemonImage, numberLabel, nameLabel, typeLabel, heightLabel, weightLabel].forEach { view.addSubview($0) }
        
        subImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-350)
        }
        
        pokemonImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(pokemonImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(-50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(pokemonImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(50)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.pokemonDetail
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] pokemonDetail in
                self?.updateUI(with: pokemonDetail)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { error in
                print("Error fetching Pokémon details: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPokemonImage(id: String) {
        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        if let url = URL(string: imageURL) {
            NetworkManager.shared.fetchImage(from: url)
                .observe(on: MainScheduler.instance) // Ensure UI updates are on the main thread
                .subscribe(onNext: { [weak self] image in
                    self?.pokemonImage.image = image
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func updateUI(with pokemonDetail: PokemonDetail) {
        DispatchQueue.main.async {
            self.nameLabel.text = PokemonTranslator.getKoreanName(for: pokemonDetail.name)
            self.numberLabel.text = "NO.\(pokemonDetail.id)"
            self.heightLabel.text = "키: \(pokemonDetail.height) m"
            self.weightLabel.text = "무게: \(pokemonDetail.weight) Kg"
            self.typeLabel.text = "타입: \(pokemonDetail.types.map { PokemonTypeName(rawValue: $0.type.name)?.displayName ?? $0.type.name }.joined(separator: ", "))"
        }
    }
}
