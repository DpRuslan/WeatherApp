//
//  MainViewController+SearchBar.swift
//

import UIKit

//MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let convertedString = searchBar.searchTextField.text!.replacingOccurrences(of: " ", with: "%20")
        viewModel.request(cityName: convertedString)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchText.isEmpty ? DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        } : nil
    }
}
