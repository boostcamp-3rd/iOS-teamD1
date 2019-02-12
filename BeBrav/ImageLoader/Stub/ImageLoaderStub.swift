//
//  ImageLoaderStub.swift
//  BeBrav
//
//  Created by Seonghun Kim on 12/02/2019.
//  Copyright © 2019 bumslap. All rights reserved.
//

import UIKit

class ImageLoaderStub: ImageLoaderProtocol {
    public let session: URLSessionProtocol
    public let diskCache: DiskCacheProtocol
    public let memoryCache: MemoryCacheProtocol
    
    init(session: URLSessionProtocol,
         diskCache: DiskCacheProtocol,
         memoryCache: MemoryCacheProtocol)
    {
        self.session = session
        self.diskCache = diskCache
        self.memoryCache = memoryCache
    }
    
    func getImageWithCaching(url: URL,
                             size: ImageSize,
                             completion: @escaping (UIImage?, Error?) -> Void)
    {
        return
    }
    
    
}