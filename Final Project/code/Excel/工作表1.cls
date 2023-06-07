Sub Add_UI()
    Dim s As OLEObject
    Dim i As Long
    Dim ws As Worksheet: Set ws = Sheets("test")
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
        obj.Object.Font.Name = "Arial"
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
        TableName = myRS.Fields(0).Value
        tabletext.AddItem TableName
        myRS.MoveNext
    Wend
    
    myRS.Close
    myCon.Close
    Set myRS = Nothing
    Set myCon = Nothing
    
End Sub


Private Sub tabletext_LostFocus()
    Worksheets("test").Rows(10).Delete
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
'    Worksheets("test").Rows(11 & ":" & Worksheets("test").Rows.Count).Delete
    Dim exists As Boolean

    For i = 1 To Worksheets.Count
        If Worksheets(i).Name = tabletext.Text Then
            exists = True
            Exit For
        End If
    Next i
    
    If Not exists Then
        Worksheets.Add(After:=Worksheets("test")).Name = tabletext.Text
    End If
    
    Worksheets(tabletext.Text).Rows(2 & ":" & Worksheets("test").Rows.Count).Delete
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"
    
    Set myRS = myCon.Execute("SHOW COLUMNS FROM " & tabletext.Text & ";")

    i = 1
    While Not myRS.EOF
        TableName = myRS.Fields(0).Value
        Worksheets(tabletext.Text).Cells(1, i) = TableName
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

    Set ws = ThisWorkbook.Worksheets("test")

    config_path = ThisWorkbook.path & "\" & "config.json"
    
    Set JsonTS = FSO.OpenTextFile(config_path, ForReading)
    JsonText = JsonTS.ReadAll
    JsonTS.Close
    Set JSON = ParseJson(JsonText)
    
    ' Set the path to your Python script
    scriptPath = ThisWorkbook.path & "\" & JSON("py_script_name")
    
    lastRow = ws.Range("A" & Rows.Count).End(xlUp).Row
    lastCol = ws.Cells(11, Columns.Count).End(xlToLeft).Column
    If lastRow = 10 Then
        MsgBox ("No Data!")
        End
    End If
    arg1 = "(10,1)"
    arg2= "(10," & lastCol & ")"
    arg3 = "(11,1)"
    arg4 = "(" & lastRow & "," & lastCol & ")"
    
    startRow = 10
    startColumn = 1

    ' Call the Python script with arguments
    Call shell("python " & scriptPath & " " & arg1 & " " & arg2 & " " & arg3 & " " & arg4)

    MsgBox ("Data upload successfully")
    ws.Rows(11 & ":" & ws.Rows.Count).Delete
    
    Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


Private Sub Delete_All_Click()
    Worksheets("test").Rows(11 & ":" & Worksheets("test").Rows.Count).Delete
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
        End
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
    Set myCon = Nothing

    MsgBox ("Create table successfully!")


    Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


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


Private Sub Archive()
    '1
    On Error GoTo ErrorHandler
    Set myCon = CreateObject("ADODB.Connection")
    myCon.Open "Driver={MySQL ODBC 8.0 UNICODE Driver};Server=" & Servertext.Text & ";Database=" & Databasetext.Text & ";User=" & UserNametext.Text & ";Password=" & Passwordtext.Text & ";Option=3;"

    Set myRS = CreateObject("ADODB.Recordset")
    
    lastRow = Sheets("test").Range("A" & Rows.Count).End(xlUp).Row
    lastCol = Sheets("test").Cells(10, Columns.Count).End(xlToLeft).Column
    
    For num_row = 11 To lastRow
        sql_prepared = ""
        For num_col = 1 To lastCol

            If num_col = lastCol Then
                sql_prepared = sql_prepared & Cells(num_row, num_col).Value
            Else
                sql_prepared = sql_prepared & Cells(num_row, num_col).Value & ","
            End If

        Next num_col

        sql = "insert into wine1 values (" & sql_prepared & ")"
        myRS.Open sql, myCon, adOpenStatic

    Next num_row

    MsgBox ("Data upload successfully")

    Worksheets("test").Rows(11 & ":" & Worksheets("test").Rows.Count).Delete
    '2
    ' Set the input values from specific cells
    Set selectRange = Application.InputBox("Please select the range:", Type:=8)
    
Exit Sub
ErrorHandler:
    MsgBox (Err.Description)
End Sub


