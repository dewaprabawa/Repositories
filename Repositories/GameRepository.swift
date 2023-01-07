//
//  MealRepository.swift
//  plus_ultra
//
//  Created by OS Live Server on 15/11/22.
//

import Foundation
import RxSwift
import UIKit
import DataSource
import DomainsData

final public class GameRepository {
   public typealias GameInstance = (LocalGameDataSourceProtocol, RemoteDataSourceProtocol) -> GameUseCaseProtocol
    
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localGameDataSource: LocalGameDataSourceProtocol
    
    init(localGameDataSource: LocalGameDataSourceProtocol, remoteDataSource: RemoteDataSourceProtocol){
        self.localGameDataSource = localGameDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    static public let sharedInstance: GameInstance = { local, remote in
        return GameRepository(localGameDataSource: local, remoteDataSource: remote)
    }
}


extension GameRepository: GameUseCaseProtocol {
    
    public func getGameList() -> Observable<[GameModel]> {
        return self.localGameDataSource.getGameList().map {
            GameMapper.mapGameEntitiesToDomains(input: $0)
        }.filter {!$0.isEmpty}.ifEmpty(switchTo: self.remoteDataSource.retrieveGameList().map{
            GameMapper.mapGameResponseToEntities(input: $0)
        }.flatMap{ self.localGameDataSource.saveGameList(from:$0)
        }.filter{$0}.flatMap{
            _ in self.localGameDataSource.getGameList()
                             .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
        })
    }
        
}
