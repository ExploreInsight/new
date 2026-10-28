import Carbon

/// Carbon registers discrete shortcuts without watching the user's keystrokes.
final class GlobalShortcuts {
    private var handler: EventHandlerRef?
    private var refs: [EventHotKeyRef] = []
    var perform: ((UInt32) -> Void)?

    func start() -> Bool {
        guard handler == nil else { return true }
        var type = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        let context = Unmanaged.passUnretained(self).toOpaque()
        let status = InstallEventHandler(GetApplicationEventTarget(), { _, event, context in
            guard let event, let context else { return OSStatus(eventNotHandledErr) }
            var identifier = EventHotKeyID()
            let result = GetEventParameter(event, EventParamName(kEventParamDirectObject),
                EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &identifier)
            guard result == noErr else { return result }
            let actionID = identifier.id
            MainActor.assumeIsolated {
                let owner = Unmanaged<GlobalShortcuts>.fromOpaque(context).takeUnretainedValue()
                owner.perform?(actionID)
            }
            return noErr
        }, 1, &type, context, &handler)
        guard status == noErr else { return false }
        let keys: [(UInt32, UInt32)] = [
            (UInt32(kVK_Space), UInt32(controlKey | optionKey)),
            (UInt32(kVK_LeftArrow), UInt32(cmdKey | optionKey)),
            (UInt32(kVK_RightArrow), UInt32(cmdKey | optionKey)),
            (UInt32(kVK_Return), UInt32(cmdKey | optionKey)),
            (UInt32(kVK_ANSI_R), UInt32(cmdKey | optionKey))
        ]
        for (index, key) in keys.enumerated() {
            var ref: EventHotKeyRef?
            let id = EventHotKeyID(signature: 0x534E4150, id: UInt32(index))
            guard RegisterEventHotKey(key.0, key.1, id, GetApplicationEventTarget(), 0, &ref) == noErr,
                  let ref else { stop(); return false }
            refs.append(ref)
        }
        return true
    }

    func stop() {
        refs.forEach { UnregisterEventHotKey($0) }
        refs.removeAll()
        if let handler { RemoveEventHandler(handler) }
        handler = nil
    }
}
