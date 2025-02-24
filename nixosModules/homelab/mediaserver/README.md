# mediaserver
A media server stack

## Manual Setup
### qBittorrent
1. Retrieve the temporary password from `systemctl status qbittorrent.service`
2. Log in at `127.0.0.1:8080`
3. Open settings (`Tools > Options...`)
4. Set `Options > Advanced > qBittorrent Section > Network interface` to a VPN interface
5. Configure the WebUI:
  1. Got to `Options > Web UI`
  2. Set `IP address` to `127.0.0.1`
  3. Set a new username and password

Continue by following this [basic setup](https://trash-guides.info/Downloaders/qBittorrent/Basic-Setup/).

### Prowlarr
#### Setup FlareSolverr to bypass cloudflare
1. Log in at `127.0.0.1:9696`
2. Follow the instructions to setup authentication
3. Go to `Settings > Indexers`
4. Add an Indexer Proxy using the large + button
5. Select `FlareSolverr`
6. Add a `cloudflare` tag to the `Tags` field
7. Click `Test` and `Save`

#### Add Indexers
Add indexers from the `Indexers` tab in the side bar.
> [!TIP]
> Some indexers are protected by Cloudflare and must be accessed using FlareSolverr
> Add the tag configured above to the `Tags` field of the indexer to use FlareSolverr as a proxy

#### Add Apps
> [!NOTE]
> You will need to setup any apps first to get access to their API keys
1. Go to `Settings > Apps`
2. Add enabled *arr apps:
  1. Add an Application using the large + button 
  2. Select the app you want to add
  3. Retrieve the API key from app
  4. Click `Test` and `Save`

### Add Download Clients to *arr apps
1. Go to `Settings > Download Clients`
2. Add a Download Client using the large + button 
3. Select qBittorrent from the list
4. Enter the username and password cofigured above
5. Click `Test` and `Save`

### Sonarr
#### Add a Root Folder
1. Go to `Settings > Media Management`
2. Click `Add Root Folder`
3. Add the `<dataDir>/media/tv` directory

#### Enable Episode Renaming
1. Go to `Settings > Media Management`
2. Check `Rename Episodes`
3. Save

#### Add Import Lists
1. Go to `Settings > Import Lists`
2. Add an Import List using the large + button
3. Select a provider from the list and follow the instructions
