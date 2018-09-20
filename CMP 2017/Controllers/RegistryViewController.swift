//
//  RegistryViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Photos

class RegistryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Vars -
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var termsCheckButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var avatarPhotoURL: URL!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.layer.cornerRadius = 5
        fullNameTextField.layer.borderWidth = 1
        fullNameTextField.layer.borderColor = UIColor.white.cgColor
        lastNameTextField.layer.cornerRadius = 5
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 5
        termsCheckButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func photoPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("PicturesSource", comment:""), preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("SourceCamera", comment:""), style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: {

            })
            
        })
        
        let libraryAction = UIAlertAction(title: NSLocalizedString("SourceLibrary", comment:""), style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(UIAlertAction(title:NSLocalizedString("DialogCancel", comment:""), style: .cancel, handler: nil))
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if validateFields() {
            SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressCreateAccount", comment:""))
            WSHelper.sharedInstance.createUser(email: emailTextField.text!, password: passwordTextField.text!, name: fullNameTextField.text!, lastName: lastNameTextField.text!) { (_ response:Any? , _ error: Error?) in
                if error == nil {
                    self.avatarImageView.image!.resizedTo1MB(completionHandler: { (image: UIImage?, data: NSData?) in
                        SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressUploadAvatar", comment:""))
                        WSHelper.sharedInstance.uplooadAvatar(data! as Data, email: self.emailTextField.text!, result: { (response, error) in
                            if error == nil {
                                WSHelper.sharedInstance.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, withResult: { (_ response:Any?, _ error: Error?) in
                                    SVProgressHUD.dismiss()
                                    if (error == nil) {
                                        SessionHelper.instance.saveSessionInfo(response as! NSDictionary)
                                        self.showAddEventScreen()
                                    } else {
                                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                                    }
                                })
                            }
                        })
                    })
                } else {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        signUpButton.isEnabled = sender.isSelected
    }
    
    func validateFields() -> Bool {
        if fullNameTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorName", comment:""))
            return false
        } else if lastNameTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorLastName", comment:""))
            return false
        } else if emailTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorEmail", comment:""))
            return false
        } else if !(emailTextField.text?.isValidMail())! {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorInvalidEmail", comment:""))
            return false
        } else if passwordTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorPassword", comment:""))
            return false
        } else if self.avatarPhotoURL == nil {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorNoPhoto", comment:""))
            return false
        } else {
            return true
        }
    }

    func showAddEventScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEvent")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage!
        if info [UIImagePickerControllerEditedImage] != nil{
            image = info[UIImagePickerControllerEditedImage] as! UIImage
            avatarImageView.image = image
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
            avatarImageView.image = image
        }
        if (picker.sourceType == .camera) {
            SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressSaveImage", comment: ""))
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            self.avatarPhotoURL = info[UIImagePickerControllerReferenceURL] as! URL
        }
        
        
        dismiss(animated:true, completion: nil)
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        SVProgressHUD.dismiss()
        fetchLastImage { (path: String?) in
            
            if let imagePath = path  {
                let url = URL(fileURLWithPath: imagePath)
                let imageName = url.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
                
                // getting local path
                let localPath = (documentDirectory as NSString).appendingPathComponent(imageName)
                self.avatarPhotoURL = URL(fileURLWithPath: localPath)
                //getting actual image

            }
        }
    }
    
    func fetchLastImage(completion: (_ localIdentifier: String?) -> Void)
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if (fetchResult.firstObject != nil)
        {
            let lastImageAsset: PHAsset = fetchResult.firstObject as! PHAsset
            completion(lastImageAsset.localIdentifier)
        }
        else
        {
            completion(nil)
        }
    }
    
}
