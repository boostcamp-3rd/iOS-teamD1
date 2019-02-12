//
//  ImageLoaderProtocol.swift
//  BeBrav
//
//  Created by Seonghun Kim on 12/02/2019.
//  Copyright © 2019 bumslap. All rights reserved.
//

import UIKit

protocol ImageLoaderProtocol {
    var session: URLSessionProtocol { get }
    var diskCache: DiskCacheProtocol { get }
    var memoryCache: MemoryCacheProtocol { get }
    
    func getImageWithCaching(url: URL,
                             size: ImageSize,
                             completion: @escaping (UIImage?, Error?) -> Void)
    
    init(session: URLSessionProtocol,
         diskCache: DiskCacheProtocol,
         memoryCache: MemoryCacheProtocol)
}
