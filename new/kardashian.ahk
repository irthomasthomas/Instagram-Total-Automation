#include InstaFunctions.ahk

try {
    result := kardashianBot("Blissmolecule")
}
catch e {
    LogError(e)
}

kardashianBot(account) {
    closeChrome()
    OpenUrlChrome(kardashianURL(), chromeProfilePath(account))
    Random p, 1, 2
    ; clicked := ClickPost(p)
    clicked := False
	If !clicked
    {   
        throw { module: "kardashianBot", msg: "Failed to ClickPost " p, account: account} 
    }
	
}
