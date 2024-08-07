import UIKit
import SnapKit
import RxSwift

class DetalViewController: UIViewController {
    
    var pokemon: Pokemon?
    
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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainRed
        configure()
        setupData()
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
            $0.centerX.equalToSuperview().offset(-60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(pokemonImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(60)
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
    
    private func setupData() {
        guard let pokemon = pokemon else { return }
        
        // Update the UI with the Pokémon's data
        nameLabel.text = pokemon.name
        
        let id = pokemon.url.split(separator: "/").last ?? ""
        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        if let url = URL(string: imageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.pokemonImage.image = image
                    }
                }
            }
        }
        
        // Fetch additional details if needed
        fetchPokemonDetails(for: String(id))
    }
    
    private func fetchPokemonDetails(for id: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }
        
        NetwoerManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (pokemonDetail: PokemonDetail) in
                    self?.updateUI(with: pokemonDetail)
                },
                onFailure: { error in
                    print("Error fetching Pokémon details: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with pokemonDetail: PokemonDetail) {
        DispatchQueue.main.async {
            self.numberLabel.text = "NO.\(pokemonDetail.id)"
            self.heightLabel.text = "키: \(pokemonDetail.height) m"
            self.weightLabel.text = "무게: \(pokemonDetail.weight) Kg"
            self.typeLabel.text = "타입: \(pokemonDetail.types.map { $0.type.name }.joined(separator: ", "))"
        }
    }
}
