//
//  InvestmentsViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-28.
//

import UIKit
import CoreData

class InvestmentsViewController: UIViewController{
    
    //MARK: - Property
    var coreDataStack: CoreDataStack!
    var data = [CoinList]()
    var picker: UIPickerView!
    var investmentsArray = [Investment]()
    let ac = UIAlertController(title: "Add Investment.", message: "Add a new Investment.", preferredStyle: .alert)
    var investmentDataSource: UITableViewDiffableDataSource<InvestmentSection,Investment>!
    
    //MARK: - Outlets
    @IBOutlet var investmentTableView: UITableView!
    
    //MARK: - Actions
    @IBAction func addInvestmentAction(_ sender: UIBarButtonItem) {
        
        fetchCoin()
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
            let newInvestment = Investment(context: self.coreDataStack.managedContext)
            newInvestment.qnty = qnty
            newInvestment.price = price
            newInvestment.coin = self.data[self.picker.selectedRow(inComponent: 0)]
            newInvestment.coin_Id = self.data[self.picker.selectedRow(inComponent: 0)].coin_Id
            self.coreDataStack.saveContext()
            self.fetchInvestments()
        })
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        
        investmentDataSource = UITableViewDiffableDataSource(tableView: investmentTableView){
            tableView, index, item in
            let newCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.investmentCell.rawValue) as! CustomInvestmentTableViewCell
            newCell.coinSymbolLabel.text = item.coin.symbol
            newCell.coinQuantityLabel.text = "\(item.qnty)"
            newCell.marketValueLabel.text = currencyFormatter.string(from: item.coin.price as NSNumber)
            newCell.investmentValueLabel.text = "\(item.price)"
            return newCell
        }
        
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchInvestments()
    }
    
    //MARK: - Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<InvestmentSection, Investment>()
        snapshot.appendSections([.investment])
        snapshot.appendItems(investmentsArray)
        snapshot.reloadItems(investmentsArray)
        investmentDataSource.apply(snapshot)
    }
    func fetchInvestments(){
        print("Fetch Called")
        let fetchReq: NSFetchRequest<Investment> = Investment.fetchRequest()
        do{
            investmentsArray = try coreDataStack.managedContext.fetch(fetchReq)
            createSnapshot()
        }catch{
            print("There was an error loading Investments: \(error.localizedDescription)")
        }
    }
    func fetchCoin(){
        let fetchReq: NSFetchRequest<CoinList> = CoinList.fetchRequest()
        do{
            data = try coreDataStack.managedContext.fetch(fetchReq)
        }catch{
            print("error")
        }
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
        pickerView.resignFirstResponder()
    }
}
