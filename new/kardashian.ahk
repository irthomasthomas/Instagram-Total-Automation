#include InstaFunctions.ahk


class KardashianBot {

    __New(account){
        this.account := account
        this.url := KardashianURL()
        this.chrome := chromeProfilePath(account)
        this.comments := kComments()
    }

    commentLB() 
    {
        closeChrome()
        OpenUrlChrome(this.url, this.chrome)
        SleepRand(1000,3000)
        Random p, 1, 2
        clicked := ClickPost(p)
        ; clicked := True
        if !clicked
            throw { msg: "kardashianBot: Failed to ClickPost " p, account: this.account } 
        try { 
            random, i, 1, this.comments.values.Length()
            result := doComment(this.comments.values[i][1]) 
            }
        catch e 
        { 
            throw e 
        }
    }
}

kardashianURL() {
	Random, targetN, 1, 2
	If targetN = 1
	{
		URL=https://www.instagram.com/kyliejenner/
	}
	Else If targetN = 2
	{
		URL=https://www.instagram.com/kendalljenner/
	}
	Else URL=https://www.instagram.com/kimkardashian/
	return, URL
}

doComment(comment)
{
    ; Verify it is a kardashian profile first
    Text:="|<small blue tick>*183$12.2E3kDwDwzbNCQSyzDwDw3k2EU"
    if !(ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
    throw { msg: "kardashianBot:Comment: No blue tick found ", account:"" } 
    ; leave comment 
    Random p, 1, 2
    ClickPost(p)
    SleepRand(699, 1999)
    PostComment(comment)
    Return True
}

