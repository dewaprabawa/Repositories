//
//  FavRepository.swift
//  plus_ultra
//
//  Created by OS Live Server on 21/11/22.
//

import Foundation
import UIKit
import RxSwift
import Reachability
import DataSource
import DomainsData

final public class GameFavRepository {
   public typealias FavGameInstance = (LocalGameDataSourceProtocol, RemoteDataSourceProtocol, Reachability) -> GameFavUseCaseProtocol
    
    private let reachability: Reachability
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localeDataSource: LocalGameDataSourceProtocol
    
    init(localeFavDataSource: LocalGameDataSourceProtocol, remoteDataSource: RemoteDataSourceProtocol,
         reachability: Reachability){
        self.localeDataSource = localeFavDataSource
        self.remoteDataSource = remoteDataSource
        self.reachability = reachability
    }
    
    static public let sharedInstance: FavGameInstance = { local, remote, reachability in
        return GameFavRepository(localeFavDataSource: local, remoteDataSource: remote, reachability: reachability)
    }
}


extension GameFavRepository: GameFavUseCaseProtocol {
  
    
    public func getFavGameList() -> Observable<[GameModel]> {
        return self.localeDataSource.getFavGameList().map {
            FavMapper.mapFavEntitiesToDomains(input: $0)
        }
    }
    
    public func saveOneGame(from savedOne: GameModel, completion: @escaping (Bool) -> Void) {
        return self.localeDataSource.saveOneGame(from: FavMapper.mapFavDomainToEntity(input: savedOne), completion: completion)
    }
    
    public func deleteOneGame(with id: Int, completion: @escaping (Bool) -> Void) {
        self.localeDataSource.deleteOneGame(with: id, completion: completion)
    
    }
    
}
