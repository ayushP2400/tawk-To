//
//  DB Helper.swift
//  tawkTo
//
//  Created by love on 16/03/21.
//

import Foundation
import CoreData
import UIKit

class DBHelper {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let usersEntity = NSEntityDescription.entity(forEntityName: "Users", in: DBHelper.context)
    static let sharedInstance = DBHelper()
    
    func addBatchUsers(_ items: UserListModel,completion:(Bool,String)->()){
        
        for user in items{
            insertNewUserDataModel(from: user)
        }
        
        do {
            try DBHelper.context.save()
            completion(true,"data added sucessfully!")
        } catch {
            print(error.localizedDescription)
            completion(false,error.localizedDescription)
        }
        
    }
    
    func insertNewUserDataModel(from apiData: UserListModelElement){
        guard let userEntity = usersEntity else {
            return
        }
        let userData = Users.init(entity: userEntity, insertInto: DBHelper.context)
        userData.avatar_url = apiData.avatarURL ?? ""
        userData.bio = ""
        userData.blog = ""
        userData.company = ""
        userData.created_at = ""
        userData.email = ""
        userData.events_url = apiData.eventsURL ?? ""
        userData.followers = Int64(0)
        userData.followers_url = apiData.followersURL ?? ""
        userData.following = Int64(0)
        userData.following_url = apiData.followersURL ?? ""
        userData.gists_url = apiData.gistsURL ?? ""
        userData.gravatar_id = apiData.gravatarID ?? ""
        userData.hireable = ""
        userData.html_url = apiData.htmlURL ?? ""
        userData.id = Int64(apiData.id ?? 0)
        userData.isVisited = false
        userData.location = ""
        userData.login = apiData.login
        userData.name = ""
        userData.node_id = apiData.nodeID ?? ""
        userData.notes = ""
        userData.organizations_url = apiData.organizationsURL ?? ""
        userData.public_gists = Int64(0)
        userData.public_repos = Int64(0)
        userData.received_events_url = apiData.receivedEventsURL ?? ""
        userData.repos_url = apiData.reposURL ?? ""
        userData.site_admin = apiData.siteAdmin ?? false
        userData.starred_url = apiData.starredURL ?? ""
        userData.subscriptions_url = apiData.subscriptionsURL ?? ""
        userData.twitter_username = ""
        userData.type = apiData.type
        userData.updated_at = ""
        userData.url = apiData.url
    }
    
    func fetchUsersFromDB(with pageSize: Int,offset: Int,completion:(Bool,[Users]?,String)->()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = offset
        
        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let users = results as? [Users]{
                completion(true, users, "records fetch sucessfully")
            }else{
                completion(false, nil, "Could not fetch ")
            }
        } catch let error as NSError {
            completion(false, nil, "Could not fetch \(error)")
        }
    }
    func isDataExistingInUsers()->Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            return results.count > 0
        }catch{
            return false
        }
    }
    func existingUsersInDBLastItem()->Users?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results.last as? Users{
                return resultLastItem
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    func getUserDetails(by Username: String)->Users?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "login = %@", Username)
        fetchRequest.predicate = predicate

        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results.last as? Users{
                return resultLastItem
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    
    func updateUserDetails(_ item: UserProfileDetails,completion:(Bool,String)->()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "login = %@", item.login ?? "")
        fetchRequest.predicate = predicate

        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results.last as? Users{
                
                resultLastItem.avatar_url = item.avatarURL ?? ""
                resultLastItem.bio = item.bio ?? ""
                resultLastItem.blog = item.blog ?? ""
                resultLastItem.company = item.company ?? ""
                resultLastItem.created_at = item.createdAt ?? ""
                resultLastItem.email = item.email ?? ""
                resultLastItem.followers = Int64(item.followers ?? 0)
                resultLastItem.followers_url = item.followersURL ?? ""
                resultLastItem.following = Int64(item.following ?? 0)
                resultLastItem.following_url = item.followingURL ?? ""
                resultLastItem.gists_url = item.gistsURL ?? ""
                resultLastItem.gravatar_id = item.gravatarID ?? ""
                resultLastItem.hireable = item.hireable ?? ""
                resultLastItem.html_url = item.htmlURL ?? ""
                resultLastItem.id = Int64(item.id ?? 0)
                resultLastItem.isVisited = true
                resultLastItem.location = item.location ?? ""
                resultLastItem.login = item.login ?? ""
                resultLastItem.name = item.name ?? ""
                resultLastItem.node_id = item.nodeID ?? ""
                resultLastItem.organizations_url = item.organizationsURL ?? ""
                resultLastItem.public_gists = Int64(item.publicGists ?? 0)
                resultLastItem.public_repos = Int64(item.publicRepos ?? 0)
                resultLastItem.received_events_url = item.receivedEventsURL ?? ""
                resultLastItem.repos_url = item.reposURL ?? ""
                resultLastItem.site_admin = item.siteAdmin ?? false
                resultLastItem.starred_url = item.starredURL ?? ""
                resultLastItem.subscriptions_url = item.subscriptionsURL ?? ""
                resultLastItem.twitter_username = item.twitterUsername ?? ""
                resultLastItem.type = item.type ?? ""
                resultLastItem.updated_at = item.updatedAt ?? ""
                resultLastItem.url = item.url ?? ""
                do {
                    try DBHelper.context.save()
                    completion(true,"data added sucessfully!")
                } catch {
                    print(error.localizedDescription)
                    completion(false,error.localizedDescription)
                }
            }else{
                print("error fetching data")
                completion(false,"error fetching data")
            }
        }catch{
            print(error.localizedDescription)
            completion(false,error.localizedDescription)
        }
        
       
        
    }
    
    
    func updateUserNotes(_ notes: String,userName: String,completion:(Bool,String)->()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "login = %@", userName)
        fetchRequest.predicate = predicate

        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results.last as? Users{
                resultLastItem.isVisited = true
                resultLastItem.notes = notes
                do {
                    try DBHelper.context.save()
                    completion(true,"data added sucessfully!")
                } catch {
                    print(error.localizedDescription)
                    completion(false,error.localizedDescription)
                }
            }else{
                print("error fetching data")
                completion(false,"error fetching data")
            }
        }catch{
            print(error.localizedDescription)
            completion(false,error.localizedDescription)
        }
    }
    func updateUserSeenStatus(userName: String,completion:(Bool,String)->()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "login = %@", userName)
        fetchRequest.predicate = predicate

        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results.last as? Users{
                resultLastItem.isVisited = true
                do {
                    try DBHelper.context.save()
                    completion(true,"data added sucessfully!")
                } catch {
                    print(error.localizedDescription)
                    completion(false,error.localizedDescription)
                }
            }else{
                print("error fetching data")
                completion(false,"error fetching data")
            }
        }catch{
            print(error.localizedDescription)
            completion(false,error.localizedDescription)
        }
    }
    func searchUserList(with val:String,completion:(Bool,String,[Users])->()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        let notesEqualsKeyPredicate = NSPredicate(format: "notes ==[c] %@", val)
        let notesContainsKeyPredicate = NSPredicate(format: "notes CONTAINS[c] %@", val)
        
        let loginEqualsKeyPredicate = NSPredicate(format: "login ==[c] %@", val)
        let loginContainsKeyPredicate = NSPredicate(format: "login CONTAINS[c] %@", val)
        
        let andPredicate =  NSCompoundPredicate.init(orPredicateWithSubpredicates: [notesEqualsKeyPredicate,notesContainsKeyPredicate,loginEqualsKeyPredicate,loginContainsKeyPredicate])
        fetchRequest.predicate = andPredicate
        
        do {
            let results = try DBHelper.context.fetch(fetchRequest)
            if let resultLastItem = results as? [Users]{
                completion(true,"found results",resultLastItem)
            }else{
                print("error fetching data")
                completion(false,"error fetching data",[])
            }
        }catch{
            print(error.localizedDescription)
            completion(false,error.localizedDescription,[])
        }
    }
}
