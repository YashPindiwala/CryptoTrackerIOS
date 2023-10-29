//
//  InvestmentsViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-28.
//

import UIKit

class InvestmentsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: - Property
    var coreDataStack: CoreDataStack!
    var data = [CoinList]()
    var picker: UIPickerView!
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
        ac.addAction(UIAlertAction(title: "Save", style: .default))
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
