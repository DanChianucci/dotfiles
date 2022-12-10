Attribute VB_Name = "utilities"

''' From the Tools menu, choose "Macro", and "Record Macro".
''' In the drop-down list, choose "Personal Macro Workbook".
''' Click on OK, and then stop recording.
'''
''' This will create a personal macro if you don't have any.
'''
''' Press Alt-F11 to bring up VBA.
''' In the left pane, choose "VBA Project (Personal.xls)"
''' Then double-click on module1.
'''
''' Import your macro.
''' Exit Excel.
'''
''' When you next open Excel, the personal macro will be available.




''' Reverses the input string using the given chunk size
''' <param name="str">The string to reverse</param>
''' <param name="places">The number of characters to chunk together</param>
''' <returns> The Reversed String</returns>
Public Function reverse(ByVal str As String, Optional places As Integer = 1) As String
      Dim idx    As Long
      Dim strReturn  As String
      strReturn = ""
      str = Trim(str)
      For idx = 1 To Len(str) Step places
        strReturn = Mid(str, idx, places) & strReturn
      Next idx
      reverse = strReturn
End Function

''' Resizes a string by padding or truncating
''' <param name="str"    >The string to resize</param>
''' <param name="places" >The new size</param>
''' <param name="padchar">The character to pad with</param>
''' <param name="left"   >Whether to pad/truncate on the left/right</param>
''' <returns>The original string resized by padding or truncation</returns>
Public Function resize(str As String, places As Integer, Optional padchar As String = "0", Optional left As Boolean = True) As String
  If places > Len(str) Then
    resize = pad(str, padchar, places, left)
  ElseIf places < Len(str) Then
    resize = truncate(str, places, left)
  Else
    resize = str
  End If
End Function

''' Resizes a string to be larger by padding
''' <param name="str"    >The string to resize</param>
''' <param name="places" >The new size</param>
''' <param name="padchar">The character to pad with</param>
''' <param name="left"   >Whether to pad on the left/right</param>
''' <returns>The original string resized by padding</returns>
Public Function pad(str As String, padchar As String, places As Integer, Optional left As Boolean = True) As String
    If left Then
        pad = String(places - Len(str), padchar) & str
    Else
        pad = str & String(places - Len(str), padchar)
    End If
End Function

''' Resizes a string to be smaller by truncating
''' <param name="str"    >The string to resize</param>
''' <param name="places" >The new size</param>
''' <param name="left"   >Whether to truncate on the left/right</param>
''' <returns>The original string resized by padding or truncation</returns>
Public Function truncate(str As String, places As Integer, Optional left As Boolean = True) As String
  If left Then
    truncate = Mid(str, Len(str) - places + 1, places)
  Else
    truncate = Mid(str, 1, places)
  End If
End Function





Public Function swap_bits(str As String) As String
  str = Trim(str)
  i = Len(str) Mod 2
  str = pad(str, "0", Len(str) + i)
  res = ""
  Dim bb, rr, hh As String

  For i = 1 To Len(str) Step 2
    substr = Mid(str, i, 2)
    bb = WorksheetFunction.hex2bin(substr, 8)
    rr = Reversestr(bb)
    hh = WorksheetFunction.bin2hex(rr, 2)
    res = res & hh
  Next i

  swap_bits = res
End Function


Public Function log2(val As Double) As Double
  log2 = WorksheetFunction.Log(val, 2)
End Function

Public Function clog2(val As Double) As Integer
  clog2 = WorksheetFunction.Ceiling(log2(val), 1)
End Function

Public Function hxor(hex1 As String, hex2 As String) As String
  Dim h1 As String
  Dim h2 As String
  Dim l As Integer
  Dim res As String
  Dim nib As String
  h1 = Trim(hex1)
  h2 = Trim(hex2)
  l = WorksheetFunction.Max(Len(h1), Len(h2))
  l = l + (l Mod 2)
  h1 = pad(h1, "0", l)
  h2 = pad(h2, "0", l)

  res = ""
  For i = 1 To l Step 1
    s1 = WorksheetFunction.hex2bin(Mid(h1, i, 1), 4)
    s2 = WorksheetFunction.hex2bin(Mid(h2, i, 1), 4)
    nib = ""
    For j = 1 To 4 Step 1
      If Mid(s1, j, 1) = Mid(s2, j, 1) Then
        nib = nib & "0"
      Else
        nib = nib & "1"
      End If
    Next j
    res = res & WorksheetFunction.bin2hex(nib, 1)
  Next i
  hxor = res
End Function

Public Function hex2bin_ddc(hex As String, places As Integer) As String
  hex = Trim(hex)
  i = Len(hex) Mod 2
  hex = pad(hex, "0", Len(hex) + i)
  Dim res As String
  res = ""
  For i = 1 To Len(hex) Step 1
    substr = Mid(hex, i, 1)
    bb = WorksheetFunction.hex2bin(substr, 4)
    res = res & bb
  Next i
  hex2bin_ddc = resize(res, places)
End Function

Public Function bin2hex_ddc(bin As String, places As Integer) As String
  bin = Trim(bin)
  i = Len(bin) Mod 8
  bin = pad(bin, "0", Len(bin) + i)
  Dim res As String
  res = ""
  For i = 1 To Len(bin) Step 4
    substr = Mid(bin, i, 1)
    bb = WorksheetFunction.bin2hex(substr, 2)
    res = res & bb
  Next i
  bin2hex_ddc = resize(res, places)
End Function
