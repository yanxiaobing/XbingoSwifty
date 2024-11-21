//
//  CollectionElements.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/11/21.
//

import UIKit

open class BaseCM {
    public var type : String = ""
    public var data : Any?
    
    public init(_ cmType : String,_ cmData : Any? = nil) {
        type = cmType
        data = cmData
    }
}

public protocol CollectionElementsProtocol {
    associatedtype T: BaseCM
    var dataSource: [T] {get set}
    func updateDataSource(_ data: Any?) -> Void
}

public let _xbingo_index_path_ = "_xbingo_index_path_"

public extension IndexPath{
    var string: String {
        return "\(row)" + _xbingo_index_path_ + "\(section)"
    }
}

public extension String{
    var indexPath: IndexPath {
        let rs = self.components(separatedBy: _xbingo_index_path_)
        if rs.count != 2 {
            fatalError("String does not conform to rule")
        }
        return IndexPath(row: Int(rs.first!)!, section: Int(rs.last!)!)
    }
}

public extension UICollectionView {
    
    var realWidth: CGFloat {
        return self.bounds.width - self.contentInset.left - self.contentInset.right
    }
    
    var realHeight: CGFloat {
        return self.bounds.height - self.contentInset.top - self.contentInset.bottom
    }
    
    var minimumLineSpacing: CGFloat {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        return layout.minimumLineSpacing
    }
    
    var minimumInteritemSpacing: CGFloat {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        return layout.minimumInteritemSpacing
    }
    
    func realSectionWidth(_ section: Int) -> CGFloat {
        guard let delegate = self.delegate as? UICollectionViewDelegateFlowLayout else { return 0 }
        let insert = delegate.collectionView?(self, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
        return self.bounds.width - insert.left - insert.right
    }
}

open class CollectionViewCell: UICollectionViewCell {
    
    private static var reuseId: String {
        return NSStringFromClass(self) as String
    }
    
    open class func size(_ collection: UICollectionView, _ data:Any? = nil, _ indexPath: IndexPath = .init()) -> CGSize {
        return CGSize.zero
    }
    
    public static func cell(_ collection: UICollectionView, _ indexPath: IndexPath, _ reuseSuffix: String = "") -> Self {
        
        let finalReuseId = self.reuseId + reuseSuffix
        
        if collection.cellReuseIds.contains(finalReuseId) {
            return collection.dequeueReusableCell(withReuseIdentifier: finalReuseId, for: indexPath) as! Self
        }
        
        collection.register(self, forCellWithReuseIdentifier: finalReuseId)
        collection.cellReuseIds.append(finalReuseId)
        return collection.dequeueReusableCell(withReuseIdentifier: finalReuseId, for: indexPath) as! Self
    }
    
    open func update(data :Any?, indexPath: IndexPath = .init(), anyParams: Any? = nil){}
}

open class CollectionResuableView: UICollectionReusableView {
    
    private static var reuseId: String {
        return NSStringFromClass(self) as String
    }
    
    open class func size(_ collection: UICollectionView, _ data:Any? = nil, _ section: Int = 0) -> CGSize {
        return CGSize.zero
    }
    
    open static func view(_ collection: UICollectionView, _ kind: String, _ indexPath: IndexPath, _ reuseSuffix: String = "") -> Self {
        
        let finalReuseId = self.reuseId + reuseSuffix
        
        if let reuseIds = collection.viewKindReuseIdsMap[kind], reuseIds.contains(finalReuseId) {
            return collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: finalReuseId, for: indexPath) as! Self
        }
        
        collection.register(self, forSupplementaryViewOfKind: kind, withReuseIdentifier: finalReuseId)
        var ids = collection.viewKindReuseIdsMap[kind] ?? .init()
        ids.append(finalReuseId)
        collection.viewKindReuseIdsMap.updateValue(ids, forKey: kind)
        return collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: finalReuseId, for: indexPath) as! Self
    }
    
    open func update(_ data :Any?, _ indexPath: IndexPath = .init()){}
}


fileprivate extension UICollectionView {
    
    private struct XBKeys {
        @MainActor static var cellReuseIds: Int = 0
        @MainActor static var viewKindReuseIdsMap: Int = 0
    }
    
    var cellReuseIds: [String] {
        get {
            if let identifiers = objc_getAssociatedObject(self, &XBKeys.cellReuseIds) as? [String] {
                return identifiers
            } else {
                let identifiers = [String]()
                objc_setAssociatedObject(self, &XBKeys.cellReuseIds, identifiers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return identifiers
            }
        }
        
        set {
            objc_setAssociatedObject(self, &XBKeys.cellReuseIds, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var viewKindReuseIdsMap: [String:[String]] {
        get {
            if let identifiers = objc_getAssociatedObject(self, &XBKeys.viewKindReuseIdsMap) as? [String:[String]] {
                return identifiers
            } else {
                let identifiers = [String:[String]]()
                objc_setAssociatedObject(self, &XBKeys.viewKindReuseIdsMap, identifiers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return identifiers
            }
        }
        
        set {
            objc_setAssociatedObject(self, &XBKeys.viewKindReuseIdsMap, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

open class TableViewCell: UITableViewCell {
    
    private static var reuseId: String {
        return NSStringFromClass(self) as String
    }
    
    open class func height(_ data: Any?, _ indexPath: IndexPath = .init()) -> CGFloat {
        return 0.0
    }
    
    open static func cell(_ tableView: UITableView, _ indexPath: IndexPath, _ reuseSuffix: String = "") -> Self {
        
        let finalReuseId = self.reuseId + reuseSuffix
        
        if tableView.cellReuseIds.contains(finalReuseId) {
            return tableView.dequeueReusableCell(withIdentifier: finalReuseId, for: indexPath) as! Self
        }
        
        tableView.register(self, forCellReuseIdentifier: finalReuseId)
        tableView.cellReuseIds.append(finalReuseId)
        return tableView.dequeueReusableCell(withIdentifier: finalReuseId, for: indexPath) as! Self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews(){}
    
    open func update(_ data :Any?, _ indexPath: IndexPath = .init()){}
}

open class TableViewHeaderFooterView : UITableViewHeaderFooterView {
    
    private static var reuseId: String {
        return NSStringFromClass(self) as String
    }
    
    open class func height(_ data: Any?, _ section: Int) -> CGFloat{
        return 0.0
    }
    
    open static func view(_ tableView: UITableView, _ reuseSuffix: String = "") -> UIView? {
        
        let finalReuseId = self.reuseId + reuseSuffix
        if tableView.viewReuseIds.contains(finalReuseId) {
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: finalReuseId)
        }
        
        tableView.register(self, forHeaderFooterViewReuseIdentifier: finalReuseId)
        tableView.viewReuseIds.append(finalReuseId)
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: finalReuseId)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews(){}
    
    open func update(_ data: Any?, _ section: Int = 0){}
    
}

fileprivate extension UITableView {
    
    private struct XBKeys {
        @MainActor static var cellReuseIds: Int = 0
        @MainActor static var viewReuseIds: Int = 0
    }
    
    var cellReuseIds: [String] {
        get {
            if let identifiers = objc_getAssociatedObject(self, &XBKeys.cellReuseIds) as? [String] {
                return identifiers
            } else {
                let identifiers = [String]()
                objc_setAssociatedObject(self, &XBKeys.cellReuseIds, identifiers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return identifiers
            }
        }
        
        set {
            objc_setAssociatedObject(self, &XBKeys.cellReuseIds, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var viewReuseIds: [String] {
        get {
            if let identifiers = objc_getAssociatedObject(self, &XBKeys.viewReuseIds) as? [String] {
                return identifiers
            } else {
                let identifiers = [String]()
                objc_setAssociatedObject(self, &XBKeys.viewReuseIds, identifiers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return identifiers
            }
        }
        
        set {
            objc_setAssociatedObject(self, &XBKeys.viewReuseIds, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
