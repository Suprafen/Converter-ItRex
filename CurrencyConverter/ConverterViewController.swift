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
    
    //MARK: Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Tap gesture for dismissing keyboard by tapping anywhere when text editing active
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
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
    /// Check which text field is making editing.
    ///
    ///  Method is responsible for:
    /// - Replacement commas on dots (because particular languages have commas instead dots in numeric keyboard)
    /// - Rounding values to two digits after decimal point
    /// - Dynamically change value of another text field
    ///
    /// - Parameter sender: Text field which is being edited
    /// - Returns: Nothing
    func updateTextFieldsState(_ sender: UITextField) {
        
        switch sender {
        case firstTextField :
            // Check whether textfield contains text
            guard let tempText = firstTextField.text else { return }
            var text = tempText.replacingOccurrences(of: ",", with: ".")
            // If the text contained more than 1 comma or dot, element would be removed
            if text.contains([".", ","], moreThan: 1) {
                firstTextField.text!.removeLast()
                text.removeLast()
            }
            
            guard let number = Double(text) else {
                      secondTextField.text = ""
                      return
            }
            // Get the value for corresponding currency from dictionary
            if let exchangeRate = firstCurrencyState.exchangeRate[secondCurrencyState.code] {
                // Round to hundredths
                let roundedValue = round(number * exchangeRate * 100) / 100
                self.secondTextField.text = String(roundedValue)
            }
        case secondTextField:
            // Check whether textfield contains text
            guard let tempText = secondTextField.text else { return }
            var text = tempText.replacingOccurrences(of: ",", with: ".")
            // If the text contained more than 1 comma or dot, element would be removed
            if text.contains([".", ","], moreThan: 1) {
                secondTextField.text!.removeLast()
                text.removeLast()
            }
            
            guard let number = Double(text) else {
                firstTextField.text = ""
                return
            }
            // Get the value for corresponding currency from dictionary
            if let exchangeRate = secondCurrencyState.exchangeRate[firstCurrencyState.code] {
                //round to hundredths
                let roundedValue = round(number * exchangeRate * 100) / 100
                self.firstTextField.text = String(roundedValue)
            }
        default:
            return
        }
    }
    /// Update button appearance according to currency
    /// - Parameter sender: Button which need to be updated
    /// - Parameter currency: Currency which need to be showed on the button's appearance
    /// - Returns: Nothing
    func updateButtonState(_ sender: UIButton, currency: Currency) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemGray
        config.title = currency.code.rawValue
        sender.configuration = config
    }
    // Delegate method
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
    @objc func firstButtonTapped() {
        let currencyTableView =  SelectCurrencyTableViewController()
        currencyTableView.currency = firstCurrencyState
        currencyTableView.isFirstButton = true
        currencyTableView.delegate = self
        view.endEditing(true)
        navigationController?.pushViewController(currencyTableView, animated: true)
    }
    
    @objc func secondButtonTapped() {
        let currencyTableView = SelectCurrencyTableViewController()
        currencyTableView.currency = secondCurrencyState
        currencyTableView.isFirstButton = false
        currencyTableView.delegate = self
        view.endEditing(true)
        navigationController?.pushViewController(currencyTableView, animated: true)
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateTextFieldsState(sender)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
// MARK: Extensions
extension String {
    /// Method for checking string on containing specific elements
    /// - Returns: True if string contains more than given elements in itself
    func contains(_ elements: [String.Element], moreThan maxValueOfElment: Int) -> Bool {
        var symbolCounter = 0
        for i in elements {
            for textIndex in self {
                if textIndex == i {
                    symbolCounter += 1
                }
            }
        }
        if symbolCounter > maxValueOfElment {
            return true
        } else {
            return false
        }
    }
}
