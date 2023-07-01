VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "工作表1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True




Sub Add_UI()
    Dim s As OLEObject
    Dim i As Long
    Dim ws As Worksheet: Set ws = Sheets("main-sheet")
    Label1 = Array("Server", "UserName", "Password")
    Label2 = Array("Database", "Table")
    TextBox1 = Array("Servertext", "UserNametext", "Passwordtext")
    TextBox2 = Array("Databasetext", "tabletext")
    Button = Array("Download", "Upload", "Delete_All")
    RemindLabel = Array("Remind")
    createLabel = Array("TableName", "Attributes", "Types")
    createTextbox = Array("tnText", "attrText", "typeText")
    createButton = Array("CREATE")


    With ws
        For i = LBound(Label1) To UBound(Label1)
            If Not objectExists(ws, Label1(i)) Then
                Set newLabel = ws.OLEObjects.Add(ClassType:="Forms.Label.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=10, _
                                          Top:=10 + 30 * i, _
                                          Width:=60, _
                                          Height:=20)
                newLabel.Object.Caption = Label1(i)
                newLabel.Name = Label1(i)
            End If
        Next i
        
        For i = LBound(Label2) To UBound(Label2)
            If Not objectExists(ws, Label2(i)) Then
                Set newLabel = ws.OLEObjects.Add(ClassType:="Forms.Label.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=180, _
                                          Top:=10 + 30 * i, _
                                          Width:=60, _
                                          Height:=20)
                newLabel.Object.Caption = Label2(i)
                newLabel.Name = Label2(i)
            End If
        Next i
        
        For i = LBound(TextBox1) To UBound(TextBox1)
            If Not objectExists(ws, TextBox1(i)) Then
                Set newTextBox = ws.OLEObjects.Add(ClassType:="Forms.TextBox.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=80, _
                                          Top:=10 + i * 30, _
                                          Width:=90, _
                                          Height:=20)
                newTextBox.Name = TextBox1(i)
            End If
        Next i
        

        
        For i = LBound(TextBox2) To UBound(TextBox2)
            If Not objectExists(ws, TextBox2(i)) Then
                Set newTextBox = ws.OLEObjects.Add(ClassType:="Forms.ComboBox.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=250, _
                                          Top:=10 + i * 30, _
                                          Width:=90, _
                                          Height:=20)
                newTextBox.Name = TextBox2(i)
            End If
        Next i
        
        For i = LBound(Button) To UBound(Button)
            If Not objectExists(ws, Button(i)) Then
                Set newButton = ws.OLEObjects.Add(ClassType:="Forms.CommandButton.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=i * 60, _
                                          Top:=120, _
                                          Width:=60, _
                                          Height:=30)
                newButton.Object.Caption = Button(i)
                newButton.Name = Button(i)
            End If
        Next i

        For i = LBound(RemindLabel) To UBound(RemindLabel)
            If Not objectExists(ws, RemindLabel(i)) Then
                Set newLabel = ws.OLEObjects.Add(ClassType:="Forms.Label.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=500, _
                                          Top:=10, _
                                          Width:=900, _
                                          Height:=20)
                newLabel.Object.Caption = "Enter the information of the table you want to create! (Please Seperated by commas)"
                newLabel.Name = RemindLabel(i)
            End If
        Next i

        For i = LBound(createLabel) To UBound(createLabel)
            If Not objectExists(ws, createLabel(i)) Then
                Set newLabel = ws.OLEObjects.Add(ClassType:="Forms.Label.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=500, _
                                          Top:=40 + i * 30, _
                                          Width:=65, _
                                          Height:=20)
                newLabel.Object.Caption = createLabel(i)
                newLabel.Name = createLabel(i)
            End If
        Next i
        

        For i = LBound(createTextbox) To UBound(createTextbox)
            If Not objectExists(ws, createTextbox(i)) Then
                Set newLabel = ws.OLEObjects.Add(ClassType:="Forms.TextBox.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=570, _
                                          Top:=40 + i * 30, _
                                          Width:=300, _
                                          Height:=20)
                newLabel.Name = createTextbox(i)
            End If
        Next i

        For i = LBound(createButton) To UBound(createButton)
            If Not objectExists(ws, createButton(i)) Then
                Set newButton = ws.OLEObjects.Add(ClassType:="Forms.CommandButton.1", _
                                          Link:=False, _
                                          DisplayAsIcon:=False, _
                                          Left:=900, _
                                          Top:=100, _
                                          Width:=60, _
                                          Height:=20)
                newButton.Object.Caption = createButton(i)
                newButton.Name = createButton(i)
            End If
        Next i
        
    End With

    Passwordtext.PasswordChar = "*"

    For Each obj In Me.OLEObjects
        obj.Object.Font.Name = "Calibri"
    Next obj
    
End Sub


Private Sub Passwordtext_LostFocus()

    Databasetext.Clear
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"

    Set myRS = myCon.Execute("SHOW DATABASES;")
    
    While Not myRS.EOF
        dbName = myRS.Fields(0).Value
        Databasetext.AddItem dbName
        myRS.MoveNext
    Wend

    myRS.Close
    myCon.Close
    Set myRS = Nothing
    Set myCon = Nothing
    
Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


Private Sub Databasetext_LostFocus()
    tabletext.Clear
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"
    
    Set myRS = myCon.Execute("SHOW TABLES;")
    
    While Not myRS.EOF
        Table_Name = myRS.Fields(0).Value
        tabletext.AddItem Table_Name
        myRS.MoveNext
    Wend
    
    myRS.Close
    myCon.Close
    Set myRS = Nothing
    Set myCon = Nothing
    
End Sub


Private Sub tabletext_LostFocus()
    Worksheets("main-sheet").Rows(10).Delete
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"

    Set myRS = myCon.Execute("SHOW COLUMNS FROM " & tabletext.Text & ";")

    i = 1
    While Not myRS.EOF
        Table_Name = myRS.Fields(0).Value
        Cells(10, i) = Table_Name
        i = i + 1
        myRS.MoveNext
    Wend

    myRS.Close
    myCon.Close
    Set myRS = Nothing
    Set myCon = Nothing

Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


Private Sub Download_Click()
    Dim exists As Boolean
    ' Find if the worksheet of selected table is exist
    For i = 1 To Worksheets.Count
        If Worksheets(i).Name = tabletext.Text Then
            exists = True
            Exit For
        End If
    Next i
    
    If Not exists Then
        Worksheets.Add(After:=Worksheets("main-sheet")).Name = tabletext.Text
    End If
    
    ' Download data
    Worksheets(tabletext.Text).Rows(2 & ":" & Worksheets("main-sheet").Rows.Count).Delete
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"
    
    Set myRS = myCon.Execute("SHOW COLUMNS FROM " & tabletext.Text & ";")

    i = 1
    While Not myRS.EOF
        Table_Name = myRS.Fields(0).Value
        Worksheets(tabletext.Text).Cells(1, i) = Table_Name
        i = i + 1
        myRS.MoveNext
    Wend
    
    Set myRS = Nothing

    sql = "select * from " & tabletext.Text
    Set myRS = myCon.Execute(sql)
    Worksheets(tabletext.Text).Range("A2").CopyFromRecordset myRS
    
    myRS.Close
    myCon.Close
    Set myRS = Nothing
    Set myCon = Nothing

    MsgBox ("Data download successfully")
    
    Exit Sub

ErrorHandler:
    MsgBox (Err.Description)

End Sub


Private Sub Upload_Click()
    Dim FSO As New FileSystemObject
    Dim JsonTS As TextStream
    Dim scriptPath As String
    
    On Error GoTo ErrorHandler

    Set ws = ThisWorkbook.Worksheets("main-sheet")
    
    ' Select range of the upload data
    startRow = 10
    startColumn = 1
    
    lastRow = ws.Range("A" & Rows.Count).End(xlUp).Row
    lastCol = ws.Cells(11, Columns.Count).End(xlToLeft).Column
    If lastRow = 10 Then
        MsgBox ("No Data!")
        End
    End If

    arg1 = startRow
    arg2 = startColumn
    arg3 = lastRow
    arg4 = lastCol
    

    ' Set the path to your Python script
    config_path = ThisWorkbook.Path & "\" & "config.json"
    
    Set JsonTS = FSO.OpenTextFile(config_path, ForReading)
    JsonText = JsonTS.ReadAll
    JsonTS.Close
    Set JSON = ParseJson(JsonText)
    
    scriptPath = ThisWorkbook.Path & "\" & JSON("py_script_name")
    
    
    ' Set the waiting bar
    stb = Application.StatusBar
    dstb = Application.DisplayStatusBar

    Application.StatusBar = "執行中...請稍後..."
    
    
    ' Execute your python file
    cmd = "python " & scriptPath & " " & arg1 & " " & arg2 & " " & arg3 & " " & arg4 & " " & JSON("host") & " " & JSON("user") & " " & JSON("passwd")
    RetVal = RunCmd(cmd, True, 0)
    Debug.Print (cmd)
    
    
    ' Reset the waiting bar
    Application.DisplayStatusBar = dstb
    Application.StatusBar = stb

    ws.Rows(11 & ":" & ws.Rows.Count).Delete
    
    Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


Private Sub Delete_All_Click()
    Worksheets("main-sheet").Rows(11 & ":" & Worksheets("main-sheet").Rows.Count).Delete
End Sub


Private Sub CREATE_Click()
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"
    
    Set myRS = CreateObject("ADODB.Recordset")

    attri = Split(attrText.Text, ",")
    typ = Split(typeText.Text, ",")

    If Not UBound(attri) = UBound(typ) Then
        MsgBox ("Number of attributes MUST be same as types!!")
    End If

    For i = LBound(attri) To UBound(attri)
        If i = UBound(attri) Then
            sql_prepared = sql_prepared & Trim(attri(i)) & " " & Trim(typ(i))
        Else
            sql_prepared = sql_prepared & Trim(attri(i)) & " " & Trim(typ(i)) & ","
        End If
    Next i

    sql = "CREATE TABLE " & tnText.Text & "(" & sql_prepared & ")"
    Debug.Print (sql)

    myRS.Open sql, myCon, adOpenStatic

    myCon.Close

    MsgBox ("Create table successfully!")


    Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub

Public Function RunCmd(strCMD, Optional waitOnReturn As Boolean = True, Optional windowStyle As Integer = 1)
    ' Add the reference "Windows Script Host Object Model" to use this function
    ' strCMD: executed string
    ' windowStyle: 1-show, 0-not to show
    ' waitOnReturn: wait for return or not
    
    Dim wsh As Object
    Set wsh = VBA.CreateObject("WScript.Shell")
    Dim errorCode As Integer
    errorCode = wsh.Run(strCMD, windowStyle, waitOnReturn)

    If errorCode = 0 Then
        MsgBox ("Data upload successfully")
    Else
        MsgBox "執行錯誤" & vbCrLf & "代碼：" & errorCode & vbCrLf & "執行程式：" & strCMD
        Exit Function
    End If
    Exit Function

End Function

Public Function objectExists(ByRef ws As Worksheet, ByVal someName As String) As Boolean

    On Error GoTo objectExists_Error

    Dim someOle As OLEObject
    Set someOle = ws.OLEObjects(someName)
    objectExists = True

    On Error GoTo 0
    Exit Function

objectExists_Error:
    objectExists = False

End Function


Sub Archive()
    '1
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"

    Set myRS = CreateObject("ADODB.Recordset")
    
    lastRow = Sheets("main-sheet").Range("A" & Rows.Count).End(xlUp).Row
    lastCol = Sheets("main-sheet").Cells(11, Columns.Count).End(xlToLeft).Column
    
    For num_row = 11 To lastRow
        sql_prepared = ""
        For num_col = 1 To lastCol

            If num_col = lastCol Then
                sql_prepared = sql_prepared & "'" & Cells(num_row, num_col).Value & "'"
            Else
                sql_prepared = sql_prepared & "'" & Cells(num_row, num_col).Value & "',"
            End If

        Next num_col

        sql = "insert into " & tabletext.Text & " values (" & sql_prepared & ");"
'        Debug.Print (sql)
        myRS.Open sql, myCon, adOpenStatic

    Next num_row

    MsgBox ("Data upload successfully")

    Worksheets("main-sheet").Rows(11 & ":" & Worksheets("main-sheet").Rows.Count).Delete
'    '2
'    ' Set the input values from specific cells
'    Set selectRange = Application.InputBox("Please select the range:", Type:=8)
'
Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub
