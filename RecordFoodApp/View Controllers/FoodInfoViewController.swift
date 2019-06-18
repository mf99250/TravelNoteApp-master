//
//  FoodInfoViewController.swift
//  RecordFoodApp
//
//  Created by mac on 2018/10/17.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

protocol  EditFoodTableViewControllerDelegate  {
    func  update(food:  Food)
}

class FoodInfoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    

     var  food:  Food?
    var  delegate: EditFoodTableViewControllerDelegate?
    var foodimage : Data?
    var formatter: DateFormatter!
    
    let type = ["團體旅遊","自由行","團體自由行","其他"]
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var introdcutionTextField: UITextView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeNameTextField.delegate = self
        addressTextField.delegate = self
        phoneNumberTextField.delegate = self
        introdcutionTextField.delegate = self
        
        
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.date = NSDate() as Date
        
        // 設置 UIDatePicker 改變日期時會執行動作的方法
        myDatePicker.addTarget(
            self,
            action: #selector(FoodInfoViewController.datePickerValueChanged),
            for: .valueChanged)
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        foodNameTextField.inputView = myDatePicker
        foodNameTextField.tag = 200
        
        if let food = food {
            foodImageView.image = UIImage(data: food.image)
            foodNameTextField.text = food.name
            storeNameTextField.text = food.storeName
            addressTextField.text = food.address
            phoneNumberTextField.text = food.phoneNumber
            introdcutionTextField.text = food.introduction
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DatePicker(_ sender: UITextField) {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.date = NSDate() as Date
        
        // 設置 UIDatePicker 改變日期時會執行動作的方法
        myDatePicker.addTarget(
            self,
            action: #selector(FoodInfoViewController.datePickerValueChanged),
            for: .valueChanged)
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        foodNameTextField.inputView = myDatePicker
        foodNameTextField.tag = 200
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {

        // 依據元件的 tag 取得 UITextField
        let myTextField = self.view?.viewWithTag(200) as? UITextField
        // 將 UITextField 的值更新為新的日期
        myTextField?.text = formatter.string(from: sender.date)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let image = foodImageView.image?.pngData(),let name = foodNameTextField.text,let storeName = storeNameTextField.text,let address = addressTextField.text,let phoneNumber = phoneNumberTextField.text,let introdcution = introdcutionTextField.text else {
            return
        }
        food = Food(image: image, name: name,storeName: storeName, address: address, phoneNumber: phoneNumber, introduction: introdcution )
        delegate?.update(food:  food!)
        navigationController?.popViewController(animated:  true)
    }
    @IBAction func keyEnd(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func changePhoto(_ sender: Any) {
        let foodActionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        
        let foodAlbumAction = UIAlertAction(title: "從相冊選擇", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
            self.initPhotoPicker()
            
        }
        
        let foodPhotoAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
            
            self.initCameraPicker()
            
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){ (action:UIAlertAction)in
            
            
        }
        
        
        foodActionSheet.addAction(foodAlbumAction)
        foodActionSheet.addAction(foodPhotoAction)
        foodActionSheet.addAction(cancelAction)
        
        foodActionSheet.popoverPresentationController?.sourceView = self.view
        foodActionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.frame.maxX/2, y: view.frame.maxY, width: 1.0, height: 1.0)
        
        self.present(foodActionSheet, animated: true, completion: nil)

    }
    //從相冊選擇
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    //拍照
    func initCameraPicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            
            print("不支持拍照")
            
        }
        
    }
    //相機
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        
        //將圖片顯示在畫面上
        foodImageView.image = image
        self.foodimage = image.pngData()
        
        // 退出相機介面
        picker.dismiss(animated: true, completion: nil)
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
            
            
        } else {
            
            print("保存成功")
            
            
        }
    }
}
