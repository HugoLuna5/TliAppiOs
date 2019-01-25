//
//  Comunidad.swift
//  Tli App
//
//  Created by Hugo Luna on 1/17/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import WCLShineButton
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

protocol SwiftyTableViewCellDelegateFeed : class {
    func TapButtonFeed(_ sender: CustomCellFeed)
    func TapGestureFeed(_ sender: CustomCellFeed)
}


var likeGlobal = false


class CustomCellFeed: UITableViewCell {
    
    
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var btn: WCLShineButton!
    @IBOutlet weak var countComentarios: UILabel!
    
    @IBOutlet weak var countLikes: UILabel!
    
    private var allButtons: [WCLShineButton] {
        return [btn]
    }
    
    
    
    weak var delegate: SwiftyTableViewCellDelegateFeed?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(_:)))
        photoUser.addGestureRecognizer(tapGesture)
        photoUser.isUserInteractionEnabled = true
        //tapGesture.delegate = ViewController()
        
        
        photoUser.layer.borderWidth = 1
        photoUser.layer.masksToBounds = false
        photoUser.layer.borderColor = UIColor.white.cgColor
        photoUser.layer.cornerRadius = photoUser.frame.height/2
        photoUser.clipsToBounds = true
        
        
    }
    @objc func tapEdit(_ sender: UITapGestureRecognizer) {
        delegate?.TapGestureFeed(self)
        print("Click gesture")
        print("Click photo user")
    }
    
    
    @IBAction func likeButtonChange(_ sender: WCLShineButton) {
        delegate?.TapButtonFeed(self)
        print("Clicked origin \(sender.isSelected)")
        
        
    }
    
    
    
    
    
    
    
    /*
     @IBAction func likeButton(_ sender: FaveButton) {
     delegate?.TapButton(self)
     
     }
     */
    
}




var DatabaseLikePush: DatabaseReference!
var userIDProfileFeed = ""

class Comunidad: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate, SwiftyTableViewCellDelegateFeed {
    
    
    
    
    @IBOutlet weak var tableview: UITableView!
    var feeds = [Feed]()
    var feedsRever = [Feed]()
    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        loadPosts()
      
    }
    
    func loadPosts(){
        var mDatabase: DatabaseReference!
        mDatabase = Database.database().reference()
        self.feeds.removeAll()
        self.feedsRever.removeAll()
        mDatabase.child("Blog").queryOrdered(byChild: "time").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let content = dict["content"] as! String
                let type = dict["type"] as! String
                let time = dict["time"] as! CLong
                let id_post = dict["id_post"] as! String
                let uid = dict["uid"] as! String
                
                let feed = Feed(id_postText: id_post, timeLong: time, contentText: content, uidText: uid, typeText: type)
                
                self.feeds.append(feed)
                self.feedsRever = self.feeds.reversed()
                self.tableview.reloadData()
                
            }
            
        }
        
        
    }
    
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "COMUNIDAD")
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedsRever.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFeed", for: indexPath) as! CustomCellFeed
        let post_key = feedsRever[indexPath.row].id_post
        self.tableview.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0);
        
        
        
        cell.desc.text = feedsRever[indexPath.row].content
        var mDatabase: DatabaseReference!
        
        mDatabase = Database.database().reference().child("Users").child(feedsRever[indexPath.row].uid)
        
        mDatabase.observe(DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            
            cell.username.text = (user["name"]  as! String)
            
            if user["thumb_photo"] as! String != "default" {
                
                let userPhoto = URL(string: user["thumb_photo"] as! String)
                cell.photoUser.kf.setImage(with: userPhoto)
                
            }else{
                
                let urlPhoto = URL(string: "https://firebasestorage.googleapis.com/v0/b/ecomentes-1f3d7.appspot.com/o/default-user.png?alt=media&token=0ff53569-3354-466f-a5b8-3df07a56053f")
                
                
                cell.photoUser.kf.setImage(with: urlPhoto)
            }
            
            
        })
        
        
        // let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        //cell.photoUser.isUserInteractionEnabled = true
        //
        
        //cell.photoUser.addGestureRecognizer(TapGestureFeed)
        
        
        if(feedsRever[indexPath.row].type == "image"){
            var mDatabaseImage: DatabaseReference!
            
        mDatabaseImage = Database.database().reference().child("Photos").child(feedsRever[indexPath.row].id_post)
            
            
            mDatabaseImage.observe(DataEventType.value, with: { (snapshot) in
                let photo = snapshot.value as? [String : AnyObject] ?? [:]
                
                let imagen1 =  URL(string: photo["thumb_image"] as! String)
                cell.imagen.kf.setImage(with: imagen1)
                
            })
            
            
           
        }else{
            cell.imagen.isHidden = true
        }
        
       
        
        //convert timestamp to date
        
        let timestamp = feedsRever[indexPath.row].time
        
    
        
        let tiempo = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        
        cell.time.text = tiempo.getElapsedInterval()
        let mCommentsDatabase: DatabaseReference!
        let commentsQuery: DatabaseQuery!
        
        mCommentsDatabase = Database.database().reference().child("Comentarios");
        
        commentsQuery = mCommentsDatabase.queryOrdered(byChild: "id_comment").queryEqual(toValue: post_key)
        
        commentsQuery.observe(DataEventType.value, with: { (snapshot) in
            let comentCount: UInt!
            comentCount = snapshot.childrenCount
            
            if (comentCount  != 0){
                let doo = String(comentCount)
                cell.countComentarios.text = doo+" comentarios"
            }else{
                cell.countComentarios.text = "0 Comentarios"
            }
            
            
        })
        let mDatabaseLike: DatabaseReference!
        mDatabaseLike = Database.database().reference().child("Likes")
        
        mDatabaseLike.child(post_key).observe(DataEventType.value, with: { (snapshot) in
            let Count: UInt!
            Count = snapshot.childrenCount
            
            if(Count != 0){
                let dooo = String(Count)
                cell.countLikes.text = dooo+" likes"
            }else{
                cell.countLikes.text = "0 likes"
            }
        })
        var param2 = WCLShineParams()
        param2.bigShineColor = UIColor(rgb: (255,95,89))
        param2.smallShineColor = UIColor(rgb: (216,152,148))
        param2.shineCount = 15
        param2.animDuration = 2
        param2.smallShineOffsetAngle = -5
        cell.btn.params = param2
        cell.btn.image = .heart
        
        
        
        //cell.btn.addTarget(self, action: #selector(TapButtonFeed), for: .touchUpInside)
        //cell.btn.addTarget(self, action: #selector(TapButtonFeed), for: .touchUpInside)
        //myButton.addTarget(self.webView, action: #selector(UIWebView.goBack), for: .touchUpInside)
        var _: Auth!
        
        let userID = Auth.auth().currentUser?.uid
        print(userID!)
        
        mDatabaseLike.observe(DataEventType.value, with: { (snapshot) in
            //let like = snapshot.value as? [String : AnyObject] ?? [:]
            //snapshot.childSnapshot(forPath: post_key).hasChild(userID!)
            if (snapshot.childSnapshot(forPath: post_key).hasChild(userID!)){
                
                cell.btn.setClicked(true)
            }else{
                cell.btn.setClicked(false)
            }
            
            
        })
        //print("Click cell  \(cell.btn.isSelected)")
        
        cell.delegate = self
        
        
        return cell
    }
    
    
    
   
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if feedsRever[indexPath.row].uid == Auth.auth().currentUser?.uid {
            
            let alert = UIAlertController(title: "Publicación", message: "Selecciona una acción: ", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ver", style: .default, handler: { action in
                print("Ver")
                self.performSegue(withIdentifier: "senderFeedSegue", sender: self)
            }))
            
            /*
             alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: { action in
             print("Editar")
             }))
             */
            
            alert.addAction(UIAlertAction(title: "Eliminar", style: .default, handler: {
                
                action in
                print("Eliminar")
                let alertDelete = UIAlertController(title: "Eliminar", message: "¿Realmente desea eliminar está publicación?", preferredStyle: .alert)
                
                
                alertDelete.addAction(UIAlertAction(title:"Si", style: .default, handler: { action in
                    
                    
                    
                    
                    let idPost = self.feedsRever[indexPath.row].id_post
                    print(self.feedsRever[indexPath.row].content)
                    
                    
                    
                    var mDatabase: DatabaseReference!
                    
                    mDatabase = Database.database().reference().child("Blog").child(idPost)
                    mDatabase.removeValue()
                    
                    //self.feeds.removeAll()
                    //self.feedsRever.removeAll()
                    self.feedsRever.remove(at: indexPath.row)
                    
                    self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    self.loadPosts()
                    //tableView.reloadData()
                    
                    
                    print("Eliminado")
                    
                    
                } ))
                
                alertDelete.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(alertDelete, animated: true)
                
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cacelar", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            
            //self.performSegue(withIdentifier: "senderFeedSegue", sender: self)
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "senderFeedSegue") {
           /*
             if let destination =  segue.destination as? ShowPostViewController {
             destination.imageViewGlobal2 = feeds.reversed()[(tableView.indexPathForSelectedRow?.row)!].id_post
             }
            */
        }
        if (segue.identifier == "senderUserProfileFeedSegue") {
            /*
             if let destination2 = segue.destination as? UserProfileViewController {
             
             destination2.userIDProfileUser = userIDProfileFeed
             }
             */
        }
        
    }
    
    @objc func Doo(_ sender: WCLShineButton){
        print("Hola \(sender.isSelected)")
        
        
    }
    
    @objc  func TapGestureFeed(_ sender: CustomCellFeed) {
        
        guard let tappedIndexPath = tableview.indexPath(for: sender) else { return }
        
        userIDProfileFeed = feeds.reversed()[tappedIndexPath.row].uid
        //self.performSegue(withIdentifier: "senderUserProfileFeedSegue", sender: self)
    }
    
    
    
    @objc func TapButtonFeed(_ sender: CustomCellFeed) {
        guard let tappedIndexPath = tableview.indexPath(for: sender) else { return }
        
        var mProcessLike = true
        let post_key = feeds.reversed()[tappedIndexPath.row].id_post
        
        DatabaseLikePush = Database.database().reference().child("Likes")
        let uidUser = Auth.auth().currentUser?.uid
        
        
        //print("uidUser: \(uidUser)")
        //sender.likeButtonChange(sender.btn)
        DatabaseLikePush.observe(DataEventType.value, with: { (snapshot) in
            
            if mProcessLike  {
                print("true")
                
                
                if snapshot.childSnapshot(forPath: post_key).hasChild(uidUser!) {
                    
                    DatabaseLikePush.child(post_key).child(uidUser!).removeValue()
                    
                    sender.btn.setClicked(false)
                    
                }else{
                    DatabaseLikePush.child(post_key).child(uidUser!).setValue(uidUser!)
                    sender.btn.setClicked(true)
                }
                mProcessLike = false
            }
            
        })
        
        
    
        
    }
    
    
    
    
    
    
}
