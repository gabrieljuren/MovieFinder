//
//  ViewController.swift
//  MovieFinder
//
//  Created by Gabriel Juren on 24/11/21.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var movies = [Movie]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = 420
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.font = UIFont(name: "Avenir", size: 17.5)
        textField.placeholder = "Find Movie"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5, height: 1.5))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: 45).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return textField
    }()
    
    private let labelNoMovies: UILabel = {
        let label = UILabel()
        label.text = "The list is empty!"
        label.font = UIFont(name: "Avenir", size: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        view.addSubview(textField)
        view.addSubview(labelNoMovies)
        view.addSubview(tableView)
        setLayout()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: (URL(string: url)!))
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.isHidden = false
        textField.resignFirstResponder()
        getMovies()
        return true
    }
    
    func getMovies() {
        guard let text = textField.text else {
            return
        }
        
        movies.removeAll()
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=85295e63&s=\(text.trimmingCharacters(in: .whitespacesAndNewlines))&type=movie")!, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print(error)
            }
            
            guard let finalResult = result else {
                return
            }
            
            self.movies.append(contentsOf: finalResult.Search)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }).resume()
    }
    
    struct MovieResult: Decodable {
        let Search: [Movie]
    }
    
    struct Movie: Codable {
        let Title: String
        let Year: String
        let imdbID: String
        let Poster: String
        
        enum CondingKeys: String, CodingKey {
            case Title
            case Year
            case imdbID
            case _Type = "Type"
            case Poster
        }
    }
    
    func setLayout() {
        overrideUserInterfaceStyle = .light
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        labelNoMovies.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        labelNoMovies.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.isHidden = movies.count == 0
    }
}

