MIDNIGHT RACING — Y8 SDK PREPARATION

This build adds the official Y8 JavaScript SDK loader and an optional “SIGN IN WITH Y8” option using the App ID supplied by the developer.

Important:
- Supabase remains in place for existing accounts, profile cloud saves, matchmaking and multiplayer. Y8 sign-in is a separate platform identity.
- Guest play remains available.
- Y8 ads are not enabled yet because the Y8 Game ID has not been supplied/configured.
- Y8 Cloud Storage, leaderboard tables and achievements are not enabled in this build. They need deliberate save migration and configuration in the Y8 portal to avoid overwriting existing player progress.
- For sign-in testing away from the Y8 game page, add the exact testing website origin to the game's SDK Initialization > Development Origins list in the Y8 Developer Portal.

The Y8 SDK script is loaded from Y8's official CDN.
