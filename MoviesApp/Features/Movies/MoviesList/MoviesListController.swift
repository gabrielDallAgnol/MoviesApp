//
//  MoviesListController.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit

class MoviesListController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var tableViewData = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
        tableView.reloadData()
    }
    
}

// MARK: - TableView DataSource and Delegate
extension MoviesListController : UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView(){
        tableViewData = DBService.shared.getMovies()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    func scrollToFirstRow() {
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }, completion: nil)
    }
    
    func movieSelected(movie: Movie) {
        let storyboard = self.storyboard
        let content = storyboard!.instantiateViewController(withIdentifier: "Details") as! MovieDetailsController
        
        content.movie = movie
        
        self.navigationController?.pushViewController(content, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell  else {fatalError("The dequeued cell is not an instance.")}
        cell.movie = tableViewData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = DBService.shared.getMovie(by: tableViewData[indexPath.row].id)
        movieSelected(movie: movie)
    }
}

// MARK: - CollectionView DataSource and Delegate
extension MoviesListController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SortCell", bundle: nil), forCellWithReuseIdentifier: "SortCell")
    }
    
    func deSelectAllItens() {
        let selectedItems = collectionView.indexPathsForSelectedItems ?? []
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated:true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBService.SortBy.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortCell", for: indexPath) as? SortCell else {fatalError("The dequeued cell is not an instance.")}
        self.searchBar.text = ""
        cell.text.text = DBService.SortOptions[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SortCell else {fatalError("The dequeued cell is not an instance.")}
        cell.isSelected = true
        tableViewData = DBService.shared.sort(byCase: DBService.SortBy(rawValue: cell.text.text!)!)
        scrollToFirstRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        collectionView.cellForItem(at: indexPath)?.isSelected = false
    }
}

// MARK: - SearchBar Delegate
extension MoviesListController : UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewData = DBService.shared.getMovies()
        self.searchBar.text = ""
        scrollToFirstRow()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deSelectAllItens()
        
        if searchBar.text != "" {
            tableViewData = DBService.shared.databaseSearch(string: searchText)
        } else {
            tableViewData = DBService.shared.getMovies()
            scrollToFirstRow()
        }
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
