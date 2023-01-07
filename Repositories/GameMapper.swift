//
//  CategoryMapper.swift
//  plus_ultra
//
//  Created by OS Live Server on 13/11/22.
//


import DataSource
import DomainsData

final class GameMapper {
    static func mapGameResponseToEntities(input gameResponse: [GameResponse]) -> [GameEntity]{
        return gameResponse.map { response in
            let gameEntity = GameEntity()
            gameEntity.id = response.id
            gameEntity.name = response.name ?? "Unknown"
            gameEntity.descriptionText = response.description ?? "Unknown"
            gameEntity.slug = response.slug  ?? "Unknown"
            gameEntity.released = response.released ?? "Unknown"
            if(gameEntity.screenShoots.isEmpty){
                response.screenShoot?.forEach({ shortScreenshoot in
                    gameEntity.screenShoots.append(shortScreenshoot.image)
                })
            }
            gameEntity.rating = response.rating ?? 0
            gameEntity.backgroundImage = response.backgroundImage ?? "Unknown"
            
            if let video = response.videoTriler?.video {
                if let videoMax = video.max {
                    gameEntity.videoUrl = videoMax
                }
                
                if let video480 = video.video480 {
                    gameEntity.videoUrl = video480
                }

            }
            
            var genreName: String? = ""
            if let genres = response.genres  {
                for n in 0..<genres.count{
                    
                    if(n == genres.count - 1 || genres.count == 1){
                        genreName! +=  "\(genres[n].name)"
                    }else{
                        genreName! += "\(genres[n].name), "
                    }
                    
                }
            }
            
            var platforms: String? = ""
            if let platformsList = response.platforms {
                for n in 0..<platformsList.count{
                
                    if(n == platformsList.count - 1 || platformsList.count == 1){
                        platforms! +=  "\(platformsList[n].platform.name)"
                    }else{
                        platforms! += "\(platformsList[n].platform.name), "
                    }
                    
                }
            }
            
            var tags: String? = ""
            if let tagList = response.tags {
                for n in 0..<tagList.count{
                
                    if(n == tagList.count - 1 || tagList.count == 1){
                        tags! +=  "\(tagList[n].name)"
                    }else{
                        tags! += "\(tagList[n].name), "
                    }
                    
                }
            }
            
            gameEntity.genre = genreName  ?? "No Genres"
            gameEntity.tags = tags ?? "Unknown"
            gameEntity.platforms = platforms ?? "No Platform"
            gameEntity.playTime = response.playtime ?? 0
         return gameEntity
        }
    }
    
    static func mapGameEntitiesToDomains(input gameEntities: [GameEntity]) -> [GameModel]{
        print(gameEntities)
        return gameEntities.map { entity in
            var urls = [String]()
            entity.screenShoots.forEach { url in
                urls.append(url)
            }
            return GameModel(
                id: entity.id,
                gameCreateTime: entity.gameCreateTime,
                name: entity.name,
                description: entity.descriptionText,
                slug: entity.slug,
                released: entity.released,
                rating: entity.rating,
                ratingTop: entity.ratingTop,
                ratingsCount: entity.ratingsCount,
                genre: entity.genre,
                videoUrl: entity.videoUrl,
                backgroundImage: entity.backgroundImage,
                screenShoot: urls,
                platform: entity.platforms,
                tags: entity.tags,
                playTime: entity.playTime
                
            )
        }
    }
    
    static func mapGameResponseToDomains(input categoryResponse: [GameResponse]) -> [GameModel]{
        
        return categoryResponse.map { response in
            var videoUrl: String? = nil
            
            if let video = response.videoTriler?.video {
                if let videoMax = video.max {
                    videoUrl = videoMax
                }
                
                if let video480 = video.video480 {
                    videoUrl = video480
                }

            }
            var urls = [String]()
            response.screenShoot?.forEach({ url in
                urls.append(url.image)
            })
            
            var genreName: String? = ""
            if let genres = response.genres  {
                for n in 0..<genres.count{
                    
                    if(n == genres.count - 1 || genres.count == 1){
                        genreName! +=  "\(genres[n].name)"
                    }else{
                        genreName! += "\(genres[n].name), "
                    }
                    
                }
            }
            
            var platforms: String? = ""
            if let platformsList = response.platforms {
                for n in 0..<platformsList.count{
                
                    if(n == platformsList.count - 1 || platformsList.count == 1){
                        platforms! +=  "\(platformsList[n].platform.name)"
                    }else{
                        platforms! += "\(platformsList[n].platform.name), "
                    }
                    
                }
            }
            
            var tags: String? = ""
            if let tagList = response.tags {
                for n in 0..<tagList.count{
                
                    if(n == tagList.count - 1 || tagList.count == 1){
                        tags! +=  "\(tagList[n].name)"
                    }else{
                        tags! += "\(tagList[n].name), "
                    }
                    
                }
            }
            
            return GameModel(
                id: response.id,
                gameCreateTime: 0.0,
                name: response.name,
                description: response.description,
                slug: response.slug,
                released: response.released,
                rating: response.rating,
                ratingTop: response.ratingTop,
                ratingsCount: response.ratingsCount,
                genre: genreName,
                videoUrl: videoUrl,
                backgroundImage: response.backgroundImage,
                screenShoot: urls,
                platform: platforms,
                tags: tags,
                playTime: response.playtime
            )
        }
    }
}
