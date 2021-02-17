//
//  ViewController.swift
//  CountriesListApp
//
//

import UIKit

class ViewController: UITableViewController {
    
    
    private var countries: [Country] = []
    private let cellID = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.dataSource = self
        
        NetworkManager.fetchData { countries in
            self.countries = countries
            self.tableView.reloadData()
        }
        
    }
    
    private func setupView(){
        view.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupNavigationBar(){
        title = "Country List"
        
        if #available(iOS 13.0, *){
            let titleImage = UIImage(systemName: "mappin.and.ellipse")
            let imageView = UIImageView(image: titleImage)
            self.navigationItem.titleView = imageView
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(infoItemTapped))
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                basicActionSheet(title: countries[indexPath.row].name, message: countries[indexPath.row].capital)
            }
        }
    }
    
    @objc private func infoItemTapped(){
        print("info tapped")
        basicAlert(title: "Info", message: "Long Press to open an action sheet!")
    }
}

//MARK: - TableView dataSource
extension ViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.capital
        if let region = country.region{
            cell.detailTextLabel?.text! += " from region: \(region)"
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController{
    private func basicAlert(title: String?, message: String?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func basicActionSheet(title: String?, message: String?){
        DispatchQueue.main.async {
            
            let actionSheet:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true)
        }
    }
}//End
