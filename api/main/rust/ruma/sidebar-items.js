initSidebarItems({"derive":[["Outgoing","Derive the `Outgoing` trait, possibly generating an ‘Incoming’ version of the struct this derive macro is used on."]],"enum":[["DeviceKeyAlgorithm","The basic key algorithms in the specification."],["EventEncryptionAlgorithm","An encryption algorithm to be used to encrypt messages sent to a room."],["RoomVersionId","A Matrix room version ID."],["SigningKeyAlgorithm","The signing key algorithms defined in the Matrix spec."]],"macro":[["device_id","Shorthand for `<&DeviceId>::from`."],["device_key_id","Compile-time checked `DeviceKeyId` construction."],["event_id","Compile-time checked `EventId` construction."],["mxc_uri","Compile-time checked `MxcUri` construction."],["room_alias_id","Compile-time checked `RoomAliasId` construction."],["room_id","Compile-time checked `RoomId` construction."],["room_version_id","Compile-time checked `RoomVersionId` construction."],["server_name","Compile-time checked `ServerName` construction."],["server_signing_key_id","Compile-time checked `ServerSigningKeyId` construction."],["user_id","Compile-time checked `UserId` construction."]],"mod":[["api","(De)serializable types for various Matrix APIs requests and responses and abstractions for them."],["authentication","Common types for authentication."],["directory","Common types for room directory endpoints."],["encryption","Common types for encryption related tasks."],["events","(De)serializable types for the events in the Matrix specification. These types are used by other ruma crates."],["identifiers","Types for Matrix identifiers for devices, events, keys, rooms, servers, users and URIs."],["matrix_uri","Matrix URIs."],["power_levels","Common types for the `m.room.power_levels` event."],["presence","Common types for the presence module."],["push","Common types for the push notifications module."],["receipt","Common types for receipts."],["serde","(De)serialization helpers for other ruma crates."],["signatures","Digital signatures according to the Matrix specification."],["thirdparty","Common types for the third party networks module."],["to_device","Common types for the Send-To-Device Messaging"],["user_id","Matrix user identifiers."]],"struct":[["ClientSecret","A client secret."],["DeviceId","A Matrix key ID."],["DeviceKeyId","A key algorithm and a device id, combined with a ‘:’."],["EventId","A Matrix event ID."],["KeyId","A key algorithm and key name delimited by a colon."],["KeyName","A Matrix key identifier."],["MatrixToUri","The `matrix.to` URI representation of a user, room or event."],["MilliSecondsSinceUnixEpoch","A timestamp represented as the number of milliseconds since the unix epoch."],["MxcUri","A URI that should be a Matrix-spec compliant MXC URI."],["RoomAliasId","A Matrix room alias ID."],["RoomId","A Matrix room ID."],["RoomOrAliasId","A Matrix room ID or a Matrix room alias ID."],["SecondsSinceUnixEpoch","A timestamp represented as the number of seconds since the unix epoch."],["ServerName","A Matrix-spec compliant server name."],["SessionId","A session ID."],["Signatures","Map of all signatures, grouped by entity"],["TransactionId","A Matrix transaction ID."],["UserId","A Matrix user ID."]],"trait":[["Outgoing","A type that can be sent to another party that understands the matrix protocol."]],"type":[["DeviceSignatures","Map of device signatures for an event, grouped by user."],["DeviceSigningKeyId","Algorithm + key name for device keys."],["EntitySignatures","Map of key identifier to signature values."],["ServerSignatures","Map of server signatures for an event, grouped by server."],["ServerSigningKeyId","Algorithm + key name for homeserver signing keys."]]});