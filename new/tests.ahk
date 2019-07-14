#include kardashian.ahk
#include browsefeed.ahk
bot := new KardashianBot("blissmolecule")

try {
    bot.commentLB()
}
catch e {
    LogError(e)
}

OpenCommenterProfile()
; BrowseFeed()

range1 := profile[2]"!A2:A"
url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
oArray := json.Load(UrlDownloadToVar(url))
random, row, 2, oArray.values.MaxIndex()
targetAccount := oArray.values[row][1]

results := follow(targetAccount, profile)
SleepRand()
response := Report(profile, results, cell)
