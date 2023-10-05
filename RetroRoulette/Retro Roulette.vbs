Dim pipol, pipolQueYaSufrio, almaEnPena1, almaEnPena2
Set pipol = CreateObject("System.Collections.ArrayList")
Set pipolQueYaSufrio = CreateObject("System.Collections.ArrayList")

Dim fso, participantesFile, excluidosFile, excluidoSolitarioFile
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists("Archivos\Participantes.txt") Then
    Set participantesFile = fso.OpenTextFile("Archivos\Participantes.txt", 1)
    Do Until participantesFile.AtEndOfStream
        nombre = participantesFile.ReadLine
        If Trim(nombre) <> "" Then
            pipol.Add nombre
        End If
    Loop
    participantesFile.Close
Else
    MsgBox "El archivo 'Participantes.txt' no existe," & vbNewLine & _
    "crealo y carga los nombres por linea.." & vbNewLine & _
    "los vas a necesitar >.<" & vbNewLine & _
    "" & vbNewLine & _
    "gracias, vuelva prontos n.n"
    WScript.Quit
End If

If fso.FileExists("Archivos\Excluidos.txt") Then
    Set excluidosFile = fso.OpenTextFile("Archivos\Excluidos.txt", 1)
    Do Until excluidosFile.AtEndOfStream
        nombreExcluido = excluidosFile.ReadLine
        If Trim(nombreExcluido) <> "" Then
            pipolQueYaSufrio.Add nombreExcluido
            If pipol.Contains(nombreExcluido) Then
                pipol.Remove nombreExcluido
            End If
        End If
    Loop
    excluidosFile.Close
End If
If fso.FileExists("Archivos\ExcluidoSolitario.txt") Then
    Set excluidoSolitarioFile = fso.OpenTextFile("Archivos\ExcluidoSolitario.txt", 1)
    nombreExcluidoSolitario = excluidoSolitarioFile.ReadLine
    excluidoSolitarioFile.Close
    If Trim(nombreExcluidoSolitario) <> "" And Not pipolQueYaSufrio.Contains(nombreExcluidoSolitario) Then
        If Not pipolQueYaSufrio.Contains(nombreExcluidoSolitario) Then
            pipol.Add nombreExcluidoSolitario
        End If
    End If
End If
Function QueEmpieceLaBusqueda()
    Dim randomPipol
    If pipol.Count = 0 Then
        MsgBox "No hay Participantes disponibles." & vbNewLine & _
        "Si te olvidaste de cargar los nombres," & vbNewLine & _
        "suma a los miembros de tu squad en 'Participantes' >.<"
        WScript.Quit
    End If
    Randomize
    Do
        randomPipol = Int(Rnd * pipol.Count)
        QueEmpieceLaBusqueda = pipol(randomPipol)
    Loop Until Not pipolQueYaSufrio.Contains(QueEmpieceLaBusqueda)

    If IsEmpty(almaEnPena1) Then
        almaEnPena1 = QueEmpieceLaBusqueda
        If Not fso.FileExists("Archivos\Excluidos.txt") Then
            Set excluidosFile = fso.CreateTextFile("Archivos\Excluidos.txt")
            excluidosFile.WriteLine almaEnPena1
            excluidosFile.Close
        End If
    Else
        Do
            almaEnPena2 = QueEmpieceLaBusqueda
        Loop Until almaEnPena2 <> almaEnPena1
    End If
    pipolQueYaSufrio.Add QueEmpieceLaBusqueda
    pipol.RemoveAt randomPipol
    
    Set excluidosFile = fso.OpenTextFile("Archivos\Excluidos.txt", 8)
    excluidosFile.WriteLine QueEmpieceLaBusqueda
    excluidosFile.Close
End Function

If pipol.Count = 1 And Not pipolQueYaSufrio.Contains(pipol(0)) Then
    Set excluidoSolitarioFile = fso.CreateTextFile("Archivos\ExcluidoSolitario.txt")
    excluidoSolitarioFile.WriteLine pipol(0)
    excluidoSolitarioFile.Close
    MsgBox "Quedo solo un participante, se inicia una nueva ronda"& vbNewLine & _
           "  y quien haya quedado tiene prioridad en la misma."
    
    Set excluidosFile = fso.CreateTextFile("Archivos\Excluidos.txt", 2)
    excluidosFile.Write ""
    excluidosFile.Close
    WScript.Quit
End If

Dim fechaActual
fechaActual = Date()
Dim fechaProximaRetro
fechaProximaRetro = DateAdd("d", 14, fechaActual)

MsgBox "Bienvenid@ a la Retro Roulette :D" & vbNewLine & _
" " & vbNewLine & _
"                        \_(o_o)_/" & vbNewLine & _
" " & vbNewLine & _
"Banco Galicia, Commercial Cards."
WScript.Echo "Encargados de la proxima Retro:"
WScript.Echo QueEmpieceLaBusqueda()
WScript.Echo QueEmpieceLaBusqueda()
MsgBox "Felicitaciones a l@s winners:" & vbNewLine & _
       " " & vbNewLine & _
       "      - " & almaEnPena1 & vbNewLine & _
       "      - " & almaEnPena2 & vbNewLine & _
       " " & vbNewLine & _
       "Van a estar haciendose cargo de la proxima retro!" & vbNewLine & _
       "                            Hoy es: " & fechaActual & vbNewLine & _
       "                      Proxima Retro:" & fechaProximaRetro

If pipol.Count = 0 Then
    MsgBox "Empieza una nueva ronda!"& vbNewLine & _
    "Si hay nuevos integrantes"& vbNewLine & _
    "no te olvides de agregarl@s"
    Set excluidosFile = fso.CreateTextFile("Archivos\Excluidos.txt", 2)
    excluidosFile.Write ""
    excluidosFile.Close
    WScript.Quit
End If

Set excluidosFile = fso.CreateTextFile("Archivos\Excluidos.txt", True)
For Each nombreExcluido In pipolQueYaSufrio
    excluidosFile.WriteLine nombreExcluido
Next
excluidosFile.Close

almaEnPena1 = ""
almaEnPena2 = ""

' Desarrollado por H. Alfredo Arrieta https://www.linkedin.com/in/alfrearrieta/
' Squad Commercial Cards
' Si resolves un bug, te doy oro en un Argentum :D
' Si lo mejoras, te doy un bless en un Mu >.<
' Si te cai bien, se aprecia y desea un muy buen dia! n.n