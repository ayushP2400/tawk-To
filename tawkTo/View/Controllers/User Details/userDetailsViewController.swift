//
//  userDetailsViewController.swift
//  tawkTo
//
//  Created by love on 17/03/21.
//

import UIKit

class userDetailsViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var userDetailsTableView: UITableView!
    @IBOutlet weak var notesDescriptionTextView: UITextView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var userName: String!
    var indexLastData = 0
    var profileDetailsModel = profileDetailsViewModel()
    var userDetailsVal: Users?
    var delegate: notesUpdateDelegate?
    
    var profileOverViewListTitle: [String] = []
    var profileOverViewListValue: [String] = []
    
    var numberOfSections = 0
    var itemsInSection = [0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func initViews(){
        
        self.saveBtn.setCornerRadius(12)
        notesView.alpha = 1.0
        notesDescriptionTextView.setBorder(with: 1.0, color: UIColor.gray)
        notesDescriptionTextView.setCornerRadius(16)
        notesDescriptionTextView.returnKeyType = .done
        notesDescriptionTextView.delegate = self
        notesDescriptionTextView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func configureUI(){
        if let useDetailsValue = userDetailsVal{
            initViews()
            if let notes = useDetailsValue.notes{
                notesDescriptionTextView.text = (notes == "") ? "Write Notes" : notes
                notesDescriptionTextView.textColor = (notes == "") ? UIColor.placeholderText : UIColor.black
            }
            self.navigationBar.topItem?.title = useDetailsValue.name
            initTblViewData()
        }else{
            self.notesView.alpha = 0.0
            self.numberOfSections = 0
            self.itemsInSection = [0,0]
            self.profileOverViewListTitle = []
            self.profileOverViewListValue = []
            self.userDetailsTableView.reloadData()
        }
    }
    
    func initTblViewData(){
        if let useDetailsValue = userDetailsVal{
            
            profileOverViewListTitle = ["bio","blog","company","created_at","email","events_url","followers_url","following_url","gists_url","gravatar_id","hireable","html_url","id","location","login","name","node_id","organizations_url","public_gists","public_repos","received_events_url","repos_url","site_admin","starred_url","subscriptions_url","twitter_username","type","updated_at","url"
            ]
            profileOverViewListValue = [useDetailsValue.bio ?? "",useDetailsValue.blog ?? "",useDetailsValue.company ?? "",useDetailsValue.created_at ?? "",useDetailsValue.email ?? "",useDetailsValue.events_url ?? "",useDetailsValue.followers_url ?? "",useDetailsValue.following_url ?? "",useDetailsValue.gists_url ?? "",useDetailsValue.gravatar_id ?? "",useDetailsValue.hireable ?? "",useDetailsValue.html_url ?? "","\(useDetailsValue.id)",useDetailsValue.location ?? "",useDetailsValue.login ?? "",useDetailsValue.name ?? "",useDetailsValue.node_id ?? "",useDetailsValue.organizations_url ?? "","\(useDetailsValue.public_gists)","\(useDetailsValue.public_repos)",useDetailsValue.received_events_url ?? "",useDetailsValue.repos_url ?? "","\(useDetailsValue.site_admin)",useDetailsValue.starred_url ?? "",useDetailsValue.subscriptions_url ?? "",useDetailsValue.twitter_username ?? "",useDetailsValue.type ?? "",useDetailsValue.updated_at ?? "",useDetailsValue.url ?? ""
            ]
            numberOfSections = 2
            itemsInSection = [1,profileOverViewListTitle.count]
            
            self.userDetailsTableView.reloadData()
            DBHelper.sharedInstance.updateUserSeenStatus(userName: self.userName) { (val, Message) in
                self.userDetailsVal!.isVisited = true
                if self.userDetailsVal!.notes != ""{
                    let model = notesElement.init(userDetails: self.userDetailsVal!)
                    delegate?.didUpdateSeenStatus(with: model, at: self.indexLastData)
                }else if indexLastData+1 % 4 == 0{
                    let model = invertedElement.init(userDetails: self.userDetailsVal!)
                    delegate?.didUpdateSeenStatus(with: model, at: self.indexLastData)
                }else{
                    let model = regularElement.init(userDetails: self.userDetailsVal!)
                    delegate?.didUpdateSeenStatus(with: model, at: self.indexLastData)
                }
            }
        }
    }
    
    func getUserDetails(){
        customLoader.shared.showActivityIndicator()
        self.notesView.alpha = 0.0
        profileDetailsModel.profileUserName.value = self.userName
        profileDetailsModel.profileDetailsStatus.bind { (val) in
            if val != nil{
                if self.profileDetailsModel.profileDetailsStatus.value!{
                    customLoader.shared.hideActivityIndicator()
                    self.userDetailsVal = self.profileDetailsModel.profileDetailsValue.value!
                    self.configureUI()
                    self.profileDetailsModel.resetVariables()
                }else{
                    customLoader.shared.hideActivityIndicator()
                    self.configureUI()
                    self.showToast(message: self.profileDetailsModel.profileDetailsError.value ?? "")
                    self.profileDetailsModel.resetVariables()
                }
            }
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if notesDescriptionTextView.textColor == UIColor.placeholderText{
            DBHelper.sharedInstance.updateUserNotes("", userName: self.userName) { (val, Message) in
                if val{
                    if indexLastData+1 % 4 == 0{
                        self.userDetailsVal!.notes = ""
                        let model = invertedElement.init(userDetails: self.userDetailsVal!)
                        delegate?.didUpdateNotes(with: model, at: self.indexLastData)
                        self.showToast(message: "notes updated")
                    }else{
                        self.userDetailsVal!.notes = ""
                        let model = regularElement.init(userDetails: self.userDetailsVal!)
                        delegate?.didUpdateNotes(with: model, at: self.indexLastData)
                        self.showToast(message: "notes updated")
                    }
                    self.showToast(message: "notes updated")
//                    delegate.
                }else{
                    self.showToast(message: Message)
                }
                
            }
        }else{
            DBHelper.sharedInstance.updateUserNotes(self.notesDescriptionTextView.text, userName: self.userName) { (val, Message) in
                if val{
                    self.userDetailsVal!.notes = self.notesDescriptionTextView.text
                    let model = notesElement.init(userDetails: self.userDetailsVal!)
                    delegate?.didUpdateNotes(with: model, at: self.indexLastData)
                    self.showToast(message: "notes updated")
                }else{
                    self.showToast(message: Message)
                }
            }
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension userDetailsViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Notes"
            textView.textColor = UIColor.placeholderText
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
extension userDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInSection[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userFollowersTableViewCell") as! userFollowersTableViewCell
            if let useDetailsValue = userDetailsVal{
                cell.followersLbl.text = "followers: " + "\(useDetailsValue.followers)"
                cell.followingLbl.text = "following: " + "\(useDetailsValue.following)"
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsFieldsTableViewCell") as! userDetailsFieldsTableViewCell
            cell.fieldTitleLbl.text = profileOverViewListTitle[indexPath.row]
            cell.fieldValueLbl.text = profileOverViewListValue[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsImageHeaderTableViewCell") as! userDetailsImageHeaderTableViewCell
            if let userDetailsItem = userDetailsVal{
                cell.loadImage(with: userDetailsItem.avatar_url ?? "")
            }
            return cell
        }else if section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsHeaderTableViewCell") as! userDetailsHeaderTableViewCell
            cell.headerTitleLbl.text = "Profile Overview"
            return cell
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 250 : 51
    }
    
}
protocol notesUpdateDelegate {
    func didUpdateNotes(with newData: CustomElementModel, at index: Int)
    func didUpdateSeenStatus(with newData: CustomElementModel, at index: Int)
}
