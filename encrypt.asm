;Encryption Program               (Encrypt.asm)

; This program demonstrates simple symmetric
; encryption using the XOR instruction.

INCLUDE Irvine32.inc

BUFMAX = 128        ; maximum buffer size

.data
sPrompt  BYTE  "Enter the plain text: ",0
sEncrypt BYTE  "Cipher text:          ",0
sDecrypt BYTE  "Decrypted:            ",0
PREHEX   BYTE  "0x",0
SPACE    BYTE  " ",0

kPrompt  Byte  "Enter the key: ",0

buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?
key      BYTE   BUFMAX+1 DUP(0)
keySize  DWORD  ?

.code
main PROC
    call    InputTheString      ; input the plain text
    call    InputTheKey         ; input the key
    call    TranslateBuffer ; encrypt the buffer
    mov edx,OFFSET sEncrypt ; display encrypted message
    call    DisplayMessage

    exit
main ENDP

;-----------------------------------------------------
InputTheString PROC
;
; Prompts user for a plaintext string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
    pushad
    mov edx,OFFSET sPrompt  ; display a prompt
    call    WriteString
    mov ecx,BUFMAX      ; maximum character count
    mov edx,OFFSET buffer   ; point to the buffer
    call    ReadString          ; input the string
    mov bufSize,eax         ; save the length
    call    Crlf
    popad
    ret
InputTheString ENDP

;-----------------------------------------------------
InputTheKey PROC
;
; Prompts user for a key string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
    pushad
    mov edx,OFFSET kPrompt  ; display a prompt
    call    WriteString
    mov ecx,BUFMAX      ; maximum character count
    mov edx,OFFSET key   ; point to the buffer
    call    ReadString          ; input the string
    mov keySize,eax         ; save the length
    call    Crlf
    popad
    ret
InputTheKey ENDP


;-----------------------------------------------------
DisplayMessage PROC
;
; Displays the encrypted or decrypted message.
; Receives: EDX points to the message
; Returns:  nothing
;-----------------------------------------------------
    pushad
    mov ecx,bufSize     ; loop counter
    mov esi,0           ; index 0 in buffer

L1: 
    mov eax,0
    mov al,buffer[esi] ; translate a byte

    mov edx , OFFSET PREHEX
	call WriteString

    call WriteHex

    mov edx , OFFSET SPACE
	call WriteString

    inc esi             ; point to next byte
    loop    L1

    popad
    ret
DisplayMessage ENDP

;-----------------------------------------------------
TranslateBuffer PROC
;
; Translates the string by exclusive-ORing each
; byte with the encryption key byte.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
    pushad
    mov ecx,bufSize     ; loop counter
    mov esi,0           ; index 0 in buffer
    mov edi,keySize           ; index 0 in key


Lplaintext:
    
    cmp edi,keySize
    jnz LkeyNend
    ; edi == keySize
    mov edi,0
    jmp Lkeydealend

LkeyNend:
    inc edi
    jmp Lkeydealend

Lkeydealend:
    
    mov al,key[edi]    ; move key[edi] to al
    xor buffer[esi],al ; translate a byte
    inc esi             ; point to next byte
    loop    Lplaintext

    popad
    ret
TranslateBuffer ENDP



END main