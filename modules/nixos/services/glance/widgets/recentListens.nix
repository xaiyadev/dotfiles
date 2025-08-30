{
  type = "custom-api";
  title = "Recent listens";
  cache = "60s";
  url = "http://ws.audioscrobbler.com/2.0/";
  parameters = {
    method = "user.getRecentTracks";
    user = "xaiyadev";
    api_key = "\${LASTFM_APIKEY}";
    format = "json";
    limit = "5";
  };

  template = ''
    <ul class="list list-gap-10 collapsible-container" data-collapse-after="1">
    {{ range .JSON.Array "recenttracks.track" }}
      <li class="flex items-center gap-10">
        <img src={{ .String "image.2.#text" }} style="border-radius: 5px; min-width: 5rem; max-width: 5rem;" class="card">
        <div class="flex-1">
          <p class="color-positive size-h5">{{ .String "artist.#text" }}</p>
          <p class="size-h5">{{ .String "name" }}</p>
          <p class="size-h6">
            {{ if .String "@attr.nowplaying" }}
              <span class="color-positive">Now playing</span>
            {{ else }}
              <span class="color-subdue" {{ .String "date.#text" | parseRelativeTime "02 Jan 2006, 15:04" }}></span>
            {{ end }}
          </p>
        </div>
      </li>
    {{ end }}
    </ul>
  '';
}