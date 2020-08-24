//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import connectivity_macos
import firebase_core
import firebase_storage
import path_provider_macos
import shared_preferences_macos
import sqflite

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  ConnectivityPlugin.register(with: registry.registrar(forPlugin: "ConnectivityPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseStoragePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseStoragePlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
