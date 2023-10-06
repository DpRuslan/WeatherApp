//
//  MainViewController.swift
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    var viewModel: MainViewModel
    
    var weatherTableView = UITableView(frame: .zero, style: .plain)
    var forecastTableView = UITableView(frame: .zero, style: .plain)
    
    private var searchBar = UISearchBar(frame: .zero)
    private var cityLabel = UILabel(frame: .zero)
    private var currentIconImageView = UIImageView(frame: .zero)
    private var tempLabel = UILabel(frame: .zero)
    private var topLabel = UILabel(frame: .zero)
    private var forecastLabel = UILabel(frame: .zero)
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var loadingView = UIView(frame: .zero)
    private var activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    init() {
        viewModel = MainViewModel()
        
        super.init(nibName: nil, bundle: nil)
        
        setupBinder()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        hideKeyboardWhenTappedAround()
        viewModel.checkCoreData()
        
        view.addSubview(topLabel)
        view.addSubview(searchBar)
        view.addSubview(cityLabel)
        view.addSubview(tempLabel)
        view.addSubview(currentIconImageView)
        view.addSubview(weatherTableView)
        view.addSubview(forecastLabel)
        view.addSubview(forecastTableView)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MainViewController {
    private func setupBinder() {
        viewModel.eventPubisher.sink {[weak self] event in
            switch event {
            case .update:
                self?.populateData()
            case .error(let errorDescr):
                self?.present(UIAlertController.informativeAlert(title: "Error", message: errorDescr), animated: true)
            case .loading:
                self?.view.addSubview(self!.loadingView)
                self?.loadingView.addSubview(self!.activityIndicator)
                self?.activityIndicator.startAnimating()
            case .endLoading:
                self?.loadingView.removeFromSuperview()
                
            }
        }.store(in: &cancellables)
    }
}

extension MainViewController {
    private func setupUI() {
        topLabel.setStyle(textColor: .black, font: UIFont.boldSystemFont(ofSize: 35), isHidden: false)
        topLabel.text = viewModel.topLabelText
        
        searchBar.placeholder = viewModel.searchPlaceholder
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        currentIconImageView.contentMode = .scaleAspectFill
        currentIconImageView.isHidden = true
        currentIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 35), isHidden: true)
        tempLabel.setStyle(textColor: .black, font: UIFont.boldSystemFont(ofSize: 50), isHidden: true)
        forecastLabel.setStyle(textColor: .white, font: UIFont.boldSystemFont(ofSize: 25), isHidden: true)
        
        weatherTableView.configure(
            cell: WeatherCell.self,
            cellString: "WeatherCell",
            backgroundColor: .clear,
            separatorStyle: .none,
            isHidden: true,
            isScrollEnabled: false,
            cornerRadius: nil
        )
       
        forecastTableView.configure(
            cell: ForecastCell.self,
            cellString: "ForecastCell",
            backgroundColor: .white,
            separatorStyle: .singleLine,
            isHidden: true,
            isScrollEnabled: true,
            cornerRadius: 10
        )
        
        weatherTableView.dataSource = self
        forecastTableView.dataSource = self

        loadingView.frame = view.frame
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
    }
}

extension MainViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5),
            
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            
            tempLabel.centerXAnchor.constraint(equalTo: cityLabel.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 7),
            
            currentIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            currentIconImageView.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            currentIconImageView.widthAnchor.constraint(equalToConstant: 85),
            currentIconImageView.heightAnchor.constraint(equalTo: currentIconImageView.widthAnchor, multiplier: 1),
            
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherTableView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            weatherTableView.heightAnchor.constraint(equalToConstant: 140),
            
            forecastLabel.leadingAnchor.constraint(equalTo: weatherTableView.leadingAnchor),
            forecastLabel.topAnchor.constraint(equalTo: weatherTableView.bottomAnchor, constant: 15),
            
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            forecastTableView.topAnchor.constraint(equalTo: forecastLabel.bottomAnchor, constant: 5),
            forecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Called after receiving notification from request

extension MainViewController {
    private func populateData() {
        self.weatherTableView.reloadData()
        self.forecastTableView.reloadData()
        
        cityLabel.text = viewModel.cityName!
        tempLabel.text = viewModel.weatherTemp!
        currentIconImageView.image = viewModel.weatherImage
        
        forecastLabel.text = viewModel.tableViewHeaderText
        
        cityLabel.isHidden = false
        tempLabel.isHidden = false
        currentIconImageView.isHidden = false
        forecastLabel.isHidden = false
        weatherTableView.isHidden = false
        forecastTableView.isHidden = false
    }
}

// MARK: Hide keyboard when tapped around

extension MainViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}
