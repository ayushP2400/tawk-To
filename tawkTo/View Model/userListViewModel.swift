//
//  userListViewModel.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import Foundation

struct userListViewModel {
    
    // MARK:- variables
    
    var userListResult: DataBinder<[UserListModelElement]?> = DataBinder(nil)
    var fetchedUserList: DataBinder<[CustomElementModel]?> = DataBinder(nil)
    
    var userListStatus: DataBinder<Bool?> = DataBinder(nil)
    var userListError: DataBinder<String?> = DataBinder(nil)
    
    var offset: DataBinder<Int?> = DataBinder(nil)
    var apiLastUserIDParam: DataBinder<String?> = DataBinder(nil)
    var fetchFromDB: DataBinder<Bool?> = DataBinder(nil)
    
    var internetAvailability: DataBinder<Bool> = DataBinder(isInternetConnectionAvailable())
    
    
    // MARK:- initializer
    init() {
        self.getUsers()
    }
    
    // MARK:- functions
    func getUsers() {
        self.fetchFromDB.bind { (val) in
            if val != nil{
                if fetchFromDB.value!{
                    if let fetchLimit = UserDefaults.standard.object(forKey: "pageSize") as? Int{
                        fetchUserListFromDB(fetchLimit: fetchLimit)
                    }else{
                        self.fetchedUserList.value = nil
                        self.userListStatus.value = false
                        self.userListError.value = "No Data Available"
                    }
                }else{
                    self.fetchUserList()
                }
            }
        }
    }
    
    func fetchUserList(){
        getUserList { (userData, error) in
            if let users = userData{
                DBHelper.sharedInstance.addBatchUsers(users) { (resp, errorMessage) in
                    if resp{
                        UserDefaults.standard.setValue(users.count, forKey: "pageSize")
                        fetchUserListFromDB(fetchLimit: users.count)
                    }else{
                        self.userListStatus.value = false
                        self.userListError.value = "Error saving in db"
                    }
                }
            }else{
                self.userListStatus.value = false
                self.userListError.value = error
            }
        }
    }
    
    func fetchUserListFromDB(fetchLimit: Int){
        DBHelper.sharedInstance.fetchUsersFromDB(with: fetchLimit, offset: self.offset.value ?? 0) { (fetchStatus, fetchResult, fetchError) in
            if fetchStatus{
                guard let result = fetchResult else {
                    return
                }
                if result.count > 0{
                    
                    self.fetchedUserList.value = processFetchResult(with: result)
                    self.userListStatus.value = true
                    self.userListError.value = "users recived sucessfully "
                    
                }else{
                    
                    self.fetchedUserList.value = nil
                    self.userListStatus.value = false
                    self.userListError.value = "no more data found"
                    
                }
                
            }else{
                self.fetchedUserList.value = nil
                self.userListStatus.value = false
                self.userListError.value = fetchError
            }
        }
    }
    
    func processFetchResult(with result: [Users]) -> [CustomElementModel]{
        var elementTypeArr: [CustomElementModel] = []
        for i in 0..<result.count{
            let user = result[i]
            guard let notes = user.notes else { return []}
            if notes != ""{
                elementTypeArr.append(notesElement.init(userDetails: user))
            }else{
                if (((i+1) % 4) == 0){
                    elementTypeArr.append(invertedElement.init(userDetails: user))
                }else{
                    elementTypeArr.append(regularElement.init(userDetails: user))
                }
            }
        }
        return elementTypeArr
    }
    
    func getUserList(onCompletion:@escaping(UserListModel?,String?)->()){
        
        let params = [
            "since": self.apiLastUserIDParam.value ?? "0"
        ]
        let provider = ServiceProvider<UserEndPoints>()
        
        provider.load(service: .getUserList(parameters: params), decodeType: UserListModel.self) { (result) in
            switch result{
            case .success(let resp):
                onCompletion(resp,nil)
            case .failure(let error):
                onCompletion(nil,error.localizedDescription)
                print(error.localizedDescription)
            case .empty:
                print("No data")
                onCompletion(nil,"No response from server")
            }
        }
    }
    func resetVariables() {
        self.userListResult.value = nil
        self.fetchedUserList.value = nil
        self.userListStatus.value = nil
        self.userListError.value = nil
        self.offset.value = nil
        self.apiLastUserIDParam.value = nil
    }
}

//MARK:- tableview protocol implementation

enum userElementType {
    case inverted
    case notes
    case regular
}

protocol CustomElementModel: class {
    var type: userElementType { get }
}

protocol CustomElementCell: class {
    func configure(withModel: CustomElementModel,indexPath:IndexPath)
}

class invertedElement: CustomElementModel {
    var userDetails: Users
    
    var type: userElementType { return .inverted }
    
    init(userDetails: Users) {
        self.userDetails = userDetails
    }
}
class notesElement: CustomElementModel {
    var userDetails: Users
    
    var type: userElementType { return .notes }
    
    init(userDetails: Users) {
        self.userDetails = userDetails
    }
}
class regularElement: CustomElementModel {
    var userDetails: Users
    
    var type: userElementType { return .regular }
    
    init(userDetails: Users) {
        self.userDetails = userDetails
    }
}
