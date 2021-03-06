VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Monitor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim Title As String, Class As String, PID As Long, img As String, Hwnd As Long, time As Long
Public Sub ConfirmRule()
    ReDim Preserve Breaks.List(UBound(Breaks.List) + 1)
    With Breaks.List(UBound(Breaks.List))
        .Title = BRT
        .ClassName = BRC
        .ImName = BRI
    End With
    Open DataPath & "\break.db" For Binary As #1
    Put #1, , Breaks
    Close #1
    TrayBalloon AppWindow, "New rule added.", "BREAKER", NIIF_ICON_MASK
End Sub
Public Sub Update()
    Dim Ti As String * 255, Hw As Long, PI As Long
    Dim Title2 As String, ImN() As String, ImName2 As String, ImName As String
    Dim Class As String * 255

    Hw = GetForegroundWindow
    GetClassNameA Hw, Class, 255
    GetWindowThreadProcessId Hw, PI
    
    If BreakTime <> 0 And GetTickCount - BreakTime >= 5000 Then
        BreakTime = 0
        BRT = UnSpace(Title)
        BRC = UnSpace(Class)
        BRI = UnSpace(img)
        ECore.NewTransform , , "RulePage"
        AppWindow.SetFocus
        ShowWindow AppWindow.Hwnd, SW_SHOW
    End If
    
    If Hwnd = Hw Then
        GetWindowTextA Hw, Ti, 255
        If Title <> Ti Then
            Title = Ti
            Log "Monitor", "标题变化： " & UnSpace(Title) & " (" & img & ")。"
        End If
        GoTo BreakExe
        'Exit Sub
    End If
    
    If Hwnd <> 0 Then
        time = GetTickCount - time
        Log "Monitor", "总计时长： " & Int(time / 100) / 10 & "s。"
        Log "Monitor", "================================================"
        time = GetTickCount
    End If
    
    PID = PI: Hwnd = Hw
    time = GetTickCount
    
    GetWindowTextA Hw, Ti, 255
    Title = Ti
    
    ImName2 = GetProcessPath(Hwnd)
    ImN = Split(ImName2, "\")
    ImName = LCase(ImN(UBound(ImN)))
    img = ImName

    Log "Monitor", "打开了： " & UnSpace(Ti) & " (" & img & ")。"
    
BreakExe:
    
    If user <> "" Then Exit Sub
    
    For I = 1 To UBound(Breaks.List)
        With Breaks.List(I)
            If (LCase(UnSpace(Ti)) Like LCase(.Title)) And (LCase(UnSpace(Class)) Like LCase(.ClassName)) And (LCase(UnSpace(img)) Like LCase(.ImName)) Then
                CloseWindow Hwnd '最小化！
                ShowWindow Hwnd, SW_HIDE '藏起来！
                DestroyWindow Hwnd '关掉！
                SendMessageA Hwnd, WM_CLOSE, 0, 0 '必杀技！
                Log "Breaker", "成功阻止：" & .Title & " | " & .ClassName & " | " & .ImName
                Log "Monitor", "于是该窗口被本工具阻断！"
                TrayBalloon AppWindow, "Broke a target window, unlock for details.", "BREAKER", NIIF_ICON_MASK
            End If
        End With
    Next
End Sub

Sub CarryKeyBoard(Str As String)
    If img = "" Then Exit Sub
    Open DataPath & "\Logs\Keyboard\" & img & " - " & year(Now) & "年" & Month(Now) & "月" & Day(Now) & "日.txt" For Append As #1
    Print #1, Now & "    " & Str
    Close #1
End Sub

Private Sub Class_Initialize()
    If Dir(DataPath & "\break.db") = "" Then
        ReDim Breaks.List(0)
        Open DataPath & "\break.db" For Binary As #1
        Put #1, , Breaks
        Close #1
    Else
        Open DataPath & "\break.db" For Binary As #1
        Get #1, , Breaks
        Close #1
    End If
End Sub
