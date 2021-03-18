//
//  profileDetailsViewModel.swift
//  tawkTo
//
//  Created by love on 17/03/21.
//

import Foundation

struct profileDetailsViewModel {
    
    // MARK:- variables
    
    var profileDetailsResult: DataBinder<[UserListModelElement]?> = DataBinder(nil)
    var profileUserName: DataBinder<String?> = DataBinder(nil)
    var profileDetailsStatus: DataBinder<Bool?> = DataBinder(nil)
    var profileDetailsError: DataBinder<String?> = DataBinder(nil)
    var profileDetailsValue: DataBinder<Users?> = DataBinder(nil)
    
    
    // MARK:- initializer
    init() {
        self.getUserDetails()
    }
    
    // MARK:- functions
    func getUserDetails() {
        self.profileUserName.bind { (val) in
            if val != nil{
                if isInternetConnectionAvailable(){
                    self.fetchUserDetails()
                }else{
                    fetchUserDetailsFromDB(userName: self.profileUserName.value ?? "")
                }
            }
        }
    }
    
    func fetchUserDetails(){
        getUserDetails { (userData, error) in
            if let users = userData{
                DBHelper.sharedInstance.updateUserDetails(users) { (resp, errorMessage) in
                    if resp{
                        fetchUserDetailsFromDB(userName: users.login ?? "")
                    }else{
                        self.profileDetailsStatus.value = false
                        self.profileDetailsError.value = "Error saving in db"
                    }
                }
            }else{
                self.profileDetailsStatus.value = false
                self.profileDetailsError.value = error
            }
        }
    }
    
    func fetchUserDetailsFromDB(userName:String){
        if let details = DBHelper.sharedInstance.getUserDetails(by: userName){
            self.profileDetailsValue.value = details
            self.profileDetailsStatus.value = true
            self.profileDetailsError.value = "fetched profile sucessfully"
        }else{
            self.profileDetailsValue.value = nil
            self.profileDetailsStatus.value = false
            self.profileDetailsError.value = "error fetching profile"
        }
    }
    
    func getUserDetails(onCompletion:@escaping(UserProfileDetails?,String?)->()){
        
        let provider = ServiceProvider<UserEndPoints>()
        
        provider.load(service: .getUserDetails(parameters: self.profileUserName.value ?? ""), decodeType: UserProfileDetails.self) { (result) in
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
        self.profileDetailsResult.value = nil
        self.profileUserName.value = nil
        self.profileDetailsStatus.value = nil
        self.profileDetailsError.value = nil
    }
}

