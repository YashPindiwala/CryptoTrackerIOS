//
//  InvestmentsViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-28.
//

import UIKit

class InvestmentsViewController: UIViewController{
    
    //MARK: - Property
    var coreDataStack: CoreDataStack!
    var data = [CoinList]()
    var picker: UIPickerView!
    var newInvestment: Investment!
    let ac = UIAlertController(title: "Add Investment.", message: "Add a new Investment.", preferredStyle: .alert)
    
    //MARK: - Outlets
    
    //MARK: - Actions
    @IBAction func addInvestmentAction(_ sender: UIBarButtonItem) {
        
        ac.addTextField(){
            field in
            field.placeholder = "Coin"
            field.inputView = self.picker
        }
        ac.addTextField(){
            field in
            field.placeholder = "Quantity"
            field.keyboardType = .decimalPad
        }
        ac.addTextField(){
            field in
            field.placeholder = "Buy Price"
            field.keyboardType = .decimalPad
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Save", style: .default){
            _ in
            guard let quantity = self.ac.textFields?[1].text else {return}
            guard let qnty = Double(quantity) else {return}
            guard let amount = self.ac.textFields?[2].text else {return}
            guard let price = Double(amount) else {return}
            self.newInvestment.qnty = qnty
            self.newInvestment.price = price
            print(self.newInvestment.description)
            self.coreDataStack.saveContext()
        })
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newInvestment = Investment(context: coreDataStack.managedContext)
        picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        // Do any additional setup after loading the view.
        
        let fetchReq = CoinList.fetchRequest()
        do{
            data = try coreDataStack.managedContext.fetch(fetchReq)
        }catch{
            print("error")
        }
    }
    
    //MARK: - Methods
    func addInvestment(){
        
    }
}

extension InvestmentsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ac.textFields?[0].text = data[row].name
        newInvestment.coin = data[row]
        newInvestment.coin_Id = data[row].coin_Id
        pickerView.resignFirstResponder()
    }
}
