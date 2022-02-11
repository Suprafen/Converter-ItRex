//
//  CurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Ivan Pryhara on 9.02.22.
//

import UIKit

protocol SelectCurrencyTableViewDelegate: AnyObject {
    /// Method for performing transfer data between views
    /// - Parameter controller: Controller that uses delegate
    /// - Parameter currency: Selected currency, which will be sent
    /// - Parameter isFirstButton: True - if method has been called from first button, otherwise false
    /// - Returns: Nothing
    func selectCurrencyTableViewController(_ controller: SelectCurrencyTableViewController, didSelect currency: Currency, isFirstButton: Bool)
}

class SelectCurrencyTableViewController: UITableViewController {

    enum Section { case main }
    
    weak var delegate: SelectCurrencyTableViewDelegate?
    var isFirstButton: Bool?
    var currency: Currency?
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Currency>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Currency>
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.reuseIdentifier)
        configureDataSource()
    }

    //MARK: Helper methods
    func configureDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, currency -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reuseIdentifier, for: indexPath) as! CurrencyTableViewCell
            
            cell.configure(with: currency)
            // Place checkmark alongside picked currency
            if self.currency == Currency.availableCurrencies[indexPath.row] {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        })
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Currency.availableCurrencies, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currency = Currency.availableCurrencies[indexPath.row]
        self.currency = currency
        guard let isFirstButton = isFirstButton else { return }
        delegate?.selectCurrencyTableViewController(self, didSelect: currency, isFirstButton: isFirstButton)
        tableView.reloadData()
    }
}
