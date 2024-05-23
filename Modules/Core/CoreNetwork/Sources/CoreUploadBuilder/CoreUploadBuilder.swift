//
//  CoreUploadBuilder.swift
//  CoreNetwork
//
//  Created by Ren Shin on 2023/10/23.
//  Copyright © 2023 Swit. All rights reserved.
//

import Foundation
import Combine
//import CoreFoundationKit
import Alamofire

private enum AssociatedKeys {
    static var uploadRequestWrapperKey: UInt8 = 0
}

public protocol CoreUploadBuilder: NetworkBuilder {
    typealias UploadRequestWrapper = Result<UploadRequest, CommonNetworkError>

    func upload(debug: Bool, progressHandler: ((Double) -> Void)?) -> AnyPublisher<ResponseType, Error>
    func cancel()
}

// MARK: - Variables
extension CoreUploadBuilder {
    private var uploadRequestWrapper: UploadRequestWrapper {
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.uploadRequestWrapperKey) as? UploadRequestWrapper {
            return wrapper
        }
        let wrapper = createUploadRequestWrapper()
        objc_setAssociatedObject(self, &AssociatedKeys.uploadRequestWrapperKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return wrapper
    }
}

// MARK: - upload
extension CoreUploadBuilder {
    public func cancel() {
        guard case .success(let uploadRequest) = uploadRequestWrapper else { return }
        uploadRequest.cancel()
    }

    public func upload(debug: Bool = false, progressHandler: ((Double) -> Void)? = nil) -> AnyPublisher<ResponseType, Error> {
        defaultUpload(debug: debug, progressHandler: progressHandler)
    }

    public func defaultUpload(debug: Bool, progressHandler: ((Double) -> Void)?) -> AnyPublisher<ResponseType, Error> {
        Future<ResponseType, Error> { promise in
            if case .failure(let error) = self.uploadRequestWrapper {
                promise(.failure(error))
            }

            guard case .success(let uploadRequest) = self.uploadRequestWrapper else {
                return promise(.failure(CommonNetworkError.unknown))
            }

            if debug {
//                Log.debug("Network -> URL(\(self.method.rawValue)) : \(String(describing: uploadRequest.convertible.urlRequest?.url))")
//                Log.debug("Network -> request header : \(String(describing: self.createDefaultHeader()))")
//                Log.debug("Network -> parameters : \(String(describing: self.parameters))")
            }

            let request = uploadRequest
                .uploadProgress { handler in
                    progressHandler?(handler.fractionCompleted)
                }

            request.responseData { dataResponse in
                if uploadRequest.isCancelled {
                    return promise(.failure(CommonNetworkError.cancelled))
                }

                if let error = dataResponse.error {
                    return promise(.failure(error))
                }

                guard let response = dataResponse.response, let data = dataResponse.data else {
                    return promise(.failure(CommonNetworkError.invalidResponse))
                }

                do {
                    let response = try self.defaultResponse(debug: debug, response: response, data: data)
                    promise(.success(response))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Private Method
extension CoreUploadBuilder {
    private func createUploadRequestWrapper() -> UploadRequestWrapper {
        guard let convertedURL = createURL() else {
            return .failure(CommonNetworkError.invalidURL)
        }
        let upload = networkSession().upload(
            multipartFormData: { [weak self] formData in
                guard let self else { return }

                if let fileData = self.parameters?["file"] as? Data,
                   let filename = self.parameters?["filename"] as? String {
                    var mimeType = (self.parameters?["minetype"] ?? self.parameters?["mimetype"]) as? String
//                    if mimeType == nil || mimeType.orEmpty.isEmpty {
//                        mimeType = "image/png"
//                    }
                    formData.append(fileData, withName: "file", fileName: filename, mimeType: mimeType)
                }

                self.parameters?.forEach { key, value in
                    guard !["file", "minetype", "mimetype", "cuurl"].contains(key) else { return }

                    if let value = value as? String, let data = value.data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                    if let value = value as? Int, let data = String(value).data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }
            },
            to: convertedURL,
            usingThreshold: UInt64(),
            method: method,
            headers: createDefaultHeader())
        return .success(upload)
    }
}
