//
//  RegisterKeys.swift
//  DynamicCore
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

public enum VMKeys: String {
    case mainVM = "MainViewModel"
    case compoVM = "CompositionalViewModel"
    case customVM = "CustomViewModel"
    case swiftUIVM = "SwiftUIViewModel"
    case detail = "DetailViewModel"
    case pickList = "PickListViewModel"
    case parentCompo = "ParentCompositionalViewModel"
    case parentCustom = "ParentCustomViewModel"
}

public enum VCKeys: String {
    case mainVC = "MainViewController"
    case compoVC = "CompositionalViewController"
    case customVC = "CustomViewController"
    case parentCustom = "ParentCustomViewController"
    case swiftUI = "SwiftUIViewController"
    case tabBar = "TabBarController"
    case detail = "DetailViewController"
    case pickList = "PickListViewController"
    case parentCompo = "ParentCompositionalViewController"
}

public enum UCKeys: String {
    case search = "ImageSearchUseCase"
    case addFavorites = "AddFavoritesUseCase"
    case fetchFavorites = "FetchFavoritesUseCase"
    case removeFavorites = "RemoveFavoritesUseCase"
}

public enum RepoKeys: String {
    case dynamicRepo = "DynamicRepository"
    case network = "NetworkManager"
    case imageCache = "ImageCacheRepository"
    case coreContext = "CoreDataContext"
    case coreManager = "CoreDataManager"
}

public enum CodiKeys: String {
    case tabBar = "TabBarCoordinator"
    case custom = "CustomCoordinator"
    case swift = "SwiftUICoordinator"
    case compo = "CompositionalCoordinator"
    case parentCompo = "ParentCompositionalCoordinator"
    case mainCodi = "MainCoordinator"
    case detail = "DetailCoordinator"
    case pickList = "PickListCoordinator"
    case parentCustom = "ParentCustomCoordinator"
}
