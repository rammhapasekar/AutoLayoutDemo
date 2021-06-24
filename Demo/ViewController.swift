//
//  ViewController.swift
//  Demo
//
//  Created by Ram Mhapasekar on 22/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var upiIdTF: CustomTextField!
    @IBOutlet weak var beneficiaryNameTF: CustomTextField!
    @IBOutlet weak var startDateTF: CustomTextField!
    @IBOutlet weak var endDateTF: CustomTextField!
    @IBOutlet weak var amountTF: CustomTextField!
    @IBOutlet weak var frequencyTF: CustomTextField!
    @IBOutlet weak var remarksTF: CustomTextField!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    //MARK:- Views
    lazy var bar = UIToolbar()
    
    //MARK:- viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        setupTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
    
    //MARK:- Setup
    /**
     This method will setup view for textField
     */
    fileprivate func setupTextFields(){
        ///1. settings for right image view
        upiIdTF.isRightViewVisible = true
        beneficiaryNameTF.isRightViewVisible = true
        frequencyTF.isRightViewVisible = true
        remarksTF.isRightViewVisible = true
        
        ///2. set datepicker view for date fields
        startDateTF.setDatePickerAsInputViewFor(target: self, selector: #selector(startDateSelected))
        endDateTF.setDatePickerAsInputViewFor(target: self, selector: #selector(endDateSelected))
        
        ///3. add inputAccessoryView to amountTF
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        done.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        flexibleSpace.tintColor = .systemPurple
        
        bar.backgroundColor = UIColor.systemPurple
        
        bar.items = [flexibleSpace, done]
        bar.sizeToFit()
        amountTF.inputAccessoryView = bar
        
        ///4. checkbox button setup
        checkBoxBtn.setImage(UIImage(systemName: "square"), for: .normal)
        checkBoxBtn.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    }
    
    //MARK:- Button Actions
    @objc func startDateSelected() {
        if let datePicker = self.startDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.startDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        self.startDateTF.resignFirstResponder()
    }
    
    @objc func endDateSelected() {
        if let datePicker = self.endDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.endDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        self.endDateTF.resignFirstResponder()
    }
    
    /**
     `doneButtonPressed` method will handle the amount textfield keyboard handling
     */
    @objc func doneButtonPressed(){
        ///1. Resign responder from amount textfield
        amountTF.resignFirstResponder()
        
        ///2. check the amount text and for valid double value set 2 digit decimal amount value into the amount textfield
        if let amountText = amountTF.text, let amountValue = Double(amountText){
            let formatted = String(format: "%.2f", amountValue)
            amountTF.text = formatted
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButtonX) {
        sender.alpha = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.alpha = 1.0
        }
    }
    
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
}

//MARK:- TextField delegate methods
extension ViewController: UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        /**handle keyboard view inside scrollview*/
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTF{
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        return true
    }
}
