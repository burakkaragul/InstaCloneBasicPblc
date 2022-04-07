//
//  FeedViewController.swift
//  InstaCloneFirebaseBsc
//
//  Created by Burak Karagül on 27.01.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
   
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray=[String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()


    }
    
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                
                if snapshot?.isEmpty != true{
                    
                    
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    

                    
                    for document in snapshot!.documents{
                       let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let like = document.get("likes") as? Int{
                            self.likeArray.append(like)
                        }
                        if let imageURL = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageURL)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FeedCell
        
        
        cell.userEmailLabel.text=userEmailArray[indexPath.row]
        cell.userLikeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    

    

}
