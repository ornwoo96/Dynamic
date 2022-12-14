//
//  RegisterKeys.swift
//  Core
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

public enum VMKeys: String {
    case MainVM = "MainViewModel"
    case CompoVM = "CompositionalViewModel"
    case CustomVM = "CustomViewModel"
    case SwiftUIVM = "SwiftUIViewModel"
}

public enum VCKeys: String {
    case MainVC = "MainViewController"
    case CompoVC = "CompositionalViewController"
    case CustomVC = "CustomViewController"
    case SwiftUI = "SwiftUIViewController"
    case TabBar = "TabBarController"
}

public enum UCKeys: String {
    case DynamicUC = "DynamicUseCase"
}

public enum RepoKeys: String {
    case DynamicRepo = "DynamicRepository"
    case fetchService = "FetchDataService"
}

public enum CodiKeys: String {
    case tabBar = "TabBarCoordinator"
    case custom = "CustomCoordinator"
    case swift = "SwiftUICoordinator"
    case compo = "CompositionalCoordinator"
    case MainCodi = "MainCoordinator"
}
