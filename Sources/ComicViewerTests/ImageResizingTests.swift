@testable import ComicViewer
import Foundation
import Testing

struct ImageResizingTests {

    @Test func `width scales up to minSize`() {
        let image = ComicImage(data: Data(), width: 100, height: 400)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 200)
        #expect(scale == 2)
    }
    
    @Test func `height scales up to minSize`() {
        let image = ComicImage(data: Data(), width: 400, height: 100)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 200)
        #expect(scale == 2)
    }
    
    @Test func `minSize takes priority over upScaleLimit`() {
        let image = ComicImage(data: Data(), width: 400, height: 100)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 200, upScaleLimit: 1)
        #expect(scale == 2)
    }
    
    @Test func `width scales down`() {
        let image = ComicImage(data: Data(), width: 500, height: 400)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, downScaleLimit: 0)
        #expect(scale == 0.8)
    }
    
    @Test func `height scales down`() {
        let image = ComicImage(data: Data(), width: 400, height: 500)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, downScaleLimit: 0)
        #expect(scale == 0.8)
    }
    
    @Test func `width doesn't scale down more than allowed`() {
        let image = ComicImage(data: Data(), width: 600, height: 400)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, downScaleLimit: 0.8)
        #expect(scale == 1)
    }
    
    @Test func `height doesn't scale down more than allowed`() {
        let image = ComicImage(data: Data(), width: 400, height: 600)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, downScaleLimit: 0.8)
        #expect(scale == 1)
    }
    
    @Test func `width doesn't scale down below minSize`() {
        let image = ComicImage(data: Data(), width: 600, height: 200)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 200, downScaleLimit: 0)
        #expect(scale == 1)
    }
    
    @Test func `height doesn't scale down below minSize`() {
        let image = ComicImage(data: Data(), width: 200, height: 600)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 200, downScaleLimit: 0)
        #expect(scale == 1)
    }

    @Test func `width scales up`() {
        let image = ComicImage(data: Data(), width: 200, height: 100)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, upScaleLimit: .infinity)
        #expect(scale == 2)
    }
    
    @Test func `height scales up`() {
        let image = ComicImage(data: Data(), width: 100, height: 200)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, upScaleLimit: .infinity)
        #expect(scale == 2)
    }
    
    @Test func `width doesn't scale up more than allowed`() {
        let image = ComicImage(data: Data(), width: 100, height: 50)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, upScaleLimit: 2)
        #expect(scale == 2)
    }
    
    @Test func `height doesn't scale up more than allowed`() {
        let image = ComicImage(data: Data(), width: 50, height: 100)
        let scale = image.scaleToFit(availableWidth: 400, availableHeight: 400, minSize: 0, upScaleLimit: 2)
        #expect(scale == 2)
    }
}
