
class KardashianBot {

    __New(account){
        this.comments := kComments()
        ; this.account := account
        ; this.url := KardashianURL()
        ; this.settings := settings(account)
        ; this.chrome := this.settings[1]
        ; this.targetSheet := this.settings[2]
        ; this.comments := kComments() 
    }

    commentLB(url,chrome) 
    {
        OpenUrlChrome(url, chrome)
		; Sock.SendText(Jxon_Dump(Obj)) wtf
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
    ; msgbox % "docomment " comment
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

