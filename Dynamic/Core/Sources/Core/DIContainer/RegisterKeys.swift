//
//  RegisterKeys.swift
//  Core
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
}

public enum VCKeys: String {
    case mainVC = "MainViewController"
    case compoVC = "CompositionalViewController"
    case customVC = "CustomViewController"
    case swiftUI = "SwiftUIViewController"
    case tabBar = "TabBarController"
    case detail = "DetailViewController"
    case pickList = "PickListViewController"
}

public enum UCKeys: String {
    case dynamicUC = "DynamicUseCase"
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
    case mainCodi = "MainCoordinator"
    case detail = "DetailCoordinator"
    case pickList = "PickListCoordinator"
}
