
---@type Select
local function select(url)
    return url:find("https://www.youtube.com", 1, true) == 1
end

---Downloads the video.
---@type Download
local function download(url, folder, callback)
    vim.system(
        {
            "yt-dlp",

            "--no-playlist",

            "--paths", "home:" .. folder,
            "--paths", "temp:~/cache/yt-dlp",
            "--output", "%(uploader)s - %(title)s.%(ext)s",

            "--print", "after_move:filepath",
            url,
        },
        {},
        function(output)
            if output.code == 0 then
                callback(output.stdout)
            else
                callback(nil, "YouTube (yt-dlp) : " .. output.stderr)
            end
        end
    )
end

return {
    ---@type Downloader
    downloader = {
        select = select,
        download = download,
    }
}

