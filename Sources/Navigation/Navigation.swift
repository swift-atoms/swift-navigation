public import Tagged

public enum Navigation {}

extension Navigation {

    public typealias Identity = Tagged<Navigation, UInt64>
}
