//
//  ApWidgetLiveActivity.swift
//  ApWidget
//
//  Created by Vivek Madhukar on 13/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ApWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ApWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ApWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ApWidgetAttributes {
    fileprivate static var preview: ApWidgetAttributes {
        ApWidgetAttributes(name: "World")
    }
}

extension ApWidgetAttributes.ContentState {
    fileprivate static var smiley: ApWidgetAttributes.ContentState {
        ApWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ApWidgetAttributes.ContentState {
         ApWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ApWidgetAttributes.preview) {
   ApWidgetLiveActivity()
} contentStates: {
    ApWidgetAttributes.ContentState.smiley
    ApWidgetAttributes.ContentState.starEyes
}
