//
//  InAppConfigurationManager.swift
//  Mindbox
//
//  Created by Максим Казаков on 06.09.2022.
//  Copyright © 2022 Mikhail Barilov. All rights reserved.
//

import Foundation
import MindboxLogger

protocol InAppConfigurationDelegate: AnyObject {
    func didPreparedConfiguration()
}

protocol InAppConfigurationManagerProtocol: AnyObject {
    var delegate: InAppConfigurationDelegate? { get set }

    func prepareConfiguration()
    func getInapp() -> InAppFormData?
    func recalculateInapps(with event: ApplicationEvent)
}

/// Prepares in-apps configation (loads from network, stores in cache, cache invalidation).
/// Also builds domain models on the base of configuration: in-app requests, in-app message models.
class InAppConfigurationManager: InAppConfigurationManagerProtocol {
    
    private let jsonDecoder = JSONDecoder()
    private let queue = DispatchQueue(label: "com.Mindbox.configurationManager")
    private var inapp: InAppFormData?
    private var rawConfigurationResponse: InAppConfigResponse!
    private let inAppConfigRepository: InAppConfigurationRepository
    private let inAppConfigurationMapper: InAppConfigutationMapper
    private let inAppConfigAPI: InAppConfigurationAPI
    private let logsManager: SDKLogsManagerProtocol
    private let sessionStorage: SessionTemporaryStorage

    init(
        inAppConfigAPI: InAppConfigurationAPI,
        inAppConfigRepository: InAppConfigurationRepository,
        inAppConfigurationMapper: InAppConfigutationMapper,
        logsManager: SDKLogsManagerProtocol,
        sessionStorage: SessionTemporaryStorage
    ) {
        self.inAppConfigRepository = inAppConfigRepository
        self.inAppConfigurationMapper = inAppConfigurationMapper
        self.inAppConfigAPI = inAppConfigAPI
        self.logsManager = logsManager
        self.sessionStorage = sessionStorage
    }

    weak var delegate: InAppConfigurationDelegate?

    func prepareConfiguration() {
        queue.async {
            self.downloadConfig()
        }
    }

    func getInapp() -> InAppFormData? {
        return queue.sync {
            defer {
                inapp = nil
            }
            
            return inapp
        }
    }
    
    func recalculateInapps(with event: ApplicationEvent) {
        queue.sync {
            guard let rawConfigurationResponse = rawConfigurationResponse else {
                return
            }
            
            setConfigPrepared(rawConfigurationResponse, event: event)
        }
    }

    // MARK: - Private
    private func downloadConfig() {
        inAppConfigAPI.fetchConfig(completionQueue: queue) { result in
            self.completeDownloadTask(result)
        }
    }

    private func completeDownloadTask(_ result: InAppConfigurationAPIResult) {
        switch result {
        case let .data(data):
            do {
                let config = try jsonDecoder.decode(InAppConfigResponse.self, from: data)
                saveConfigToCache(data)
                setConfigPrepared(config)
                setupSettingsFromConfig(config.settings)
                if let monitoring = config.monitoring {
                    logsManager.sendLogs(logs: monitoring.logs)
                }
            } catch {
                applyConfigFromCache()
                Logger.common(message: "Failed to parse downloaded config file. Error: \(error)", level: .error, category: .inAppMessages)
            }

        case .empty:
            let emptyConfig = InAppConfigResponse.init(inapps: [], monitoring: nil, settings: nil)
            inAppConfigRepository.clean()
            setConfigPrepared(emptyConfig)

        case let .error(error):
            applyConfigFromCache()
            Logger.common(message: "Failed to download InApp configuration. Error: \(error.localizedDescription)", level: .error, category: .inAppMessages)
        }
    }

    private func applyConfigFromCache() {
        guard let cachedConfig = self.fetchConfigFromCache() else {
            return
        }
        setConfigPrepared(cachedConfig)
    }

    private func fetchConfigFromCache() -> InAppConfigResponse? {
        guard let data = inAppConfigRepository.fetchConfigFromCache() else {
            Logger.common(message: "Cached Config not exists", level: .debug, category: .inAppMessages)
            return nil
        }
        guard let config = try? jsonDecoder.decode(InAppConfigResponse.self, from: data) else {
            Logger.common(message: "Failed to parse config file from cache", level: .debug, category: .inAppMessages)
            return nil
        }
        Logger.common(message: "Successfuly parsed config file from cache", level: .debug, category: .inAppMessages)
        return config
    }

    private func saveConfigToCache(_ data: Data) {
        inAppConfigRepository.saveConfigToCache(data)
    }
    
    private func setConfigPrepared(_ configResponse: InAppConfigResponse, event: ApplicationEvent? = nil) {
        rawConfigurationResponse = configResponse
        inAppConfigurationMapper.mapConfigResponse(event, configResponse, { inapp in
            self.inapp = inapp
            Logger.common(message: "In-app сonfiguration applied: \n\(String(describing: inapp))", level: .debug, category: .inAppMessages)
            self.delegate?.didPreparedConfiguration()
        })
    }
    
    private func setupSettingsFromConfig(_ settings: InAppConfigResponse.Settings?) {
        guard let settings = settings else {
            return
        }
        
        if let viewCategory = settings.operations?.viewCategory {
            sessionStorage.operationsFromSettings.insert(viewCategory.systemName.lowercased())
        }

        if let viewProduct = settings.operations?.viewProduct {
            sessionStorage.operationsFromSettings.insert(viewProduct.systemName.lowercased())
        }
    }
}
