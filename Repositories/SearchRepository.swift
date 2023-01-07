//
//  SearchRepository.swift
//  plus_ultra
//
//  Created by OS Live Server on 17/12/22.
//

import Foundation
import RxSwift
import UIKit
import DataSource
import DomainsData

final public class SearchRepository {
   public typealias SearchInstance = (RemoteDataSourceProtocol) -> SearchUseCaseProtocol
    
    private let remoteDataSource: RemoteDataSourceProtocol
    
   public init(remoteDataSource: RemoteDataSourceProtocol){
        self.remoteDataSource = remoteDataSource
    }
    
    static public let sharedInstance: SearchInstance = { remote in
        return SearchRepository(remoteDataSource: remote)
    }
}


extension SearchRepository: SearchUseCaseProtocol {
    
    public func searchGame(query: String) -> Observable<[GameModel]> {
        return self.remoteDataSource.searchGameList(query: query).map { GameMapper.mapGameResponseToDomains(input: $0) }
    }
    
}
