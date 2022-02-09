//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ivan Pryhara on 8.02.22.
//

import UIKit

class ConverterViewController: UIViewController, SelectCurrencyTableViewDelegate {
    //MARK: UI Elements
    let firstTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.font = UIFont(name: "SF Compact Display", size: 40)
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        
       return textField
    }()
    
    let secondTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.font = UIFont(name: "SF Compact Display", size: 40)
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let deleteButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark.circle.fill")
        configuration.baseForegroundColor = .systemGray
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    //MARK: Properties
    var firstCurrencyState: Currency = Currency(code: .BYN, exchangeRate: [.BYN : 1.0, .EUR : 0.34, .USD : 0.39, .HUF : 120.0])
    var secondCurrencyState: Currency = Currency(code: .USD, exchangeRate: [.USD : 1.0, .BYN : 2.57, .EUR : 0.88, .HUF: 309.51])
    
    //MARK: Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            firstTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -padding),
            firstTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            firstTextField.bottomAnchor.constraint(equalTo: secondTextField.topAnchor, constant: -padding),
            
            secondTextField.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: padding),
            secondTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            secondTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: Helper methods
    func configureView() {
        self.view.backgroundColor = .white
        navigationItem.title = "💸 Converter"

        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        secondTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(firstTextField)
        view.addSubview(secondTextField)
        
        firstTextField.leftViewMode = .always
        updateButtonState(firstButton, currency: firstCurrencyState)
        firstTextField.leftView = firstButton

        secondTextField.leftViewMode = .always
        updateButtonState(secondButton, currency: secondCurrencyState)
        secondTextField.leftView = secondButton
    }
    
    func updateTextFieldsState(_ sender: UITextField) {
        
        switch sender {
        case firstTextField :
            guard let tempText = firstTextField.text else { return }
            let text = tempText.replacingOccurrences(of: ",", with: ".")
            guard let number = Double(text) else {
                      secondTextField.text = ""
                      return
            }
            if let exchangeRate = firstCurrencyState.exchangeRate[secondCurrencyState.code] {
                self.secondTextField.text = String(number * exchangeRate)
            }
        case secondTextField:
            guard let tempText = secondTextField.text else { return }
            let text = tempText.replacingOccurrences(of: ",", with: ".")
            guard let number = Double(text) else {
                      firstTextField.text = ""
                      return
            }
            if let exchangeRate = secondCurrencyState.exchangeRate[firstCurrencyState.code] {
                self.firstTextField.text = String(number * exchangeRate)
            }
        default:
            return
        }
    }
    
    func updateButtonState(_ sender: UIButton, currency: Currency) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemGray
        config.title = currency.code.rawValue
        sender.configuration = config
    }
    
    ///  Summary Summary Summary Summary
    /// - Parameter controller: Class using delegate
    /// - Parameter currency: Given value
    /// - Parameter isFirstButton: Boolean that diffirintiates that class has been initialized within first button
    /// - Returns: Nothing
    func selectCurrencyTableViewController(_ controller: SelectCurrencyTableViewController, didSelect currency: Currency, isFirstButton: Bool) {
        if isFirstButton {
            self.firstCurrencyState = currency
            updateButtonState(firstButton, currency: firstCurrencyState)
            firstTextField.text = ""
            secondTextField.text = ""
        } else {
            self.secondCurrencyState = currency
            updateButtonState(secondButton, currency: secondCurrencyState)
            firstTextField.text = ""
            secondTextField.text = ""
        }
    }
    
    // MARK: Selectors
    @objc func configureButtonTapped() {
        view.window?.overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
    }
    
    @objc func firstButtonTapped() {
        let currencyTableView =  SelectCurrencyTableViewController()
        currencyTableView.currency = firstCurrencyState
        currencyTableView.isFirstButton = true
        currencyTableView.delegate = self
        navigationController?.pushViewController(currencyTableView, animated: true)
    }
    
    @objc func secondButtonTapped() {
        let currencyTableView = SelectCurrencyTableViewController()
        currencyTableView.currency = secondCurrencyState
        currencyTableView.isFirstButton = false
        currencyTableView.delegate = self
        navigationController?.pushViewController(currencyTableView, animated: true)
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateTextFieldsState(sender)
    }
}
