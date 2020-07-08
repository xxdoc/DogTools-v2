VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "AppPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ����ģ������Emerald������ ҳ������� ģ��
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim Scan As String, ScanTime As Long, Working As Boolean
    Dim Faces() As String, Score As Long
    Dim RefreshTime As Long, LastDC As Long, PassTime As Long
'======================================

Public Sub Update()
    'Ӧ�ý���ÿһ֡ˢ�»���õķ�����ҳ����ƴ�������ڴ˴���
    
    Page.Clear argb(255, 0, 0, 0) '��ջ���

    Page.Writes "����ͷ" & NowWebcam & "δ����", GW / 2, GH / 2 - 17, 24, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold

    If GetTickCount - RefreshTime <= 100 Or Scan <> "" Then
        PaintDC LastDC, Page.CDC: GoTo skipCatch
    End If
    
    RefreshTime = GetTickCount
    
    Call CatchWebCam(Page, GetTickCount - ScanTime >= 1000 And Not Working)
    
    If GetTickCount - ScanTime >= 1000 And Not Working Then
        ScanTime = GetTickCount: Working = True
        Dim Code As Long, PID As Long, hid As Long
        Scan = ""
        For I = 1 To UBound(Faces)
            PID = Shell(App.path & "\engine\facecheck.exe " & """" & App.path & "\source\" & Faces(I) & """" & " " & """" & App.path & "\tar.bmp" & """", vbHide)
            hid = OpenProcess(PROCESS_QUERY_INFORMATION Or PROCESS_VM_READ, 0, PID)
            Do
                GetExitCodeProcess hid, Code
                ECore.Display: DoEvents
            Loop While Code = STATUS_PENDING
            CloseHandle hid
            If Code > 78 Then
                Score = Code
                Scan = Split(Faces(I), ".")(0)
                ECore.NewTransform transFadeIn, 1000
                PassTime = GetTickCount
                Exit Sub
            End If
        Next
        Working = False
        Exit Sub
    End If
    
    PaintDC Page.CDC, LastDC
    
skipCatch:
    
    Dim pro As Single
    If PassTime <> 0 Then pro = (GetTickCount - PassTime) / 1000
    If pro > 1 Then pro = 1
    pro = Cubic(pro, 0, 1, 1, 1)
    
    If Scan <> "" Then
        user = Scan
        Page.Paint 0, 0, 0, GW, GH, argb(210, 0, 0, 0)
        Page.Writes Scan, GW / 2 + 1 - pro * 100, GH / 2 - 17, 24, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
        Page.Writes "Welcome", GW / 2 + 1 + pro * 100, GH / 2 - 17, 24, argb(pro * 255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
        Page.Writes Int(pro * Score) & "%", GW / 2, GH - 80, 24, argb(pro * 200, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
        Page.Paint 0, GW / 2 + 1 + pro * 50, GH / 2 + 25, pro * 105, 7, argb(pro * 255, 255, 255, 255)
    Else
        Page.Paint 0, 0, 0, GW, GH, argb(60, 0, 0, 0)
    End If
    
    If Working Then Page.ShowLoading GW / 2 - 50 - pro * 100, GH / 2 - 50, 100, 100, 10, argb(255, 255, 255, 255), argb(160, 255, 255, 255), argb(80, 255, 255, 255)

    Page.Writes "switch the camera", GW / 2, GH - 80 + 200 * pro, 24, argb(200 - 200 * pro, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    If CheckMouse(GW / 2 - 200, GH - 120, 400, 80) >= mMouseDown And pro = 0 Then
        SwitchWebCam
    End If
    
    If GetTickCount - PassTime >= 2000 And PassTime <> 0 Then
        Log "Tools", user & "��½�˹��ߡ�"
        Scan = "": PassTime = 0: Working = False
        ECore.NewTransform transFadeIn, 1000, "MainPage"
    End If
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    Set Page = New GPage  '����ҳ�������
    Page.Create Me  '�����������������
    Page.Res.NewImages App.path & "\assets"  '������Դ
    ECore.Add Page, "AppPage"  '����ҳ��
    LastDC = CreateCDC(GW, GH)
    Dim Face As String
    Face = Dir(App.path & "\source\")
    ReDim Faces(0)
    Do While Face <> ""
        ReDim Preserve Faces(UBound(Faces) + 1)
        Faces(UBound(Faces)) = Face
        Face = Dir()
    Loop
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub