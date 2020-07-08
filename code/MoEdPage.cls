VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MoEdPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ����ģ������Emerald������ ҳ������� ģ��
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim PI As Integer
'======================================

Public Sub Update()
    'Ӧ�ý���ÿһ֡ˢ�»���õķ�����ҳ����ƴ�������ڴ˴���
    
    Page.Clear '��ջ���

    Page.Writes "breaker", GW / 2, 100, 32, argb(200, 255, 83, 57), align:=StringAlignmentCenter
    Page.Writes "avoid something that won't be opened", GW / 2, 160, 20, argb(120, 0, 0, 0), align:=StringAlignmentCenter

    For I = PI * 5 + 1 To PI * 5 + 5
        If I > UBound(Breaks.List) Then Exit For
        If I < 0 Then
            PI = 0: Exit For
        End If
        With Breaks.List(I)
            Page.Writes .Title & " | " & .ClassName & " | " & .ImName, 50, 200 + (I - PI * 5) * 45, 20, argb(200, 0, 0, 0)
        End With
        Page.Writes "Delete", GW - 50, 200 + (I - PI * 5) * 45, 20, argb(180, 255, 83, 57), align:=StringAlignmentFar
        If CheckMouse(GW - 50 - 100, 200 + (I - PI * 5) * 45, 100, 40) = mMouseDown Then
            Mouse.button = 0: Mouse.State = 0
            For S = I To UBound(Breaks.List) - 1
                Breaks.List(S) = Breaks.List(S + 1)
            Next
            ReDim Preserve Breaks.List(UBound(Breaks.List) - 1)
            Open DataPath & "\break.db" For Binary As #1
            Put #1, , Breaks
            Close #1
        End If
    Next
    
    Page.Writes "< Prev", 50, 485, 20, argb(180, 255, 83, 57)
    If CheckMouse(50, 480, 75, 35) = mMouseDown Then
        Mouse.button = 0: Mouse.State = 0
        PI = PI - 1
    End If
    Page.Writes "Next >", GW - 50, 485, 20, argb(180, 255, 83, 57), align:=StringAlignmentFar
    If CheckMouse(GW - 50 - 75, 480, 75, 35) = mMouseDown Then
        Mouse.button = 0: Mouse.State = 0
        PI = PI + 1
    End If
    
    Page.Paint 0, 0, GH - 149, GW, 150, argb(255, 242, 242, 242)
    If CheckMouse2 = mMouseDown Then
        BreakTime = GetTickCount
    End If
    Page.Writes IIf(BreakTime <> 0, Int(6 - (GetTickCount - BreakTime) / 1000) & "s left ...", "TARGET"), GW / 2, GH - 100, 24, argb(255, 0, 0, 0), align:=StringAlignmentCenter

    If CheckMouse(0, 0, GW, GH) = mMouseDown And Mouse.button = 2 Then
        Mouse.button = 0: Mouse.State = 0
        ECore.NewTransform transDarkReturn, 500, "MainPage"
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
    ECore.Add Page, "MoEdPage"  '����ҳ��
    
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub