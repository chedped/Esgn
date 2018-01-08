//
//  SellItemViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/26/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Cosmos

class SellItemViewController: MWZBaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var textSellPrice: UITextField!
    @IBOutlet weak var labelFee: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lcCenterY: NSLayoutConstraint!
    
    var item: InventoryItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textSellPrice.delegate = self
        
        let attribute:[String:Any] = [NSFontAttributeName: textSellPrice.font!,
                                      NSForegroundColorAttributeName: textSellPrice.textColor!]
        
        textSellPrice.attributedPlaceholder = NSAttributedString(string: "THB", attributes: attribute)
        let gesture = UITapGestureRecognizer { (sender, state, point) in
            self.view.endEditing(true)
        }
        self.view.addGestureRecognizer(gesture!)
    
        labelTitle.text = item.name
        if let imgURL = item.image, !imgURL.isEmpty {
            imgItem.sd_setImage(with: URL(string: imgURL))
        }
        labelDesc.text = item.desc
        ratingStar.rating = item.avg_rate
        
        self.view.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentView( inView: UIView! ) {
        
        inView.addSubview(self.view)
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.view.alpha = 1
        }) { (finished) in
            
        }
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.contentView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
                        self.view.alpha = 0
        }) { (finished) in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func onClose( _ sender: AnyObject ) {
        self.dismiss()
    }
    
    @IBAction func onAccept( _ sender: AnyObject ) {
        self.btnCheckbox.isSelected = !btnCheckbox.isSelected
    }
    
    @IBAction func onSell( _ sender: AnyObject ) {
        
        self.view.endEditing(true)
        
        guard let text = textSellPrice.text, !text.isEmpty else {
            self.showAPIAlertWithMessage("Please enter Item's Price")
            return
        }
        
        guard let price = Double(text), price != 0 else {
            self.showAPIAlertWithMessage("Please enter Item's Price")
            return
        }
        
        guard btnCheckbox.isSelected == true else {
            self.showAPIAlertWithMessage("Please accept Terms and Conditions")
            return
        }
        
        ProgressHUD.show(self.view)
        
        API.sellItem(withToken: UserProfile.sharedInstance.token!,
                     item_id: item.item_id,
                     price: price,
                     pin: false) { (json, error) in
                        
                        ProgressHUD.hiden(self.view, animated: true)
                        if error != nil {
                            self.showAPIAlertWithError(error)
                        }
                        else {
                            let info: [String:Any] = ["item_id":self.item.item_id]
                            NotificationCenter.default.post(name: Notifications.sellingItem.name, object: nil, userInfo: info)
                            self.dismiss()
                        }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SellItemViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //lcCenterY.constant = -50
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //lcCenterY.constant = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: NSMutableString = NSMutableString(string: textField.text ?? "")
        text.replaceCharacters(in: range, with: string)
        
        guard text.length > 0 else {
            labelTotalPrice.text = "THB"
            return true
        }
        
        guard let price = Double(text as String), price != 0 else {
            labelTotalPrice.text = "THB"
            return true
        }
        
        labelTotalPrice.text = String(format: "%.2f THB", price)
        return true
    }
}
