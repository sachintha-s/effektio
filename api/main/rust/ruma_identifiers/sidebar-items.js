initSidebarItems({"enum":[["DeviceKeyAlgorithm","The basic key algorithms in the specification."],["Error","An error encountered when trying to parse an invalid ID string."],["EventEncryptionAlgorithm","An encryption algorithm to be used to encrypt messages sent to a room."],["RoomVersionId","A Matrix room version ID."],["SigningKeyAlgorithm","The signing key algorithms defined in the Matrix spec."]],"macro":[["device_id","Shorthand for `<&DeviceId>::from`."],["device_key_id","Compile-time checked `DeviceKeyId` construction."],["event_id","Compile-time checked `EventId` construction."],["mxc_uri","Compile-time checked `MxcUri` construction."],["room_alias_id","Compile-time checked `RoomAliasId` construction."],["room_id","Compile-time checked `RoomId` construction."],["room_version_id","Compile-time checked `RoomVersionId` construction."],["server_name","Compile-time checked `ServerName` construction."],["server_signing_key_id","Compile-time checked `ServerSigningKeyId` construction."],["user_id","Compile-time checked `UserId` construction."]],"mod":[["matrix_uri","Matrix URIs."],["user_id","Matrix user identifiers."]],"struct":[["ClientSecret","A client secret."],["DeviceId","A Matrix key ID."],["DeviceKeyId","A key algorithm and a device id, combined with a ‘:’."],["EventId","A Matrix event ID."],["KeyId","A key algorithm and key name delimited by a colon."],["KeyName","A Matrix key identifier."],["MatrixToUri","The `matrix.to` URI representation of a user, room or event."],["MatrixUri","The `matrix:` URI representation of a user, room or event."],["MxcUri","A URI that should be a Matrix-spec compliant MXC URI."],["RoomAliasId","A Matrix room alias ID."],["RoomId","A Matrix room ID."],["RoomName","The name of a room."],["RoomOrAliasId","A Matrix room ID or a Matrix room alias ID."],["ServerName","A Matrix-spec compliant server name."],["SessionId","A session ID."],["Signatures","Map of all signatures, grouped by entity"],["TransactionId","A Matrix transaction ID."],["UserId","A Matrix user ID."]],"type":[["DeviceSignatures","Map of device signatures for an event, grouped by user."],["DeviceSigningKeyId","Algorithm + key name for device keys."],["EntitySignatures","Map of key identifier to signature values."],["ServerSignatures","Map of server signatures for an event, grouped by server."],["ServerSigningKeyId","Algorithm + key name for homeserver signing keys."],["SigningKeyId","Algorithm + key name for signing keys."]]});