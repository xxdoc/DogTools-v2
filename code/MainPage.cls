VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MainPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ����ģ������Emerald������ ҳ������� ģ��
'======================================
'   ҳ�������
    Dim Page As GPage
'======================================

Public Sub Update()
    'Ӧ�ý���ÿһ֡ˢ�»���õķ�����ҳ����ƴ�������ڴ˴���
    
    Page.Clear argb(255, 255, 255, 255) '��ջ���

    '================================================================
    '   ʾ������������
    '   Page.Writes "��������", 20,20, Color:=argb(255, 0, 0, 0)
    '================================================================
    
    Dim pro As Single
    For I = 1 To 4
        pro = Cubic(((GetTickCount + I * 500) Mod 3000) / 3000, 0, 1, 1, 1)
        Page.Paint 1, GW / 2, GH / 2 - 50, pro * 500, pro * 500, argb(150 - 150 * pro, 195, 157, 147), pos:=posOnCenter
    Next
    Page.DrawImage "Icon.png", GW / 2, GH / 2 - 50, alpha:=1, pos:=posOnCenter
    
    Page.Writes "WELCOME " & user, GW / 2 + 1, GH / 2 + 80, 28, argb(255, 0, 0, 0), align:=StringAlignmentCenter, style:=FontStyleBold
    
    If ESave.GetData("setuptime") = "" Then ESave.PutData "setuptime", Now
    
    Dim otime As Date
    otime = Now - CDate(ESave.GetData("setuptime"))
    
    Page.Writes "Dog Tools -v2 has get along with you " & year(otime) Mod 1899 & "y" & Month(otime) Mod 12 & "m" & Day(otime) Mod 30 & "d" & Hour(otime) & "h" & Minute(otime) & "min" & Second(otime) & "s", GW / 2 + 1, GH / 2 + 240, 20, argb(180, 0, 0, 0), align:=StringAlignmentCenter
    
    If CheckMouse(0, 0, GW, GH) = mMouseDown And Mouse.button = 1 Then
        Mouse.button = 0: Mouse.State = 0
        ECore.NewTransform transDarkTo, 500, "MoEdPage"
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
    ECore.Add Page, "MainPage"  '����ҳ��
    
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub