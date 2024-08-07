import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pokemonBall")
        return image
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = -15
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.darkRed
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: "PokemonCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        view.backgroundColor = UIColor.mainRed
        
        collectionView.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(logoImage)
        view.addSubview(collectionView)
        
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    private func bindViewModel() {
        viewModel.pokemonList
            .bind(to: collectionView.rx.items(cellIdentifier: "PokemonCell", cellType: PokemonCollectionViewCell.self)) { [weak self] _, pokemon, cell in
                cell.configure(with: pokemon)
                cell.imageTapped
                    .subscribe(onNext: { [weak self] pokemon in
                        self?.viewModel.selectPokemon(pokemon)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { error in
                // Handle error (e.g., show an alert)
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedPokemon
            .subscribe(onNext: { [weak self] pokemon in
                self?.navigateToDetailView(with: pokemon)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToDetailView(with pokemon: Pokemon) {
        let detailVC = DetalViewController()
        // Pass the Pokémon data to the detail view controller
        detailVC.pokemon = pokemon
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate cell width
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let minimumInteritemSpacing = layout.minimumInteritemSpacing
        let totalSpacing = sectionInsets.left + sectionInsets.right + (2 * minimumInteritemSpacing)
        let width = (collectionView.bounds.width - totalSpacing) / 3
        
        return CGSize(width: width, height: width + 30) // Adjust height if needed
    }
}
