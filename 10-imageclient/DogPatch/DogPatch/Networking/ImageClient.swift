/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

protocol ImageService {
  func downloadImage(fromUrl: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionTaskProtocol?
  func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceholder placeholder: UIImage?)
}

class ImageClient {
  
  static let shared = ImageClient(responseQueue: .main,
                                  session: URLSession.shared)
  
  var cachedImageForURL: [URL: UIImage]
  var cachedTaskForImageView: [UIImageView: URLSessionTaskProtocol]
  
  let responseQueue: DispatchQueue?
  let session: URLSessionProtocol
  
  init(responseQueue: DispatchQueue?, session: URLSessionProtocol) {
    self.responseQueue = responseQueue
    self.session = session
    
    self.cachedImageForURL = [:]
    self.cachedTaskForImageView = [:]
  }
}

extension ImageClient: ImageService {
  
  func downloadImage(fromUrl: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionTaskProtocol? {
    
    if let image = cachedImageForURL[fromUrl] {
      completion(image, nil)
      return nil
    }
    
    let task = session.makeDataTask(with: fromUrl) { [weak self] data, response, error in
      guard let self = self else {
        return
      }
      
      if let data = data, let image = UIImage(data: data) {
        self.cachedImageForURL[fromUrl] = image
        self.dispatch(image: image, completion: completion)
      } else {
        self.dispatch(error: error, completion: completion)
      }
    }
    
    task.resume()
    
    return task
  }
  
  private func dispatch(image: UIImage? = nil, error: Error? = nil, completion: @escaping (UIImage?, Error?) -> Void) {
    guard let responseQueue = responseQueue else {
      completion(image, error)
      return
    }
    
    responseQueue.async {
      completion(image, error)
    }
  }
  
  func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceholder placeholder: UIImage?) {
    cachedTaskForImageView[imageView]?.cancel()
    imageView.image = placeholder
    
    cachedTaskForImageView[imageView] = downloadImage(fromUrl: url) { [weak self] image, error in
      guard let self = self else {
        return
      }

      self.cachedTaskForImageView[imageView] = nil
      
      guard let image = image else {
        debugPrint("Set image failed with error: \(error?.localizedDescription)")
        return
      }
      
      imageView.image = image
    }
  }
  
}
