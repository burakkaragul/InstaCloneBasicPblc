//
//  UploadViewController.swift
//  InstaCloneFirebaseBsc
//
//  Created by Burak Karagül on 27.01.2022.
//

import UIKit
import Firebase



class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func chooseImage(){
        
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        

        
    }
    
    
    func makeAlert(titleInput:String, messageInput:String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
            
            let storage = Storage.storage()

            
            let storageReference = storage.reference()
            
            
            let mediaFolder = storageReference.child("media")
        
ü        
        if let dataa = imageView.image?.jpegData(compressionQuality: 0.5){
            
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            
            imageReference.putData(dataa, metadata: nil) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                
                    imageReference.downloadURL { url, error in
                        
                        if error == nil{
                            
                            let imageUrl = url
                            
                            
                            //DATABASE işlemleri
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            
                            var firestoreReference : DocumentReference?
                            
                            
                            let firestorePost = ["imageUrl" : imageUrl!.absoluteString, "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]

                            
//                              Yükleme işlemi
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                                    
                                }else{
//                                    İşlem tamamlandıktan sonra ana ekrana tekrar dönülmesi ve alanın temizlenmesi
                                    
                                    self.imageView.image = UIImage(systemName:"photo.fill")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                        
                    }
                    }
                    
                }
            }
        }
    }
    


}
