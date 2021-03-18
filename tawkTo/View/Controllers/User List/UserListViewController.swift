//
//  UserListViewController.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import UIKit

class UserListViewController: UIViewController {
    
    //MARK:- UI Views Variables
    var searchView = SearchBarView()
    var userListTableView = UITableView()
    
    var userList: [CustomElementModel] = []
    var offset = 0
    var usersViewModel = userListViewModel()
    var loadingMoreData = false
    var isSearchingData = false
    var searchResultArr: [CustomElementModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        registerTableViewCell()
        fetchUserList()
        listenToDataChanges()
        
    }
    
    func initViews(){
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.searchBarTextField.returnKeyType = .done
        searchView.searchBarTextField.delegate = self
        searchView.cancelSearchBtn.addTarget(self, action: #selector(self.cancelSearch(_:)), for: .touchUpInside)
        
        self.view.addSubview(searchView)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
            searchView.heightAnchor.constraint(equalToConstant: 61.0)
        ])
        
        userListTableView.separatorStyle = .none
        userListTableView.translatesAutoresizingMaskIntoConstraints = false
        userListTableView.showsVerticalScrollIndicator = false
        userListTableView.showsHorizontalScrollIndicator =  false
        
        self.view.addSubview(userListTableView)
        
        NSLayoutConstraint.activate([
            userListTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 8),
            userListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
    }
    
    func registerTableViewCell(){
        userListTableView.register(userListTableViewCell.self, forCellReuseIdentifier: "userListTableViewCell")
        userListTableView.register(noteUserListTableViewCell.self, forCellReuseIdentifier: "noteUserListTableViewCell")
        userListTableView.register(invertedUserListTableViewCell.self, forCellReuseIdentifier: "invertedUserListTableViewCell")
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
    }
    
   
    
}
extension UserListViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingData ? searchResultArr.count : userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = isSearchingData ? searchResultArr[indexPath.row] : userList[indexPath.row]
        switch cellModel.type {
        case .inverted:
            let cell = tableView.dequeueReusableCell(withIdentifier: "invertedUserListTableViewCell") as! invertedUserListTableViewCell
            cell.selectionStyle = .none
            cell.initViews()
            cell.configure(withModel: cellModel, indexPath: indexPath)
            return cell
        case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteUserListTableViewCell") as! noteUserListTableViewCell
            cell.selectionStyle = .none
            cell.initViews()
            cell.configure(withModel: cellModel, indexPath: indexPath)
            return cell
        case .regular:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userListTableViewCell") as! userListTableViewCell
            cell.selectionStyle = .none
            cell.initViews()
            cell.configure(withModel: cellModel, indexPath: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userDetailsViewController") as! userDetailsViewController
        if isSearchingData{
            if let userModelType = searchResultArr[indexPath.row] as? regularElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }else if let userModelType = searchResultArr[indexPath.row] as? notesElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }else if let userModelType = searchResultArr[indexPath.row] as? invertedElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }
        }else{
            if let userModelType = userList[indexPath.row] as? regularElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }else if let userModelType = userList[indexPath.row] as? notesElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }else if let userModelType = userList[indexPath.row] as? invertedElement{
                vc.userName = userModelType.userDetails.login ?? ""
            }
        }
        
        vc.indexLastData = indexPath.row
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row+1 == userList.count {
            if !isSearchingData{
                if !loadingMoreData{
                    tableView.addLoading(indexPath) {
                        // add your code here
                        // append Your array and reload your tableview
                        // stop your indicator
                        
                        self.loadingMoreData = true
                        self.fetchUserList()
                    }
                }
            }
            
            
        }
    }
    
}

extension UserListViewController:notesUpdateDelegate{
    func didUpdateSeenStatus(with newData: CustomElementModel, at index: Int) {
        self.userList[index] = newData
        self.userListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func didUpdateNotes(with newData: CustomElementModel, at index: Int) {
        self.userList[index] = newData
        self.userListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
}
extension UserListViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearchingData = true
        searchView.cancelSearchBtn.alpha = 1.0
        searchView.cancelSearchBtn.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) > 0{
            searchView.cancelSearchBtn.alpha = 1.0
            searchView.cancelSearchBtn.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        }else{
            isSearchingData = false
            textField.text = ""
            searchView.cancelSearchBtn.alpha = 0.0
            searchView.cancelSearchBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 0.0).isActive = true
            self.userListTableView.reloadData()
        }
    }
    @objc func didTypeInSearchTF(_ textField: UITextField){
        isSearchingData = true
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.getHintsFromTextField),
            object: textField)
        self.perform(
            #selector(self.getHintsFromTextField),
            with: textField,
            afterDelay: 0.5)
        return true
    }

    @objc func getHintsFromTextField(textField: UITextField) {
        isSearchingData = true
        print("Hints for textField: \(String(describing: textField.text))")
        customLoader.shared.showActivityIndicator()
        DBHelper.sharedInstance.searchUserList(with: textField.text ?? "") { (resp, message, users) in
            customLoader.shared.hideActivityIndicator()
            if resp{
                searchResultArr = usersViewModel.processFetchResult(with: users)
                self.userListTableView.reloadData()
            }else{
                searchResultArr = []
                self.userListTableView.reloadData()
                self.view.endEditing(true)
                self.showToast(message: message)
            }
        }
    }
    
    @objc func cancelSearch(_ sender:UIButton){
        isSearchingData = false
        searchView.searchBarTextField.text = ""
        searchView.cancelSearchBtn.alpha = 0.0
        searchView.cancelSearchBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 0.0).isActive = true
        self.userListTableView.reloadData()
    }
    
}
//MARK:- requests for search result list

extension UserListViewController{
    
}

//MARK:- requests for fetching user list
extension UserListViewController{
    
    func fetchUserList(){
        
        if isInternetConnectionAvailable(){
            if DBHelper.sharedInstance.isDataExistingInUsers(){
                if let lastItemInDB = DBHelper.sharedInstance.existingUsersInDBLastItem(){
                    var lastUserID = 0
                    if let user = self.userList.last{
                        switch user.type{
                        case .inverted:
                            if let userVal = user as? invertedElement{
                                lastUserID = Int(userVal.userDetails.id)
                            }
                        case .notes:
                            if let userVal = user as? notesElement{
                                lastUserID = Int(userVal.userDetails.id)
                            }
                        case .regular:
                            if let userVal = user as? regularElement{
                                lastUserID = Int(userVal.userDetails.id)
                            }
                        }
                    }
                    
                    if lastItemInDB.id == lastUserID{
                        self.offset = self.userList.count
                        usersViewModel.apiLastUserIDParam.value = "\(lastUserID)"
                        usersViewModel.offset.value = self.offset
                        usersViewModel.fetchFromDB.value = false
                    }else{
                        self.offset = self.userList.count
                        usersViewModel.offset.value = self.offset
                        usersViewModel.fetchFromDB.value = true
                    }
                }else{
                    self.offset = self.userList.count
                    usersViewModel.offset.value = self.offset
                    usersViewModel.fetchFromDB.value = true
                }
            }else{
                usersViewModel.apiLastUserIDParam.value = "0"
                usersViewModel.offset.value = self.offset
                usersViewModel.fetchFromDB.value = false
            }
        }else{
            fetchWhenInternetNotAvailable()
        }
        
    }
    
    func fetchWhenInternetNotAvailable(){
        self.offset = self.userList.count
        usersViewModel.offset.value = self.offset
        usersViewModel.fetchFromDB.value = true
    }
    
    func listenToDataChanges(){
        usersViewModel.userListStatus.bind { (val) in
            if val != nil{
                if val!{
                    self.userListTableView.beginUpdates()
                    let newIndexArr = self.indexPathsNewInserted(with: self.usersViewModel.fetchedUserList.value!, lastIndex: self.userList.count)
                    self.userList.append(contentsOf: self.usersViewModel.fetchedUserList.value!)
                    self.userListTableView.insertRows(at: newIndexArr, with: .automatic)
                    self.userListTableView.endUpdates()
                    self.usersViewModel.resetVariables()
                    self.userListTableView.stopLoading()
                    self.loadingMoreData = false
                }else{
                    self.showToast(message: self.usersViewModel.userListError.value ?? "")
                    self.usersViewModel.resetVariables()
                    self.userListTableView.stopLoading()
                    self.loadingMoreData = false
                }
            }
        }
    }
    
    func indexPathsNewInserted(with userListData: [CustomElementModel], lastIndex: Int) -> [IndexPath]{
        var arrInndex: [IndexPath] = []
        for i in 0..<userListData.count{
            let index = IndexPath.init(row: (lastIndex)+i, section: 0)
            arrInndex.append(index)
        }
        return arrInndex
    }
    
}
