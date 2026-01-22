import Logging

/// A global logger for the application.
///
/// The distinction between various log levels can be vague, so for consistency, we use them as follows:
///   - `critical` logs a severe error that indicates an issue with the app itself.
///     These errors severly degrade the app's functionality, and should be fixed as soon as possible.
///   - `error` logs an error that often is the result of a user-initiated action.
///     These errors may cause a limited loss of functionality, but otherwise don't affect the app.
///   - `warning` logs an issue that may indicate an error and may warrant further investigation.
let logger = Logger(label: "ComicViewer")
